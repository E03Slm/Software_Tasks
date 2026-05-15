import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../../domain/models/audit_log.dart';

class AuditRepository {
  final _client = Supabase.instance.client;
  String? _cachedIp;

  Future<List<AuditLog>> fetchLogs({bool excludeLoginLogs = false}) async {
    var query = _client
        .from('audit_log')
        .select('*, user:users!audit_log_user_id_fkey(*)');
    
    if (excludeLoginLogs) {
      query = query.not('action', 'in', '("LOGIN", "LOGOUT")');
    }

    final response = await query.order('timestamp', ascending: false);
    
    final list = response as List;
    return list
        .where((json) => json['log_id'] != null && json['action'] != null)
        .map((json) => AuditLog.fromJson(json))
        .toList();
  }

  Future<List<AuditLog>> fetchLogsForEntity(String entityId) async {
    final response = await _client
        .from('audit_log')
        .select('*, user:users!audit_log_user_id_fkey(*)')
        .eq('entity_id', entityId)
        .order('timestamp', ascending: false);
    
    final list = response as List;
    return list
        .where((json) => json['log_id'] != null && json['action'] != null)
        .map((json) => AuditLog.fromJson(json))
        .toList();
  }

  Stream<List<AuditLog>> streamLogs({bool excludeLoginLogs = false}) {
    return _client
        .from('audit_log')
        .stream(primaryKey: ['log_id'])
        .order('timestamp', ascending: false)
        .map((data) => data.map((json) => AuditLog.fromJson(json)).toList());
  }

  Stream<List<AuditLog>> streamLogsForSession(String sessionId) {
    return _client
        .from('audit_log')
        .stream(primaryKey: ['log_id'])
        .eq('session_id', sessionId)
        .order('timestamp', ascending: false)
        .map((data) => data.map((json) => AuditLog.fromJson(json)).toList());
  }

  Future<void> logAction({
    required String actionType,
    required String entityType,
    String? entityId,
    String? sessionId,
    Map<String, dynamic>? oldValue,
    Map<String, dynamic>? newValue,
    String? performerId,
  }) async {
    final finalUserId = performerId ?? _client.auth.currentUser?.id;
    final now = DateTime.now().toIso8601String();
    final logId = const Uuid().v4();

    await _client.from('audit_log').insert({
      'log_id': logId,
      'user_id': finalUserId,
      'session_id': sessionId,
      'action': actionType,
      'entity_type': entityType,
      'entity_id': entityId ?? logId, // Fallback to logId if entityId is null
      'old_value': oldValue != null ? jsonEncode(oldValue) : '{}',
      'new_value': newValue != null ? jsonEncode(newValue) : '{}',
      'timestamp': now,
    });
  }
}
