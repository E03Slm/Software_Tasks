import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/features/doctor/domain/models/audit_log.dart';
import 'package:project/features/nurse/domain/models/alarm.dart';
import 'infusion_provider.dart';

final sessionLogsProvider = StreamProvider.autoDispose<List<AuditLog>>((ref) {
  final sessionId = ref.watch(infusionProvider.select((s) => s.id));
  if (sessionId.isEmpty) return Stream.value([]);
  
  final repo = ref.watch(auditRepositoryProvider);
  return repo.streamLogsForSession(sessionId);
});

final alarmHistoryProvider = StreamProvider.autoDispose<List<Alarm>>((ref) {
  final sessionId = ref.watch(infusionProvider.select((s) => s.id));
  if (sessionId.isEmpty) return Stream.value([]);
  
  final repo = ref.watch(alarmRepositoryProvider);
  return repo.streamAlarmsForSession(sessionId);
});
