// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm_definition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AlarmDefinition _$AlarmDefinitionFromJson(Map<String, dynamic> json) =>
    _AlarmDefinition(
      id: json['alarm_id'] as String,
      name: json['alarm_name'] as String? ?? 'Unknown',
      severity: json['severity'] as String? ?? 'LOW',
      description: json['description'] as String? ?? 'No description available',
    );

Map<String, dynamic> _$AlarmDefinitionToJson(_AlarmDefinition instance) =>
    <String, dynamic>{
      'alarm_id': instance.id,
      'alarm_name': instance.name,
      'severity': instance.severity,
      'description': instance.description,
    };
