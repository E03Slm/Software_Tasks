// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'managed_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ManagedUser _$ManagedUserFromJson(Map<String, dynamic> json) => _ManagedUser(
  id: json['user_id'] as String,
  nationalId: json['national_id'] as String?,
  fname: json['Fname'] as String?,
  mname: json['Mname'] as String?,
  lname: json['Lname'] as String?,
  role: _roleFromJson(json['role']),
  isDeleted: json['Is_Deleted'] as bool? ?? false,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  lastLogin: json['last_login'] == null
      ? null
      : DateTime.parse(json['last_login'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$ManagedUserToJson(_ManagedUser instance) =>
    <String, dynamic>{
      'user_id': instance.id,
      'national_id': instance.nationalId,
      'Fname': instance.fname,
      'Mname': instance.mname,
      'Lname': instance.lname,
      'role': _roleToJson(instance.role),
      'Is_Deleted': instance.isDeleted,
      'created_at': instance.createdAt?.toIso8601String(),
      'last_login': instance.lastLogin?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
