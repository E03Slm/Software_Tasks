import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../auth/domain/enums/role_type.dart';

part 'managed_user.freezed.dart';
part 'managed_user.g.dart';

@freezed
abstract class ManagedUser with _$ManagedUser {
  const ManagedUser._();

  const factory ManagedUser({
    @JsonKey(name: 'user_id') required String id,
    @JsonKey(name: 'national_id') String? nationalId,
    @JsonKey(name: 'Fname') String? fname,
    @JsonKey(name: 'Mname') String? mname,
    @JsonKey(name: 'Lname') String? lname,
    @JsonKey(name: 'role', fromJson: _roleFromJson, toJson: _roleToJson) required RoleType role,
    @JsonKey(name: 'Is_Deleted') @Default(false) bool isDeleted,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'last_login') DateTime? lastLogin,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _ManagedUser;

  String get fullName {
    final name = '${fname ?? ''} ${mname ?? ''} ${lname ?? ''}'.trim().replaceAll(RegExp(r'\s+'), ' ');
    return name.isNotEmpty ? name : id.substring(0, 8);
  }

  factory ManagedUser.fromJson(Map<String, dynamic> json) => _$ManagedUserFromJson(json);
}

RoleType _roleFromJson(String role) {
  switch (role.toUpperCase()) {
    case 'DOCTOR': return RoleType.doctor;
    case 'ADMIN': return RoleType.admin;
    case 'PATIENT': return RoleType.patient;
    default: return RoleType.nurse;
  }
}

String _roleToJson(RoleType role) => role.name.toUpperCase();
