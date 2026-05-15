import 'package:freezed_annotation/freezed_annotation.dart';
import '../enums/role_type.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
abstract class AppUser with _$AppUser {
  const AppUser._();

  const factory AppUser({
    @JsonKey(name: 'user_id') required String id,
    @JsonKey(name: 'role', fromJson: _roleFromJson, toJson: _roleToJson) required RoleType role,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'last_login') DateTime? lastLogin,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);
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
