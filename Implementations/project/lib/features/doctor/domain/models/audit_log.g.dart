// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuditLog _$AuditLogFromJson(Map<String, dynamic> json) => _AuditLog(
  id: json['log_id'] as String,
  userId: json['user_id'] as String,
  action: json['action'] as String,
  entityType: json['entity_type'] as String,
  entityId: json['entity_id'] as String?,
  oldValue: json['old_value'] as String?,
  newValue: json['new_value'] as String?,
  ipAddress: json['ip_address'] as String?,
  timestamp: DateTime.parse(json['timestamp'] as String),
  userData: json['user'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$AuditLogToJson(_AuditLog instance) => <String, dynamic>{
  'log_id': instance.id,
  'user_id': instance.userId,
  'action': instance.action,
  'entity_type': instance.entityType,
  'entity_id': instance.entityId,
  'old_value': instance.oldValue,
  'new_value': instance.newValue,
  'ip_address': instance.ipAddress,
  'timestamp': instance.timestamp.toIso8601String(),
  'user': instance.userData,
};
