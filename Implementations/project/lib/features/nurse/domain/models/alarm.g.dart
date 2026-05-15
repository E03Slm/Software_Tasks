// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Alarm _$AlarmFromJson(Map<String, dynamic> json) => _Alarm(
  id: json['alarm_id'] as String,
  sessionId: json['session_id'] as String,
  definitionId: json['definitionId'] as String?,
  type: json['type'] as String,
  severity: json['severity'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
  acknowledged: json['acknowledged'] as bool? ?? false,
  acknowledgedBy: json['acknowledged_by'] as String?,
  acknowledgedAt: json['acknowledged_at'] == null
      ? null
      : DateTime.parse(json['acknowledged_at'] as String),
  resolved: json['resolved'] as bool? ?? false,
  resolvedAt: json['resolved_at'] == null
      ? null
      : DateTime.parse(json['resolved_at'] as String),
  description: json['description'] as String?,
);

Map<String, dynamic> _$AlarmToJson(_Alarm instance) => <String, dynamic>{
  'alarm_id': instance.id,
  'session_id': instance.sessionId,
  'definitionId': instance.definitionId,
  'type': instance.type,
  'severity': instance.severity,
  'timestamp': instance.timestamp.toIso8601String(),
  'acknowledged': instance.acknowledged,
  'acknowledged_by': instance.acknowledgedBy,
  'acknowledged_at': instance.acknowledgedAt?.toIso8601String(),
  'resolved': instance.resolved,
  'resolved_at': instance.resolvedAt?.toIso8601String(),
  'description': instance.description,
};
