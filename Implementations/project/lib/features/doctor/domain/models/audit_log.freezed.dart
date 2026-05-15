// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audit_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuditLog {

@JsonKey(name: 'log_id') String get id;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'action') String get action;@JsonKey(name: 'entity_type') String get entityType;@JsonKey(name: 'entity_id') String? get entityId;@JsonKey(name: 'old_value') String? get oldValue;@JsonKey(name: 'new_value') String? get newValue;@JsonKey(name: 'timestamp') DateTime get timestamp;@JsonKey(name: 'user') Map<String, dynamic>? get userData;
/// Create a copy of AuditLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuditLogCopyWith<AuditLog> get copyWith => _$AuditLogCopyWithImpl<AuditLog>(this as AuditLog, _$identity);

  /// Serializes this AuditLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuditLog&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.action, action) || other.action == action)&&(identical(other.entityType, entityType) || other.entityType == entityType)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.oldValue, oldValue) || other.oldValue == oldValue)&&(identical(other.newValue, newValue) || other.newValue == newValue)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&const DeepCollectionEquality().equals(other.userData, userData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,action,entityType,entityId,oldValue,newValue,timestamp,const DeepCollectionEquality().hash(userData));

@override
String toString() {
  return 'AuditLog(id: $id, userId: $userId, action: $action, entityType: $entityType, entityId: $entityId, oldValue: $oldValue, newValue: $newValue, timestamp: $timestamp, userData: $userData)';
}


}

/// @nodoc
abstract mixin class $AuditLogCopyWith<$Res>  {
  factory $AuditLogCopyWith(AuditLog value, $Res Function(AuditLog) _then) = _$AuditLogCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'log_id') String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'action') String action,@JsonKey(name: 'entity_type') String entityType,@JsonKey(name: 'entity_id') String? entityId,@JsonKey(name: 'old_value') String? oldValue,@JsonKey(name: 'new_value') String? newValue,@JsonKey(name: 'timestamp') DateTime timestamp,@JsonKey(name: 'user') Map<String, dynamic>? userData
});




}
/// @nodoc
class _$AuditLogCopyWithImpl<$Res>
    implements $AuditLogCopyWith<$Res> {
  _$AuditLogCopyWithImpl(this._self, this._then);

  final AuditLog _self;
  final $Res Function(AuditLog) _then;

/// Create a copy of AuditLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? action = null,Object? entityType = null,Object? entityId = freezed,Object? oldValue = freezed,Object? newValue = freezed,Object? timestamp = null,Object? userData = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,entityType: null == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as String,entityId: freezed == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String?,oldValue: freezed == oldValue ? _self.oldValue : oldValue // ignore: cast_nullable_to_non_nullable
as String?,newValue: freezed == newValue ? _self.newValue : newValue // ignore: cast_nullable_to_non_nullable
as String?,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,userData: freezed == userData ? _self.userData : userData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuditLog].
extension AuditLogPatterns on AuditLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuditLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuditLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuditLog value)  $default,){
final _that = this;
switch (_that) {
case _AuditLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuditLog value)?  $default,){
final _that = this;
switch (_that) {
case _AuditLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'log_id')  String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'action')  String action, @JsonKey(name: 'entity_type')  String entityType, @JsonKey(name: 'entity_id')  String? entityId, @JsonKey(name: 'old_value')  String? oldValue, @JsonKey(name: 'new_value')  String? newValue, @JsonKey(name: 'timestamp')  DateTime timestamp, @JsonKey(name: 'user')  Map<String, dynamic>? userData)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuditLog() when $default != null:
return $default(_that.id,_that.userId,_that.action,_that.entityType,_that.entityId,_that.oldValue,_that.newValue,_that.timestamp,_that.userData);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'log_id')  String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'action')  String action, @JsonKey(name: 'entity_type')  String entityType, @JsonKey(name: 'entity_id')  String? entityId, @JsonKey(name: 'old_value')  String? oldValue, @JsonKey(name: 'new_value')  String? newValue, @JsonKey(name: 'timestamp')  DateTime timestamp, @JsonKey(name: 'user')  Map<String, dynamic>? userData)  $default,) {final _that = this;
switch (_that) {
case _AuditLog():
return $default(_that.id,_that.userId,_that.action,_that.entityType,_that.entityId,_that.oldValue,_that.newValue,_that.timestamp,_that.userData);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'log_id')  String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'action')  String action, @JsonKey(name: 'entity_type')  String entityType, @JsonKey(name: 'entity_id')  String? entityId, @JsonKey(name: 'old_value')  String? oldValue, @JsonKey(name: 'new_value')  String? newValue, @JsonKey(name: 'timestamp')  DateTime timestamp, @JsonKey(name: 'user')  Map<String, dynamic>? userData)?  $default,) {final _that = this;
switch (_that) {
case _AuditLog() when $default != null:
return $default(_that.id,_that.userId,_that.action,_that.entityType,_that.entityId,_that.oldValue,_that.newValue,_that.timestamp,_that.userData);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuditLog extends AuditLog {
  const _AuditLog({@JsonKey(name: 'log_id') required this.id, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'action') required this.action, @JsonKey(name: 'entity_type') required this.entityType, @JsonKey(name: 'entity_id') this.entityId, @JsonKey(name: 'old_value') this.oldValue, @JsonKey(name: 'new_value') this.newValue, @JsonKey(name: 'timestamp') required this.timestamp, @JsonKey(name: 'user') final  Map<String, dynamic>? userData}): _userData = userData,super._();
  factory _AuditLog.fromJson(Map<String, dynamic> json) => _$AuditLogFromJson(json);

@override@JsonKey(name: 'log_id') final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'action') final  String action;
@override@JsonKey(name: 'entity_type') final  String entityType;
@override@JsonKey(name: 'entity_id') final  String? entityId;
@override@JsonKey(name: 'old_value') final  String? oldValue;
@override@JsonKey(name: 'new_value') final  String? newValue;
@override@JsonKey(name: 'timestamp') final  DateTime timestamp;
 final  Map<String, dynamic>? _userData;
@override@JsonKey(name: 'user') Map<String, dynamic>? get userData {
  final value = _userData;
  if (value == null) return null;
  if (_userData is EqualUnmodifiableMapView) return _userData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of AuditLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuditLogCopyWith<_AuditLog> get copyWith => __$AuditLogCopyWithImpl<_AuditLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuditLogToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuditLog&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.action, action) || other.action == action)&&(identical(other.entityType, entityType) || other.entityType == entityType)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.oldValue, oldValue) || other.oldValue == oldValue)&&(identical(other.newValue, newValue) || other.newValue == newValue)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&const DeepCollectionEquality().equals(other._userData, _userData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,action,entityType,entityId,oldValue,newValue,timestamp,const DeepCollectionEquality().hash(_userData));

