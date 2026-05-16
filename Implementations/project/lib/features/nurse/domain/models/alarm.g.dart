// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Alarm _$AlarmFromJson(Map<String, dynamic> json) => _Alarm(
  id: json['event_id'] as String,
  sessionId: json['session_id'] as String,
  alarmId: json['alarm_id'] as String,
  alarmTime: DateTime.parse(json['timestamp'] as String),
  type: json['type'] as String?,
  ackRes: json['ack/res'] as bool? ?? false,
  ackResBy: json['ack/res_by'] as String?,
  ackResAt: json['ack/res_at'] == null
      ? null
      : DateTime.parse(json['ack/res_at'] as String),
  definition: json['definition'] == null
      ? null
      : AlarmDefinition.fromJson(json['definition'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AlarmToJson(_Alarm instance) => <String, dynamic>{
  'event_id': instance.id,
  'session_id': instance.sessionId,
  'alarm_id': instance.alarmId,
  'timestamp': instance.alarmTime.toIso8601String(),
  'type': instance.type,
  'ack/res': instance.ackRes,
  'ack/res_by': instance.ackResBy,
  'ack/res_at': instance.ackResAt?.toIso8601String(),
  'definition': instance.definition,
};
