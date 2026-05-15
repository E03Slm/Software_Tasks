// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'managed_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ManagedUser _$ManagedUserFromJson(Map<String, dynamic> json) => _ManagedUser(
  id: json['id'] as String,
  role: _roleFromJson(json['role'] as String),
  isDeleted: json['Is_Deleted'] as bool? ?? false,
  isActive: json['isActive'] as bool? ?? true,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ManagedUserToJson(_ManagedUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': _roleToJson(instance.role),
      'Is_Deleted': instance.isDeleted,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
