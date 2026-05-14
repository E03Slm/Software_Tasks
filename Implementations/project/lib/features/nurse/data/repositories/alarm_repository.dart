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
        'event_id': alarm.id,
        'session_id': alarm.sessionId,
        'alarm_id': alarm.definitionId,
        'timestamp': alarm.timestamp.toIso8601String(),
        'acknowledged': alarm.acknowledged,
        'resolved': alarm.resolved,
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
    }).eq('event_id', alarm.id);
  }

  Future<List<Alarm>> fetchAlarmsForSession(String sessionId) async {
    final response = await _client
        .from('alarm')
        .select('*, definition:alarms!fk_alarm_type_lookup(*)')
        .eq('session_id', sessionId)
        .order('timestamp', ascending: false);
    
    final list = response as List;
    return list
        .where((json) => json['event_id'] != null)
        .map((json) {
      final definition = json['definition'];
      return Alarm.fromJson({
        ...json,
        'type': definition?['alarm_name'] ?? 'UNKNOWN',
        'severity': definition?['severity'] ?? 'LOW',
        'description': definition?['description'] ?? 'No description available',
      });
    }).toList();
  }
}
