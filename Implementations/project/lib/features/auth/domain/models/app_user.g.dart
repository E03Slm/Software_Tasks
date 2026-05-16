// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  id: json['user_id'] as String,
  nationalId: json['national_id'] as String?,
  fname: json['Fname'] as String?,
  mname: json['Mname'] as String?,
  lname: json['Lname'] as String?,
  role: _roleFromJson(json['role']),
  createdAt: DateTime.parse(json['created_at'] as String),
  lastLogin: json['last_login'] == null
      ? null
      : DateTime.parse(json['last_login'] as String),
  isDeleted: json['Is_Deleted'] as bool? ?? false,
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'user_id': instance.id,
  'national_id': instance.nationalId,
  'Fname': instance.fname,
  'Mname': instance.mname,
  'Lname': instance.lname,
  'role': _roleToJson(instance.role),
  'created_at': instance.createdAt.toIso8601String(),
  'last_login': instance.lastLogin?.toIso8601String(),
  'Is_Deleted': instance.isDeleted,
};
