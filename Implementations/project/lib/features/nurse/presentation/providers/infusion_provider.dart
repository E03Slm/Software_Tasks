import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/features/nurse/domain/models/infusion_session.dart';
import 'package:project/features/nurse/domain/models/alarm.dart';
import 'package:project/features/nurse/domain/enums/alarm_type.dart';
import 'package:project/features/nurse/domain/enums/severity_level.dart';
import 'package:project/features/doctor/domain/models/drug.dart';
import 'package:project/features/nurse/data/repositories/alarm_repository.dart';
import 'package:project/features/doctor/data/repositories/audit_repository.dart';
import 'package:project/features/doctor/domain/models/audit_log.dart';
import 'package:project/features/auth/presentation/providers/auth_provider.dart';
import 'package:project/features/nurse/data/repositories/session_repository.dart';
import 'package:project/features/nurse/domain/models/alarm_definition.dart';
import 'audit_log_provider.dart';

part 'infusion_provider.g.dart';

// ─── Providers ──────────────────────────────────────────────────────────────
final auditRepositoryProvider = Provider((ref) => AuditRepository());
final sessionRepositoryProvider = Provider((ref) {
  final audit = ref.watch(auditRepositoryProvider);
  return SessionRepository(audit);
});
final alarmRepositoryProvider = Provider((ref) {
  final audit = ref.watch(auditRepositoryProvider);
  return AlarmRepository(audit);
});

final alarmDefinitionsProvider = FutureProvider<List<AlarmDefinition>>((ref) async {
  return ref.watch(alarmRepositoryProvider).fetchDefinitions();
});

@riverpod
class AlarmNotifier extends _$AlarmNotifier {
  @override
  List<Alarm> build() {
    // We removed ref.watch/ref.listen to infusionProvider to break the circular dependency.
    // Hydration is now triggered explicitly by InfusionNotifier or by the UI.
    return [];
  }

  /// Explicitly load alarms for a session. Called by InfusionNotifier to keep data in sync.
  Future<void> hydrate(String sessionId) async {
    if (sessionId.isEmpty) return;
    try {
      final alarms = await ref.read(alarmRepositoryProvider).fetchAlarmsForSession(sessionId);
      state = alarms;
      print('DEBUG: AlarmNotifier hydrated ${alarms.length} alarms');
    } catch (e) {
      print('DEBUG: Failed to hydrate alarms: $e');
    }
  }

  Future<void> add(AlarmType type, AlarmSeverity severity, String sessionId, {AlarmDefinition? definition}) async {
    if (sessionId.isEmpty) return;
    
    final typeName = type.name.replaceAll('_', ' ').toUpperCase();
    
    // Use provided definition or find one from the list
    final AlarmDefinition finalDef;
    if (definition != null) {
      finalDef = definition;
    } else {
      final definitions = await ref.read(alarmDefinitionsProvider.future);
      finalDef = definitions.firstWhere(
        (d) => d.name.toUpperCase() == typeName,
        orElse: () => AlarmDefinition(
          id: '', 
          name: typeName,
          severity: severity.name.toUpperCase(),
          description: 'System triggered ${type.name} alert',
        ),
      );
    }

    final alarm = Alarm(
      id: const Uuid().v4(),
      sessionId: sessionId,
      alarmId: finalDef.id,
      alarmTime: DateTime.now(),
      type: finalDef.name,
      ackRes: false,
      definition: finalDef,
    );
    
    state = [...state, alarm];
    
    try {
      print('DEBUG: AlarmNotifier.add calling saveSession and saveAlarm for sessionId: ${alarm.sessionId}');
      await ref.read(sessionRepositoryProvider).saveSession(ref.read(infusionProvider));
      await ref.read(alarmRepositoryProvider).saveAlarm(alarm, ref.read(authProvider)?.id ?? 'SYSTEM');
      print('DEBUG: AlarmNotifier.add save success');
      
      // Invalidate history to keep everything in sync
      ref.invalidate(alarmHistoryProvider);
    } catch (e) {
      print('CRITICAL: Failed to link alarm to DB: $e');
    }
  }

