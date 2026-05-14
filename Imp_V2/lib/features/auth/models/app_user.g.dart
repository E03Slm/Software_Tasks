// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  id: json['id'] as String,
  nationalId: json['nationalId'] as String,
  role: $enumDecode(_$RoleTypeEnumMap, json['role']),
  isActive: json['isActive'] as bool,
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'id': instance.id,
  'nationalId': instance.nationalId,
  'role': _$RoleTypeEnumMap[instance.role]!,
  'isActive': instance.isActive,
};

const _$RoleTypeEnumMap = {
  RoleType.doctor: 'doctor',
  RoleType.nurse: 'nurse',
  RoleType.admin: 'admin',
};
