import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../nurse/domain/models/infusion_session.dart';
import '../../../nurse/domain/models/alarm.dart';
import '../../domain/models/audit_log.dart';

class ReportRepository {
  final _client = Supabase.instance.client;

  Future<List<InfusionSession>> fetchSessionsInRange(DateTime start, DateTime end) async {
    final response = await _client
        .from('infusion_session')
        .select('*, drug:drug(*), clinician:users(username)') // Join with drug and users
        .gte('start_time', start.toIso8601String())
        .lte('start_time', end.toIso8601String())
        .order('start_time', ascending: false);
    
    return (response as List).map((json) => InfusionSession.fromJson(json)).toList();
  }

  Future<List<Alarm>> fetchAlarmsInRange(DateTime start, DateTime end) async {
    final response = await _client
        .from('alarm')
        .select('*, definition:alarms!fk_alarm_type_lookup(*)') // Explicitly use the lookup FK
        .gte('timestamp', start.toIso8601String())
        .lte('timestamp', end.toIso8601String());
    
    return (response as List).map((json) {
      final definition = json['definition'];
      return Alarm.fromJson({
        ...json,
        'type': definition?['alarm_name'] ?? 'UNKNOWN',
        'severity': definition?['severity'] ?? 'LOW',
        'description': definition?['description'] ?? json['description'] ?? 'No description available',
      });
    }).toList();
  }

  Future<List<AuditLog>> fetchTechnicalLogs(DateTime start, DateTime end) async {
    final response = await _client
        .from('audit_log')
        .select()
        .gte('timestamp', start.toIso8601String())
        .lte('timestamp', end.toIso8601String())
        .or('action.eq.RATE_CHANGED,action.ilike.%WiFi%'); // Titrations and Connectivity
    
    return (response as List).map((json) => AuditLog.fromJson(json)).toList();
  }
}