  Future<void> acknowledge(String alarmId) async {
    final currentUser = ref.read(authProvider);
    Alarm? updatedAlarm;
    state = state.map((a) {
      if (a.id == alarmId) {
        updatedAlarm = a.copyWith(
          ackRes: true,
          ackResAt: DateTime.now(),
          ackResBy: currentUser?.id,
        );
        return updatedAlarm!;
      }
      return a;
    }).toList();

    if (updatedAlarm != null) {
      try {
        await ref.read(alarmRepositoryProvider).updateAlarm(updatedAlarm!, currentUser?.id ?? 'SYSTEM');
        
        // Log acknowledgement
        ref.read(auditRepositoryProvider).logAction(
          actionType: 'ALARM_ACKNOWLEDGED',
          entityType: 'ALARM',
          entityId: alarmId,
          newValue: {'alarm_id': updatedAlarm!.alarmId, 'severity': updatedAlarm!.definition?.severity},
          performerId: currentUser?.id,
        );
      } catch (e) {
        print('Failed to update alarm: $e');
      }
    }
  }

  Future<void> resolve(String alarmId) async {
    final currentUser = ref.read(authProvider);
    Alarm? updatedAlarm;
    state = state.map((a) {
      if (a.id == alarmId) {
        updatedAlarm = a.copyWith(
          ackRes: true,
          ackResAt: DateTime.now(),
          ackResBy: currentUser?.id,
        );
        return updatedAlarm!;
      }
      return a;
    }).toList();

    if (updatedAlarm != null) {
      try {
        await ref.read(alarmRepositoryProvider).updateAlarm(updatedAlarm!, currentUser?.id ?? 'SYSTEM');
        
        // Log resolution
        ref.read(auditRepositoryProvider).logAction(
          actionType: 'ALARM_RESOLVED',
          entityType: 'ALARM',
          entityId: alarmId,
          newValue: {'alarm_id': updatedAlarm!.alarmId, 'severity': updatedAlarm!.definition?.severity},
          performerId: currentUser?.id,
        );
      } catch (e) {
        print('Failed to update alarm: $e');
      }
    }
  }

  void clearAll() => state = [];

  List<Alarm> get active => state.where((a) => !a.ackRes).toList();
  
  bool get canContinue {
    // 1. All alarms must be handled (ackRes)
    final unhandled = state.any((a) => !a.ackRes);
    if (unhandled) return false;

    // 2. High and Critical alarms must be resolved (solved)
    // For now, ackRes covers resolution in this simplified schema
    return true;
  }
}

// ─── Battery Provider ────────────────────────────────────────────────────────
@riverpod
class BatteryNotifier extends _$BatteryNotifier {
  Timer? _timer;

  @override
  double build() {
    ref.onDispose(() => _timer?.cancel());
    return 100.0;
  }

  void startDrain(String sessionId) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = (state - 1).clamp(0, 100);

      if (state <= 5.0 && state > 4.9) {
        ref.read(alarmProvider.notifier).add(
              AlarmType.batteryCritical,
              AlarmSeverity.critical,
              sessionId,
            );
        // Auto-emergency stop on critical battery
        ref.read(infusionProvider.notifier).emergencyStop();
      } else if (state <= 20.0 && state > 19.9) {
        ref.read(alarmProvider.notifier).add(
              AlarmType.batteryLow,
              AlarmSeverity.medium,
              sessionId,
            );
      }
    });
  }

  void stopDrain() => _timer?.cancel();

  void reset() {
    _timer?.cancel();
    state = 100.0;
  }
}

// ─── Infusion FSM Provider ───────────────────────────────────────────────────
@Riverpod(keepAlive: true)
class InfusionNotifier extends _$InfusionNotifier {
  Timer? _tickTimer;

  @override
  InfusionSession build() => InfusionSession.initial();

  // ── Setup ─────────────────────────────────────────────────────────────────
  void selectDrug(Drug drug) {
    state = state.copyWith(
      drug: drug,
      infusionRate: drug.defaultRate,
      status: 'Programming',
    );
    _syncDoseFromRate();
    
    _logAction(
      'DRUG_SELECTED',
      newValue: {'drug_name': drug.name, 'default_rate': drug.defaultRate},
    );
  }