@override
String toString() {
  return 'AuditLog(id: $id, userId: $userId, action: $action, entityType: $entityType, entityId: $entityId, oldValue: $oldValue, newValue: $newValue, timestamp: $timestamp, userData: $userData)';
}


}

/// @nodoc
abstract mixin class _$AuditLogCopyWith<$Res> implements $AuditLogCopyWith<$Res> {
  factory _$AuditLogCopyWith(_AuditLog value, $Res Function(_AuditLog) _then) = __$AuditLogCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'log_id') String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'action') String action,@JsonKey(name: 'entity_type') String entityType,@JsonKey(name: 'entity_id') String? entityId,@JsonKey(name: 'old_value') String? oldValue,@JsonKey(name: 'new_value') String? newValue,@JsonKey(name: 'timestamp') DateTime timestamp,@JsonKey(name: 'user') Map<String, dynamic>? userData
});




}
/// @nodoc
class __$AuditLogCopyWithImpl<$Res>
    implements _$AuditLogCopyWith<$Res> {
  __$AuditLogCopyWithImpl(this._self, this._then);

  final _AuditLog _self;
  final $Res Function(_AuditLog) _then;

/// Create a copy of AuditLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? action = null,Object? entityType = null,Object? entityId = freezed,Object? oldValue = freezed,Object? newValue = freezed,Object? timestamp = null,Object? userData = freezed,}) {
  return _then(_AuditLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,entityType: null == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as String,entityId: freezed == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String?,oldValue: freezed == oldValue ? _self.oldValue : oldValue // ignore: cast_nullable_to_non_nullable
as String?,newValue: freezed == newValue ? _self.newValue : newValue // ignore: cast_nullable_to_non_nullable
as String?,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,userData: freezed == userData ? _self._userData : userData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
