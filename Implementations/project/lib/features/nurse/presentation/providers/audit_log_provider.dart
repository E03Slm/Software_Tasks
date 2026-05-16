import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/features/doctor/domain/models/audit_log.dart';
import 'package:project/features/nurse/domain/models/alarm.dart';
import 'infusion_provider.dart';

final sessionLogsProvider = FutureProvider.autoDispose<List<AuditLog>>((ref) async {
  final sessionId = ref.watch(infusionProvider.select((s) => s.id));
  if (sessionId.isEmpty) return [];
  
  final repo = ref.watch(auditRepositoryProvider);
  return repo.fetchLogsForSession(sessionId);
});

final alarmHistoryProvider = FutureProvider.autoDispose<List<Alarm>>((ref) async {
  final sessionId = ref.watch(infusionProvider.select((s) => s.id));
  if (sessionId.isEmpty) return [];
  
  // 1. Include real-time memory alarms for immediate feedback
  final memoryAlarms = ref.watch(alarmProvider);
  
  // 2. Fetch historical alarms from DB
  final repo = ref.watch(alarmRepositoryProvider);
  final dbAlarms = await repo.fetchAlarmsForSession(sessionId);
  
  // 3. Merge and deduplicate
  final allAlarms = <String, Alarm>{};
  for (final a in dbAlarms) {
    allAlarms[a.id] = a;
  }
  for (final a in memoryAlarms) {
    allAlarms[a.id] = a; // Memory state takes precedence for active alarms
  }
  
  final result = allAlarms.values.toList();
  result.sort((a, b) => b.displayTime.compareTo(a.displayTime));
  return result;
});