  void updateWeight(double weight) {
    final oldWeight = state.patientWeight;
    state = state.copyWith(patientWeight: weight);
    if (state.targetDose != null) {
      _syncRateFromDose();
    }
    
    _logAction(
      'WEIGHT_UPDATED',
      oldValue: {'weight': oldWeight},
      newValue: {'weight': weight},
    );
  }

  void updateDose(double dose) {
    final oldDose = state.targetDose;
    state = state.copyWith(targetDose: dose);
    _syncRateFromDose();

    _logAction(
      'TITRATION_DOSE',
      oldValue: {'dose': oldDose},
      newValue: {'dose': dose, 'calculated_rate': state.infusionRate},
    );
  }

  void updateRate(double rate) {
    final oldRate = state.infusionRate;
    state = state.copyWith(infusionRate: rate);
    _syncDoseFromRate();

    _logAction(
      'TITRATION_RATE',
      oldValue: {'rate': oldRate},
      newValue: {'rate': rate, 'calculated_dose': state.targetDose},
    );
  }

  void setParameters({
    required double infusionRate,
    required double totalVolume,
    String? patientId,
    double? bolusDose,
  }) {
    final drug = state.drug;
    if (drug != null && drug.hardLimitHigh > 0 && infusionRate > drug.hardLimitHigh) {
      ref.read(alarmProvider.notifier).add(
        AlarmType.hardLimitExceeded,
        AlarmSeverity.critical,
        state.id,
      );
      _logAction('LIMIT_BLOCK', newValue: {'rate': infusionRate, 'limit': drug.hardLimitHigh});
      return; // Prevent setting parameters
    }

    final oldParams = {
      'rate': state.infusionRate, 
      'volume': state.totalVolume,
      'patient_id': state.patientId,
    };
    state = state.copyWith(
      infusionRate: infusionRate,
      totalVolume: totalVolume,
      patientId: patientId,
      status: 'Programming',
    );
    _syncDoseFromRate();

    _logAction(
      'PARAMETERS_SET',
      oldValue: oldParams,
      newValue: {'rate': infusionRate, 'volume': totalVolume, 'patient_id': patientId},
    );
  }

  // ── Calculation Helpers ───────────────────────────────────────────────────
  void _syncRateFromDose() {
    final drug = state.drug;
    final dose = state.targetDose;
    if (drug == null || dose == null) return;

    double concInMcg = drug.concentration;
    if (drug.concentrationUnit.toLowerCase().contains('mg')) {
      concInMcg *= 1000;
    }

    final calculatedRate = (dose * state.patientWeight * 60) / concInMcg;
    state = state.copyWith(infusionRate: calculatedRate);
  }

  void _syncDoseFromRate() {
    final drug = state.drug;
    if (drug == null || state.infusionRate <= 0 || state.patientWeight <= 0) return;

    double concInMcg = drug.concentration;
    if (drug.concentrationUnit.toLowerCase().contains('mg')) {
      concInMcg *= 1000;
    }

    final calculatedDose = (state.infusionRate * concInMcg) / (state.patientWeight * 60);
    state = state.copyWith(targetDose: calculatedDose);
  }

  // ── Bolus Support ────────────────────────────────────────────────────────
  Future<void> deliverBolus(double doseMcg) async {
    if (state.status != 'Infusing' && state.status != 'KVO') return;
    
    final drug = state.drug;
    if (drug == null) return;

    double concInMcg = drug.concentration;
    if (drug.concentrationUnit.toLowerCase().contains('mg')) {
      concInMcg *= 1000;
    }

    final volumeToDeliver = doseMcg / concInMcg;
    
    _logAction('BOLUS_START', newValue: {'dose_mcg': doseMcg, 'volume_ml': volumeToDeliver});

    final prevStatus = state.status;
    final prevRate = state.infusionRate;
    
    state = state.copyWith(
      status: 'Bolus',
      infusionRate: 500.0,
    );

    await Future.delayed(const Duration(seconds: 2));
    
    state = state.copyWith(
      volumeInfused: state.volumeInfused + volumeToDeliver,
      status: prevStatus,
      infusionRate: prevRate,
    );
    
    _logAction('BOLUS_COMPLETE', newValue: {'volume_added': volumeToDeliver});
  }

