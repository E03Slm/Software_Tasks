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
    @JsonKey(name: 'timestamp') required DateTime timestamp,
    @JsonKey(name: 'user') Map<String, dynamic>? userData,
  }) = _AuditLog;

  String? get userName {
    final id = userData?['user_id'] as String?;
    if (id == null) return null;
    return 'ID: ${id.length > 8 ? id.substring(0, 8) : id}...';
  }

  String get fullName {
    if (userData == null) return userId.substring(0, 8);
    final fname = userData!['Fname'] as String? ?? '';
    final mname = userData!['Mname'] as String? ?? '';
    final lname = userData!['Lname'] as String? ?? '';
    final name = '$fname $mname $lname'.trim().replaceAll(RegExp(r'\s+'), ' ');
    return name.isNotEmpty ? name : userId.substring(0, 8);
  }

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
