import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/features/doctor/domain/models/audit_log.dart';
import 'package:project/features/nurse/domain/models/alarm.dart';
import 'infusion_provider.dart';

final sessionLogsProvider = FutureProvider.autoDispose<List<AuditLog>>((ref) async {
  final sessionId = ref.watch(infusionProvider.select((s) => s.id));
  if (sessionId.isEmpty) return [];
  
  final repo = ref.watch(auditRepositoryProvider);
  final allLogs = await repo.fetchLogsForEntity(sessionId);

  const sessionActions = {
    'INFUSION_STARTED',
    'INFUSION_PAUSED',
    'INFUSION_STOPPED',
    'EMERGENCY_STOP',
    'ALARM_TRIGGERED',
  };

  return allLogs.where((log) => sessionActions.contains(log.action)).toList();
});

final alarmHistoryProvider = FutureProvider.autoDispose<List<Alarm>>((ref) async {
  final sessionId = ref.watch(infusionProvider.select((s) => s.id));
  if (sessionId.isEmpty) return [];
  
  final repo = ref.watch(alarmRepositoryProvider);
  return repo.fetchAlarmsForSession(sessionId);
});
