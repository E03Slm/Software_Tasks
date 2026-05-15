import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/alarm.dart';
import '../../domain/models/alarm_definition.dart';
import '../../../doctor/data/repositories/audit_repository.dart';

class AlarmRepository {
  final _client = Supabase.instance.client;
  final AuditRepository _auditRepo;

  AlarmRepository(this._auditRepo);

  Future<List<AlarmDefinition>> fetchDefinitions() async {
    final response = await _client.from('alarms').select();
    final list = response as List;
    return list
        .where((json) => json['alarm_id'] != null && json['alarm_name'] != null)
        .map((json) => AlarmDefinition.fromJson(json))
        .toList();
  }

  Future<void> saveAlarm(Alarm alarm, String userId) async {
    try {
      final data = {
        'event_id': alarm.id,
        'session_id': alarm.sessionId,
        'alarm_id': alarm.alarmId,
        'timestamp': alarm.alarmTime.toIso8601String(),
        'ack_res': alarm.ackRes,
        'ack_res_by': alarm.ackResBy,
        'ack_res_at': alarm.ackResAt?.toIso8601String(),
      };

      await _client.from('alarm').insert(data);

      await _auditRepo.logAction(
        actionType: 'TRIGGER_ALARM',
        entityType: 'ALARM',
        entityId: alarm.id,
        performerId: userId,
        newValue: data,
      );
    } catch (e) {
      print('DEBUG: AlarmRepository.saveAlarm error: $e');
      rethrow;
    }
  }

  Future<void> updateAlarm(Alarm alarm, String userId) async {
    final updateData = {
      'ack_res': alarm.ackRes,
      'ack_res_by': alarm.ackResBy,
      'ack_res_at': alarm.ackResAt?.toIso8601String(),
    };

    await _client.from('alarm').update(updateData).eq('event_id', alarm.id);

    await _auditRepo.logAction(
      actionType: 'ACKNOWLEDGE_ALARM',
      entityType: 'ALARM',
      entityId: alarm.id,
      performerId: userId,
      newValue: updateData,
    );
  }

  Future<List<Alarm>> fetchAlarmsForSession(String sessionId) async {
    final response = await _client
        .from('alarm')
        .select('*, definition:alarms(*)')
        .eq('session_id', sessionId)
        .order('timestamp', ascending: false);
    
    final list = response as List;
    return list
        .where((json) => json['event_id'] != null)
        .map((json) => Alarm.fromJson(json))
        .toList();
  }

  Stream<List<Alarm>> streamAlarmsForSession(String sessionId) {
    // Note: Supabase stream doesn't support joins directly in the same way as select.
    // We might need to map it in the provider or use a view.
    return _client
        .from('alarm')
        .stream(primaryKey: ['event_id'])
        .eq('session_id', sessionId)
        .order('timestamp', ascending: false)
        .map((data) => data.map((json) => Alarm.fromJson(json)).toList());
  }
}