  // ── FSM Transitions ───────────────────────────────────────────────────────
  Future<void> start() async {
    if (state.status != 'Programming' && state.status != 'Paused' && state.status != 'Stopped' && state.status != 'Alarm') {
      return;
    }

    // Safety Check: Enforce alarm acknowledgment and resolution
    if (!ref.read(alarmProvider.notifier).canContinue) {
      return;
    }

    final drug = state.drug;
    if (drug != null) {
      if (state.infusionRate > drug.hardLimitHigh && drug.hardLimitHigh > 0) {
        ref.read(alarmProvider.notifier).add(
          AlarmType.hardLimitExceeded,
          AlarmSeverity.critical,
          state.id,
        );
        _logAction('LIMIT_BLOCK', newValue: {'rate': state.infusionRate, 'limit': drug.hardLimitHigh});
        return;
      }
      
      if (drug.softLimitHigh != null && state.infusionRate > drug.softLimitHigh!) {
        ref.read(alarmProvider.notifier).add(
          AlarmType.softLimitWarning,
          AlarmSeverity.medium,
          state.id,
        );
        _logAction('LIMIT_WARNING', newValue: {'rate': state.infusionRate, 'limit': drug.softLimitHigh});
      }
    }

    final sessionId = state.id.isEmpty ? const Uuid().v4() : state.id;
    final currentUser = ref.read(authProvider);

    state = state.copyWith(
      id: sessionId,
      userId: currentUser?.id,
      status: 'Infusing',
      startTime: state.startTime ?? DateTime.now(),
    );

    _startTick();
    ref.read(batteryProvider.notifier).startDrain(sessionId);
    
    await _logAction('INFUSION_STARTED', newValue: {'rate': state.infusionRate, 'drug': drug?.name});
  }

  void pause() {
    if (state.status != 'Infusing') return;
    _stopTick();
    ref.read(batteryProvider.notifier).stopDrain();
    state = state.copyWith(status: 'Paused');
    _logAction('INFUSION_PAUSED');
  }

  Future<void> resume() async {
     await start();
     _logAction('RESUME_INFUSION');
  }

  void stop() {
    _stopTick();
    ref.read(batteryProvider.notifier).stopDrain();
    state = state.copyWith(status: 'Stopped');
    _logAction('INFUSION_STOPPED', newValue: {'total_infused': state.volumeInfused});
  }

  Future<void> emergencyStop() async {
    _stopTick();
    ref.read(batteryProvider.notifier).stopDrain();
    
    state = state.copyWith(status: 'EmergencyStop');
    
    if (state.id.isNotEmpty) {
      await ref.read(alarmProvider.notifier).add(
            AlarmType.emergencyStop,
            AlarmSeverity.critical,
            state.id,
          );
    }
    
    await _logAction('EMERGENCY_STOP');
  }

  Future<void> triggerAlarm(AlarmType type, AlarmSeverity severity, {AlarmDefinition? definition}) async {
    // 1. Log the alarm event (this also ensures the session exists in DB)
    await _logAction('ALARM_TRIGGERED', newValue: {
      'type': definition?.name ?? type.name,
      'severity': definition?.severity ?? severity.name
    });

    // 2. Add to active alarms
    await ref.read(alarmProvider.notifier).add(
          type,
          severity,
          state.id,
          definition: definition,
        );

    // 3. Handle clinical impact
    final finalSeverity = definition != null 
        ? _mapSeverity(definition.severity)
        : severity;

    switch (finalSeverity) {
      case AlarmSeverity.critical:
      case AlarmSeverity.high:
        _stopTick();
        ref.read(batteryProvider.notifier).stopDrain();
        state = state.copyWith(status: 'Alarm');
        break;
      case AlarmSeverity.medium:
        // Medium severity pauses the infusion
        pause();
        break;
      case AlarmSeverity.low:
        // Low/Advisory: No interruption to infusion delivery
        break;
    }
  }

  AlarmSeverity _mapSeverity(String severity) {
    switch (severity.toUpperCase()) {
      case 'CRITICAL': return AlarmSeverity.critical;
      case 'HIGH': return AlarmSeverity.high;
      case 'MEDIUM': return AlarmSeverity.medium;
      case 'LOW': return AlarmSeverity.low;
      default: return AlarmSeverity.low;
    }
  }

