import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../auth/domain/enums/role_type.dart';

part 'managed_user.freezed.dart';
part 'managed_user.g.dart';

@freezed
abstract class ManagedUser with _$ManagedUser {
  const ManagedUser._();

  const factory ManagedUser({
    required String id,
    @JsonKey(name: 'role', fromJson: _roleFromJson, toJson: _roleToJson) required RoleType role,
    @JsonKey(name: 'Is_Deleted') @Default(false) bool isDeleted,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ManagedUser;

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
