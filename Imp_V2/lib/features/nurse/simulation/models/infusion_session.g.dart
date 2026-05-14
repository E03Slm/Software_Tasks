// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'infusion_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InfusionSession _$InfusionSessionFromJson(Map<String, dynamic> json) =>
    _InfusionSession(
      id: json['id'] as String,
      nurseId: json['nurseId'] as String,
      drug: Drug.fromJson(json['drug'] as Map<String, dynamic>),
      concentration: (json['concentration'] as num).toDouble(),
      patientId: json['patientId'] as String?,
      infusionRate: (json['infusionRate'] as num).toDouble(),
      totalVolume: (json['totalVolume'] as num).toDouble(),
      volumeInfused: (json['volumeInfused'] as num).toDouble(),
      volumeRemaining: (json['volumeRemaining'] as num).toDouble(),
      currentState: $enumDecode(_$InfusionStateEnumMap, json['currentState']),
      batteryLevel: (json['batteryLevel'] as num).toDouble(),
      kvoEnabled: json['kvoEnabled'] as bool?,
      kvoRate: (json['kvoRate'] as num?)?.toDouble(),
      bolusDose: (json['bolusDose'] as num?)?.toDouble(),
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
    );

Map<String, dynamic> _$InfusionSessionToJson(_InfusionSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nurseId': instance.nurseId,
      'drug': instance.drug,
      'concentration': instance.concentration,
      'patientId': instance.patientId,
      'infusionRate': instance.infusionRate,
      'totalVolume': instance.totalVolume,
      'volumeInfused': instance.volumeInfused,
      'volumeRemaining': instance.volumeRemaining,
      'currentState': _$InfusionStateEnumMap[instance.currentState]!,
      'batteryLevel': instance.batteryLevel,
      'kvoEnabled': instance.kvoEnabled,
      'kvoRate': instance.kvoRate,
      'bolusDose': instance.bolusDose,
      'startedAt': instance.startedAt?.toIso8601String(),
    };

const _$InfusionStateEnumMap = {
  InfusionState.idle: 'idle',
  InfusionState.programming: 'programming',
  InfusionState.running: 'running',
  InfusionState.paused: 'paused',
  InfusionState.alarm: 'alarm',
  InfusionState.kvo: 'kvo',
  InfusionState.complete: 'complete',
  InfusionState.emergencyStop: 'emergencyStop',
  InfusionState.batteryLow: 'batteryLow',
  InfusionState.criticalBattery: 'criticalBattery',
};
