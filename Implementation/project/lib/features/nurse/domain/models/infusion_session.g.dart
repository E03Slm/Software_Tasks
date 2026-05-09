// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'infusion_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InfusionSession _$InfusionSessionFromJson(Map<String, dynamic> json) =>
    _InfusionSession(
      id: json['session_id'] as String,
      userId: json['user_id'] as String?,
      drugId: json['drug_id'] as String?,
      drug: json['drug'] == null
          ? null
          : Drug.fromJson(json['drug'] as Map<String, dynamic>),
      infusionRate: (json['rate'] as num).toDouble(),
      totalVolume: (json['total_volume'] as num).toDouble(),
      volumeInfused: (json['volume_infused'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'Idle',
      startTime: json['start_time'] == null
          ? null
          : DateTime.parse(json['start_time'] as String),
      endTime: json['end_time'] == null
          ? null
          : DateTime.parse(json['end_time'] as String),
      bolusEnabled: json['bolus_enabled'] as bool? ?? false,
      kvoEnabled: json['kvo_enabled'] as bool? ?? false,
      kvoRate: (json['kvo_rate'] as num?)?.toDouble(),
      patientWeight: (json['patient_weight'] as num?)?.toDouble() ?? 70.0,
      targetDose: (json['target_dose'] as num?)?.toDouble(),
      doseUnit: json['dose_unit'] as String? ?? 'mcg/kg/min',
      batteryLevel: (json['battery_level'] as num?)?.toInt() ?? 100,
      clinicianData: json['clinician'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$InfusionSessionToJson(_InfusionSession instance) =>
    <String, dynamic>{
      'session_id': instance.id,
      'user_id': instance.userId,
      'drug_id': instance.drugId,
      'drug': instance.drug,
      'rate': instance.infusionRate,
      'total_volume': instance.totalVolume,
      'volume_infused': instance.volumeInfused,
      'status': instance.status,
      'start_time': instance.startTime?.toIso8601String(),
      'end_time': instance.endTime?.toIso8601String(),
      'bolus_enabled': instance.bolusEnabled,
      'kvo_enabled': instance.kvoEnabled,
      'kvo_rate': instance.kvoRate,
      'patient_weight': instance.patientWeight,
      'target_dose': instance.targetDose,
      'dose_unit': instance.doseUnit,
      'battery_level': instance.batteryLevel,
      'clinician': instance.clinicianData,
    };
