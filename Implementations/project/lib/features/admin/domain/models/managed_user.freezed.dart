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

 String get id;@JsonKey(name: 'role', fromJson: _roleFromJson, toJson: _roleToJson) RoleType get role;@JsonKey(name: 'Is_Deleted') bool get isDeleted; bool get isActive; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of ManagedUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ManagedUserCopyWith<ManagedUser> get copyWith => _$ManagedUserCopyWithImpl<ManagedUser>(this as ManagedUser, _$identity);

  /// Serializes this ManagedUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ManagedUser&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,role,isDeleted,isActive,createdAt,updatedAt);

@override
String toString() {
  return 'ManagedUser(id: $id, role: $role, isDeleted: $isDeleted, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ManagedUserCopyWith<$Res>  {
  factory $ManagedUserCopyWith(ManagedUser value, $Res Function(ManagedUser) _then) = _$ManagedUserCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'role', fromJson: _roleFromJson, toJson: _roleToJson) RoleType role,@JsonKey(name: 'Is_Deleted') bool isDeleted, bool isActive, DateTime? createdAt, DateTime? updatedAt
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? role = null,Object? isDeleted = null,Object? isActive = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as RoleType,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'role', fromJson: _roleFromJson, toJson: _roleToJson)  RoleType role, @JsonKey(name: 'Is_Deleted')  bool isDeleted,  bool isActive,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ManagedUser() when $default != null:
return $default(_that.id,_that.role,_that.isDeleted,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'role', fromJson: _roleFromJson, toJson: _roleToJson)  RoleType role, @JsonKey(name: 'Is_Deleted')  bool isDeleted,  bool isActive,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ManagedUser():
return $default(_that.id,_that.role,_that.isDeleted,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'role', fromJson: _roleFromJson, toJson: _roleToJson)  RoleType role, @JsonKey(name: 'Is_Deleted')  bool isDeleted,  bool isActive,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ManagedUser() when $default != null:
return $default(_that.id,_that.role,_that.isDeleted,_that.isActive,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ManagedUser extends ManagedUser {
  const _ManagedUser({required this.id, @JsonKey(name: 'role', fromJson: _roleFromJson, toJson: _roleToJson) required this.role, @JsonKey(name: 'Is_Deleted') this.isDeleted = false, this.isActive = true, this.createdAt, this.updatedAt}): super._();
  factory _ManagedUser.fromJson(Map<String, dynamic> json) => _$ManagedUserFromJson(json);

@override final  String id;
@override@JsonKey(name: 'role', fromJson: _roleFromJson, toJson: _roleToJson) final  RoleType role;
@override@JsonKey(name: 'Is_Deleted') final  bool isDeleted;
@override@JsonKey() final  bool isActive;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ManagedUser&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,role,isDeleted,isActive,createdAt,updatedAt);

@override
String toString() {
  return 'ManagedUser(id: $id, role: $role, isDeleted: $isDeleted, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ManagedUserCopyWith<$Res> implements $ManagedUserCopyWith<$Res> {
  factory _$ManagedUserCopyWith(_ManagedUser value, $Res Function(_ManagedUser) _then) = __$ManagedUserCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'role', fromJson: _roleFromJson, toJson: _roleToJson) RoleType role,@JsonKey(name: 'Is_Deleted') bool isDeleted, bool isActive, DateTime? createdAt, DateTime? updatedAt
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? role = null,Object? isDeleted = null,Object? isActive = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_ManagedUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as RoleType,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
