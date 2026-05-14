import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'models/infusion_session.dart';
import 'models/infusion_state.dart';
import 'models/drug.dart';
import '../nurse_repository.dart';
import '../../auth/auth_repository.dart';
import '../../doctor/doctor_repository.dart';

part 'infusion_state_machine.g.dart';

@riverpod
class InfusionNotifier extends _$InfusionNotifier {
  Timer? _simulationTimer;
  int _tickCount = 0;

  @override
  InfusionSession build() {
    ref.onDispose(() => _simulationTimer?.cancel());
    return InfusionSession.initial();
  }

  Future<void> start() async {
    if (state.currentState == InfusionState.idle || state.currentState == InfusionState.programming) {
      final user = ref.read(authRepositoryProvider);
      state = state.copyWith(
        nurseId: user?.id ?? '',
        id: state.id.isEmpty ? 'SES-${DateTime.now().millisecondsSinceEpoch}' : state.id,
      );
      
      _transitionTo(InfusionState.running);
      _startSimulation();
      await _persistAndAudit('START_INFUSION');
    }
  }

  Future<void> pause() async {
    if (state.currentState == InfusionState.running) {
      _transitionTo(InfusionState.paused);
      _stopSimulation();
      await _persistAndAudit('PAUSE_INFUSION');
    }
  }

  Future<void> resume() async {
    if (state.currentState == InfusionState.paused) {
      _transitionTo(InfusionState.running);
      _startSimulation();
      await _persistAndAudit('RESUME_INFUSION');
    }
  }

  Future<void> stop() async {
    if (state.currentState != InfusionState.idle) {
      _transitionTo(InfusionState.idle);
      _stopSimulation();
      await _persistAndAudit('STOP_INFUSION');
    }
  }

  Future<void> emergencyStop() async {
    _transitionTo(InfusionState.emergencyStop);
    _stopSimulation();
    await _persistAndAudit('EMERGENCY_STOP');
  }

  void triggerAlarm() {
    if (state.currentState == InfusionState.running) {
      _transitionTo(InfusionState.alarm);
    }
  }

  Future<void> resolveAlarm() async {
    if (state.currentState == InfusionState.alarm) {
      _transitionTo(InfusionState.running);
      _startSimulation();
      await _persistAndAudit('RESOLVE_ALARM');
    }
  }

  void _transitionTo(InfusionState next) {
    state = state.copyWith(currentState: next);
  }

  Future<void> _persistAndAudit(String action) async {
    final repository = ref.read(nurseRepositoryProvider.notifier);
    final doctorRepo = ref.read(doctorRepositoryProvider.notifier);
    
    // Save to Supabase
    await repository.saveInfusionSession(state);
    
    // Log Audit
    await doctorRepo.saveAuditLog(
      action: action,
      entityId: state.id,
      entityType: 'infusion_session',
      newValue: 'State: ${state.currentState.name}, Vol: ${state.volumeInfused.toStringAsFixed(1)}',
    );
  }

  void _startSimulation() {
    _simulationTimer?.cancel();
    _simulationTimer = Timer.periodic(const Duration(seconds: 1), (_) => _onSimulationTick());
  }

  void _stopSimulation() {
    _simulationTimer?.cancel();
    _simulationTimer = null;
    _tickCount = 0;
  }

  void _onSimulationTick() {
    if (state.currentState != InfusionState.running &&
        state.currentState != InfusionState.kvo) return;

    final ratePerSecond = state.infusionRate / 3600; 
    final newVolumeInfused = state.volumeInfused + ratePerSecond;
    final newVolumeRemaining = state.totalVolume - newVolumeInfused;

    if (newVolumeRemaining <= 0) {
      if (state.kvoEnabled == true) {
        _transitionTo(InfusionState.kvo);
      } else {
        _transitionTo(InfusionState.complete);
        _stopSimulation();
      }
      state = state.copyWith(
        volumeInfused: state.totalVolume,
        volumeRemaining: 0,
      );
      _persistAndAudit('INFUSION_COMPLETE');
      return;
    }

    state = state.copyWith(
      volumeInfused: newVolumeInfused,
      volumeRemaining: newVolumeRemaining,
    );

    // Log to Supabase every 60s
    _tickCount++;
    if (_tickCount >= 60) {
      _tickCount = 0;
      ref.read(nurseRepositoryProvider.notifier).saveInfusionSession(state);
    }
  }

  void updateParameters({
    required Drug drug,
    required String patientId,
    required double rate,
    required double totalVolume,
  }) {
    state = state.copyWith(
      drug: drug,
      patientId: patientId,
      infusionRate: rate,
      totalVolume: totalVolume,
      volumeRemaining: totalVolume,
      currentState: InfusionState.programming,
    );
  }
}
