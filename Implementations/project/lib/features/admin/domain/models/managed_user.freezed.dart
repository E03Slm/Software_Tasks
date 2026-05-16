// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'managed_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ManagedUser {

@JsonKey(name: 'user_id') String get id;@JsonKey(name: 'national_id') String? get nationalId;@JsonKey(name: 'Fname') String? get fname;@JsonKey(name: 'Mname') String? get mname;@JsonKey(name: 'Lname') String? get lname;@JsonKey(name: 'role', fromJson: _roleFromJson, toJson: _roleToJson) RoleType get role;@JsonKey(name: 'Is_Deleted') bool get isDeleted;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'last_login') DateTime? get lastLogin;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of ManagedUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ManagedUserCopyWith<ManagedUser> get copyWith => _$ManagedUserCopyWithImpl<ManagedUser>(this as ManagedUser, _$identity);

  /// Serializes this ManagedUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ManagedUser&&(identical(other.id, id) || other.id == id)&&(identical(other.nationalId, nationalId) || other.nationalId == nationalId)&&(identical(other.fname, fname) || other.fname == fname)&&(identical(other.mname, mname) || other.mname == mname)&&(identical(other.lname, lname) || other.lname == lname)&&(identical(other.role, role) || other.role == role)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastLogin, lastLogin) || other.lastLogin == lastLogin)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nationalId,fname,mname,lname,role,isDeleted,createdAt,lastLogin,updatedAt);

@override
String toString() {
  return 'ManagedUser(id: $id, nationalId: $nationalId, fname: $fname, mname: $mname, lname: $lname, role: $role, isDeleted: $isDeleted, createdAt: $createdAt, lastLogin: $lastLogin, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ManagedUserCopyWith<$Res>  {
  factory $ManagedUserCopyWith(ManagedUser value, $Res Function(ManagedUser) _then) = _$ManagedUserCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'user_id') String id,@JsonKey(name: 'national_id') String? nationalId,@JsonKey(name: 'Fname') String? fname,@JsonKey(name: 'Mname') String? mname,@JsonKey(name: 'Lname') String? lname,@JsonKey(name: 'role', fromJson: _roleFromJson, toJson: _roleToJson) RoleType role,@JsonKey(name: 'Is_Deleted') bool isDeleted,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'last_login') DateTime? lastLogin,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$ManagedUserCopyWithImpl<$Res>
    implements $ManagedUserCopyWith<$Res> {
  _$ManagedUserCopyWithImpl(this._self, this._then);

  final ManagedUser _self;
  final $Res Function(ManagedUser) _then;

/// Create a copy of ManagedUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nationalId = freezed,Object? fname = freezed,Object? mname = freezed,Object? lname = freezed,Object? role = null,Object? isDeleted = null,Object? createdAt = freezed,Object? lastLogin = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nationalId: freezed == nationalId ? _self.nationalId : nationalId // ignore: cast_nullable_to_non_nullable
as String?,fname: freezed == fname ? _self.fname : fname // ignore: cast_nullable_to_non_nullable
as String?,mname: freezed == mname ? _self.mname : mname // ignore: cast_nullable_to_non_nullable
as String?,lname: freezed == lname ? _self.lname : lname // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as RoleType,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastLogin: freezed == lastLogin ? _self.lastLogin : lastLogin // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ManagedUser].
extension ManagedUserPatterns on ManagedUser {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ManagedUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ManagedUser() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ManagedUser value)  $default,){
final _that = this;
switch (_that) {
case _ManagedUser():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ManagedUser value)?  $default,){
final _that = this;
switch (_that) {
case _ManagedUser() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String id, @JsonKey(name: 'national_id')  String? nationalId, @JsonKey(name: 'Fname')  String? fname, @JsonKey(name: 'Mname')  String? mname, @JsonKey(name: 'Lname')  String? lname, @JsonKey(name: 'role', fromJson: _roleFromJson, toJson: _roleToJson)  RoleType role, @JsonKey(name: 'Is_Deleted')  bool isDeleted, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'last_login')  DateTime? lastLogin, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ManagedUser() when $default != null:
return $default(_that.id,_that.nationalId,_that.fname,_that.mname,_that.lname,_that.role,_that.isDeleted,_that.createdAt,_that.lastLogin,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String id, @JsonKey(name: 'national_id')  String? nationalId, @JsonKey(name: 'Fname')  String? fname, @JsonKey(name: 'Mname')  String? mname, @JsonKey(name: 'Lname')  String? lname, @JsonKey(name: 'role', fromJson: _roleFromJson, toJson: _roleToJson)  RoleType role, @JsonKey(name: 'Is_Deleted')  bool isDeleted, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'last_login')  DateTime? lastLogin, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ManagedUser():
return $default(_that.id,_that.nationalId,_that.fname,_that.mname,_that.lname,_that.role,_that.isDeleted,_that.createdAt,_that.lastLogin,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'user_id')  String id, @JsonKey(name: 'national_id')  String? nationalId, @JsonKey(name: 'Fname')  String? fname, @JsonKey(name: 'Mname')  String? mname, @JsonKey(name: 'Lname')  String? lname, @JsonKey(name: 'role', fromJson: _roleFromJson, toJson: _roleToJson)  RoleType role, @JsonKey(name: 'Is_Deleted')  bool isDeleted, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'last_login')  DateTime? lastLogin, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ManagedUser() when $default != null:
return $default(_that.id,_that.nationalId,_that.fname,_that.mname,_that.lname,_that.role,_that.isDeleted,_that.createdAt,_that.lastLogin,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ManagedUser extends ManagedUser {
  const _ManagedUser({@JsonKey(name: 'user_id') required this.id, @JsonKey(name: 'national_id') this.nationalId, @JsonKey(name: 'Fname') this.fname, @JsonKey(name: 'Mname') this.mname, @JsonKey(name: 'Lname') this.lname, @JsonKey(name: 'role', fromJson: _roleFromJson, toJson: _roleToJson) required this.role, @JsonKey(name: 'Is_Deleted') this.isDeleted = false, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'last_login') this.lastLogin, @JsonKey(name: 'updated_at') this.updatedAt}): super._();
  factory _ManagedUser.fromJson(Map<String, dynamic> json) => _$ManagedUserFromJson(json);

@override@JsonKey(name: 'user_id') final  String id;
@override@JsonKey(name: 'national_id') final  String? nationalId;
@override@JsonKey(name: 'Fname') final  String? fname;
@override@JsonKey(name: 'Mname') final  String? mname;
@override@JsonKey(name: 'Lname') final  String? lname;
@override@JsonKey(name: 'role', fromJson: _roleFromJson, toJson: _roleToJson) final  RoleType role;
@override@JsonKey(name: 'Is_Deleted') final  bool isDeleted;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'last_login') final  DateTime? lastLogin;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of ManagedUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ManagedUserCopyWith<_ManagedUser> get copyWith => __$ManagedUserCopyWithImpl<_ManagedUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ManagedUserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ManagedUser&&(identical(other.id, id) || other.id == id)&&(identical(other.nationalId, nationalId) || other.nationalId == nationalId)&&(identical(other.fname, fname) || other.fname == fname)&&(identical(other.mname, mname) || other.mname == mname)&&(identical(other.lname, lname) || other.lname == lname)&&(identical(other.role, role) || other.role == role)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastLogin, lastLogin) || other.lastLogin == lastLogin)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nationalId,fname,mname,lname,role,isDeleted,createdAt,lastLogin,updatedAt);

