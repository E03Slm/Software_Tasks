// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm_definition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AlarmDefinition _$AlarmDefinitionFromJson(Map<String, dynamic> json) =>
    _AlarmDefinition(
      id: json['alarm_id'] as String,
      type: json['alarm_name'] as String,
      severity: json['severity'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$AlarmDefinitionToJson(_AlarmDefinition instance) =>
    <String, dynamic>{
      'alarm_id': instance.id,
      'alarm_name': instance.type,
      'severity': instance.severity,
      'description': instance.description,
    };