  Future<void> _logAction(String type, {Map<String, dynamic>? oldValue, Map<String, dynamic>? newValue}) async {
    // Ensure session exists in DB for foreign key integrity
    try {
      final currentUser = ref.read(authProvider);
      final sessionToSave = state.id.isEmpty 
          ? state.copyWith(id: const Uuid().v4(), userId: currentUser?.id)
          : state.copyWith(userId: currentUser?.id);
      
      if (state.id.isEmpty) {
        state = sessionToSave;
      }

      print('DEBUG: InfusionNotifier._logAction saving session: ${sessionToSave.id}');
      await ref.read(sessionRepositoryProvider).saveSession(sessionToSave);
      // Keep alarm state in sync with DB
      await ref.read(alarmProvider.notifier).hydrate(sessionToSave.id);
      print('DEBUG: InfusionNotifier._logAction session save success');
    } catch (e) {
      print('DEBUG: InfusionNotifier._logAction session save failed: $e');
    }

    final currentUser = ref.read(authProvider);
    print('DEBUG: InfusionNotifier._logAction logging: $type');
    await ref.read(auditRepositoryProvider).logAction(
      actionType: type,
      entityType: 'INFUSION_SESSION',
      entityId: state.id,
      oldValue: oldValue,
      newValue: newValue,
      performerId: currentUser?.id,
    );
    print('DEBUG: InfusionNotifier._logAction log success');
    
    // Refresh the session logs UI if it's currently open
    ref.invalidate(sessionLogsProvider);
  }


  void resolveAlarm() {
    if (state.status != 'Alarm') return;
    state = state.copyWith(status: 'Programming');
  }

  void reset() {
    _stopTick();
    ref.read(batteryProvider.notifier).reset();
    ref.read(alarmProvider.notifier).clearAll();
    state = InfusionSession.initial();
  }

  // ── Tick Logic ────────────────────────────────────────────────────────────
  void _startTick() {
    _tickTimer?.cancel();
    _tickTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _onTick(),
    );
  }

  void _stopTick() => _tickTimer?.cancel();

  void _onTick() {
    final session = state;
    if (state.status != 'Infusing' && state.status != 'KVO' && state.status != 'Bolus') {
      return;
    }

    // Occasional random occlusion simulation
    if (state.status == 'Infusing' && DateTime.now().second % 59 == 0 && (DateTime.now().millisecond % 500 == 0)) {
       triggerAlarm(AlarmType.occlusion, AlarmSeverity.high);
       return;
    }

    final ratePerSecond = session.infusionRate / 3600.0;
    final newVolumeInfused = session.volumeInfused + ratePerSecond;
    final newVolumeRemaining = session.totalVolume - newVolumeInfused;

    // Complete condition
    if (newVolumeRemaining <= 0) {
      if (session.kvoEnabled) {
        state = session.copyWith(
          volumeInfused: session.totalVolume,
          status: 'KVO',
          infusionRate: session.kvoRate ?? 1.0,
        );
        _logAction('TRANSITION_KVO');
      } else {
        _stopTick();
        ref.read(batteryProvider.notifier).stopDrain();
        state = session.copyWith(
          volumeInfused: session.totalVolume,
          status: 'Stopped',
        );
        _logAction('INFUSION_COMPLETE');
      }
      return;
    }

    // Update session values
    state = session.copyWith(
      volumeInfused: newVolumeInfused,
    );

    // Log to Supabase periodically (every ~1mL) to avoid excessive noise
    if (newVolumeInfused % 1.0 < ratePerSecond) {
      _logAction('TICK_UPDATE', newValue: {'volume_infused': newVolumeInfused.toStringAsFixed(2)});
    }
  }

  // ── Computed Getters ──────────────────────────────────────────────────────
  Duration get timeRemaining {
    if (state.infusionRate <= 0) return Duration.zero;
    final hoursLeft = state.volumeRemaining / state.infusionRate;
    return Duration(seconds: (hoursLeft * 3600).round());
  }

  double get progressFraction {
    if (state.totalVolume <= 0) return 0;
    return (state.volumeInfused / state.totalVolume).clamp(0.0, 1.0);
  }
}


