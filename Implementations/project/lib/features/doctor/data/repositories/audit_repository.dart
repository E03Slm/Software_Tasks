import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../../domain/models/audit_log.dart';

class AuditRepository {
  final _client = Supabase.instance.client;
  String? _cachedIp;

  Future<List<AuditLog>> fetchLogs() async {
    final response = await _client
        .from('audit_log')
        .select('*, user:users(username)')
        .order('timestamp', ascending: false);
    
    final list = response as List;
    return list
        .where((json) => json['log_id'] != null && json['action'] != null)
        .map((json) => AuditLog.fromJson(json))
        .toList();
  }

  Future<List<AuditLog>> fetchLogsForEntity(String entityId) async {
    final response = await _client
        .from('audit_log')
        .select('*, user:users(username)')
        .eq('entity_id', entityId)
        .order('timestamp', ascending: false);
    
    final list = response as List;
    return list
        .where((json) => json['log_id'] != null && json['action'] != null)
        .map((json) => AuditLog.fromJson(json))
        .toList();
  }

  String _getIpAddress() {
    // Return a default value to prevent slow network requests from blocking the UI
    return '0.0.0.0';
  }

  Future<void> logAction({
    required String actionType,
    required String entityType,
    String? entityId,
    Map<String, dynamic>? oldValue,
    Map<String, dynamic>? newValue,
    String? sessionId,
    String? performerId,
  }) async {
    final finalUserId = performerId ?? _client.auth.currentUser?.id;
    
    final ipAddress = _getIpAddress();
    final now = DateTime.now().toIso8601String();
    final logId = const Uuid().v4();

    await _client.from('audit_log').insert({
      'log_id': logId,
      'user_id': finalUserId,
      'action': actionType,
      'entity_type': entityType,
      'entity_id': entityId ?? logId, // Fallback to logId if entityId is null
      'old_value': oldValue != null ? jsonEncode(oldValue) : '{}',
      'new_value': newValue != null ? jsonEncode(newValue) : '{}',
      'timestamp': now,
      'ip_address': ipAddress,
    });
  }
}
