// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drug.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Drug _$DrugFromJson(Map<String, dynamic> json) => _Drug(
  id: json['drug_id'] as String,
  name: json['name'] as String,
  concentration: (json['concentration'] as num).toDouble(),
  concentrationUnit: json['concentration_unit'] as String,
  defaultRate: (json['default_rate'] as num).toDouble(),
  rateUnit: json['rate_unit'] as String,
  hardLimitCeiling: (json['hard_limit_high'] as num).toDouble(),
  softLimitThreshold: (json['soft_limit_high'] as num).toDouble(),
  createdBy: json['created_by'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedBy: json['updated_by'] as String?,
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  isArchived: json['Is_Deleted'] as bool,
);

Map<String, dynamic> _$DrugToJson(_Drug instance) => <String, dynamic>{
  'drug_id': instance.id,
  'name': instance.name,
  'concentration': instance.concentration,
  'concentration_unit': instance.concentrationUnit,
  'default_rate': instance.defaultRate,
  'rate_unit': instance.rateUnit,
  'hard_limit_high': instance.hardLimitCeiling,
  'soft_limit_high': instance.softLimitThreshold,
  'created_by': instance.createdBy,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_by': instance.updatedBy,
  'updated_at': instance.updatedAt?.toIso8601String(),
  'Is_Deleted': instance.isArchived,
};
