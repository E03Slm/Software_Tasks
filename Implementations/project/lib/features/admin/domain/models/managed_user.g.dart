// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'managed_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ManagedUser _$ManagedUserFromJson(Map<String, dynamic> json) => _ManagedUser(
  id: json['id'] as String,
  username: json['username'] as String,
  role: _roleFromJson(json['role'] as String),
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
      'username': instance.username,
      'role': _roleToJson(instance.role),
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
