import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/alarm.dart';
import '../../domain/models/alarm_definition.dart';

class AlarmRepository {
  final _client = Supabase.instance.client;

  Future<List<AlarmDefinition>> fetchDefinitions() async {
    try {
      final response = await _client.from('alarms').select();
      final list = response as List;
      return list
          .where((json) => json['alarm_id'] != null && json['alarm_name'] != null)
          .map((json) => AlarmDefinition.fromJson(json))
          .toList();
    } catch (e) {
      // Fallback if the 'alarms' master table hasn't been created yet
      print('Warning: alarms table not found, using direct alarm records.');
      return [];
    }
  }

  Future<void> saveAlarm(Alarm alarm) async {
    try {
      await _client.from('alarm').insert({
        'alarm_id': alarm.id,
        'session_id': alarm.sessionId,
        'timestamp': alarm.timestamp.toIso8601String(),
        'acknowledged': alarm.acknowledged,
        'resolved': alarm.resolved,
        'type': alarm.type,
        'severity': alarm.severity,
        'description': alarm.description,
      });
    } catch (e) {
      print('DEBUG: AlarmRepository.saveAlarm error: $e');
      rethrow;
    }
  }

  Future<void> updateAlarm(Alarm alarm) async {
    await _client.from('alarm').update({
      'acknowledged': alarm.acknowledged,
      'acknowledged_by': alarm.acknowledgedBy,
      'acknowledged_at': alarm.acknowledgedAt?.toIso8601String(),
      'resolved': alarm.resolved,
      'resolved_at': alarm.resolvedAt?.toIso8601String(),
    }).eq('alarm_id', alarm.id);
  }

  Future<List<Alarm>> fetchAlarmsForSession(String sessionId) async {
    final response = await _client
        .from('alarm')
        .select()
        .eq('session_id', sessionId)
        .order('timestamp', ascending: false);
    
    final list = response as List;
    return list
        .where((json) => json['alarm_id'] != null)
        .map((json) => Alarm.fromJson(json))
        .toList();
  }

  Stream<List<Alarm>> streamAlarmsForSession(String sessionId) {
    return _client
        .from('alarm')
        .stream(primaryKey: ['alarm_id'])
        .eq('session_id', sessionId)
        .order('timestamp', ascending: false)
        .map((data) => data.map((json) => Alarm.fromJson(json)).toList());
  }
}
