import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'audit_log.freezed.dart';
part 'audit_log.g.dart';

@freezed
abstract class AuditLog with _$AuditLog {
  const AuditLog._();

  const factory AuditLog({
    @JsonKey(name: 'log_id') required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'action') required String action,
    @JsonKey(name: 'entity_type') required String entityType,
    @JsonKey(name: 'entity_id') String? entityId,
    @JsonKey(name: 'old_value') String? oldValue,
    @JsonKey(name: 'new_value') String? newValue,
    @JsonKey(name: 'ip_address') String? ipAddress,
    @JsonKey(name: 'timestamp') required DateTime timestamp,
    @JsonKey(name: 'user') Map<String, dynamic>? userData,
  }) = _AuditLog;

  String? get userName => userData?['username'] as String?;

  String? get entityName {
    try {
      if (newValue != null) {
        final data = Map<String, dynamic>.from(jsonDecode(newValue!));
        if (data.containsKey('name')) return data['name'] as String?;
      }
      if (oldValue != null) {
        final data = Map<String, dynamic>.from(jsonDecode(oldValue!));
        if (data.containsKey('name')) return data['name'] as String?;
      }
    } catch (_) {}
    return null;
  }

  factory AuditLog.fromJson(Map<String, dynamic> json) => _$AuditLogFromJson(json);
}