@override
String toString() {
  return 'ManagedUser(id: $id, nationalId: $nationalId, fname: $fname, mname: $mname, lname: $lname, role: $role, isDeleted: $isDeleted, createdAt: $createdAt, lastLogin: $lastLogin, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ManagedUserCopyWith<$Res> implements $ManagedUserCopyWith<$Res> {
  factory _$ManagedUserCopyWith(_ManagedUser value, $Res Function(_ManagedUser) _then) = __$ManagedUserCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'user_id') String id,@JsonKey(name: 'national_id') String? nationalId,@JsonKey(name: 'Fname') String? fname,@JsonKey(name: 'Mname') String? mname,@JsonKey(name: 'Lname') String? lname,@JsonKey(name: 'role', fromJson: _roleFromJson, toJson: _roleToJson) RoleType role,@JsonKey(name: 'Is_Deleted') bool isDeleted,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'last_login') DateTime? lastLogin,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$ManagedUserCopyWithImpl<$Res>
    implements _$ManagedUserCopyWith<$Res> {
  __$ManagedUserCopyWithImpl(this._self, this._then);

  final _ManagedUser _self;
  final $Res Function(_ManagedUser) _then;

/// Create a copy of ManagedUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nationalId = freezed,Object? fname = freezed,Object? mname = freezed,Object? lname = freezed,Object? role = null,Object? isDeleted = null,Object? createdAt = freezed,Object? lastLogin = freezed,Object? updatedAt = freezed,}) {
  return _then(_ManagedUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nationalId: freezed == nationalId ? _self.nationalId : nationalId // ignore: cast_nullable_to_non_nullable
as String?,fname: freezed == fname ? _self.fname : fname // ignore: cast_nullable_to_non_nullable
as String?,mname: freezed == mname ? _self.mname : mname // ignore: cast_nullable_to_non_nullable
as String?,lname: freezed == lname ? _self.lname : lname // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as RoleType,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastLogin: freezed == lastLogin ? _self.lastLogin : lastLogin // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
