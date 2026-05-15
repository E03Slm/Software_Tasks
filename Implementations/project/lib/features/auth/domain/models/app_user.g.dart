// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  id: json['user_id'] as String,
  role: _roleFromJson(json['role'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
  lastLogin: json['last_login'] == null
      ? null
      : DateTime.parse(json['last_login'] as String),
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'user_id': instance.id,
  'role': _roleToJson(instance.role),
  'created_at': instance.createdAt.toIso8601String(),
  'last_login': instance.lastLogin?.toIso8601String(),
};
