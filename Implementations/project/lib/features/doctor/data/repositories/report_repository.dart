import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../nurse/domain/models/infusion_session.dart';
import '../../../nurse/domain/models/alarm.dart';
import '../../domain/models/audit_log.dart';

class ReportRepository {
  final _client = Supabase.instance.client;

  Future<List<InfusionSession>> fetchSessionsInRange(DateTime start, DateTime end) async {
    final response = await _client
        .from('infusion_session')
        .select('*, drug:drug(*), clinician:users(user_id)') // Join with drug and users
        .gte('start_time', start.toIso8601String())
        .lte('start_time', end.toIso8601String())
        .order('start_time', ascending: false);
    
    final list = response as List;
    return list
        .where((json) => json['session_id'] != null)
        .map((json) => InfusionSession.fromJson(json))
        .toList();
  }

  Future<List<Alarm>> fetchAlarmsInRange(DateTime start, DateTime end) async {
    final response = await _client
        .from('alarm')
        .select()
        .gte('timestamp', start.toIso8601String())
        .lte('timestamp', end.toIso8601String());
    
    final list = response as List;
    return list
        .where((json) => json['alarm_id'] != null)
        .map((json) => Alarm.fromJson(json))
        .toList();
  }

  Future<List<AuditLog>> fetchTechnicalLogs(DateTime start, DateTime end) async {
    final response = await _client
        .from('audit_log')
        .select()
        .gte('timestamp', start.toIso8601String())
        .lte('timestamp', end.toIso8601String())
        .or('action.eq.RATE_CHANGED,action.ilike.%WiFi%'); // Titrations and Connectivity
    
    final list = response as List;
    return list
        .where((json) => json['log_id'] != null)
        .map((json) => AuditLog.fromJson(json))
        .toList();
  }
}
