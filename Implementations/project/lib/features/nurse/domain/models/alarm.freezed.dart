// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alarm.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Alarm {

@JsonKey(name: 'alarm_id') String get id;@JsonKey(name: 'session_id') String get sessionId;@JsonKey(name: 'event_id') String? get definitionId; String get type; String get severity; DateTime get timestamp; bool get acknowledged;@JsonKey(name: 'acknowledged_by') String? get acknowledgedBy;@JsonKey(name: 'acknowledged_at') DateTime? get acknowledgedAt; bool get resolved;@JsonKey(name: 'resolved_at') DateTime? get resolvedAt; String? get description;
/// Create a copy of Alarm
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlarmCopyWith<Alarm> get copyWith => _$AlarmCopyWithImpl<Alarm>(this as Alarm, _$identity);

  /// Serializes this Alarm to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Alarm&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.definitionId, definitionId) || other.definitionId == definitionId)&&(identical(other.type, type) || other.type == type)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.acknowledged, acknowledged) || other.acknowledged == acknowledged)&&(identical(other.acknowledgedBy, acknowledgedBy) || other.acknowledgedBy == acknowledgedBy)&&(identical(other.acknowledgedAt, acknowledgedAt) || other.acknowledgedAt == acknowledgedAt)&&(identical(other.resolved, resolved) || other.resolved == resolved)&&(identical(other.resolvedAt, resolvedAt) || other.resolvedAt == resolvedAt)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sessionId,definitionId,type,severity,timestamp,acknowledged,acknowledgedBy,acknowledgedAt,resolved,resolvedAt,description);

@override
String toString() {
  return 'Alarm(id: $id, sessionId: $sessionId, definitionId: $definitionId, type: $type, severity: $severity, timestamp: $timestamp, acknowledged: $acknowledged, acknowledgedBy: $acknowledgedBy, acknowledgedAt: $acknowledgedAt, resolved: $resolved, resolvedAt: $resolvedAt, description: $description)';
}


}

/// @nodoc
abstract mixin class $AlarmCopyWith<$Res>  {
  factory $AlarmCopyWith(Alarm value, $Res Function(Alarm) _then) = _$AlarmCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'alarm_id') String id,@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'event_id') String? definitionId, String type, String severity, DateTime timestamp, bool acknowledged,@JsonKey(name: 'acknowledged_by') String? acknowledgedBy,@JsonKey(name: 'acknowledged_at') DateTime? acknowledgedAt, bool resolved,@JsonKey(name: 'resolved_at') DateTime? resolvedAt, String? description
});




}
/// @nodoc
class _$AlarmCopyWithImpl<$Res>
    implements $AlarmCopyWith<$Res> {
  _$AlarmCopyWithImpl(this._self, this._then);

  final Alarm _self;
  final $Res Function(Alarm) _then;

/// Create a copy of Alarm
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sessionId = null,Object? definitionId = freezed,Object? type = null,Object? severity = null,Object? timestamp = null,Object? acknowledged = null,Object? acknowledgedBy = freezed,Object? acknowledgedAt = freezed,Object? resolved = null,Object? resolvedAt = freezed,Object? description = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,definitionId: freezed == definitionId ? _self.definitionId : definitionId // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,acknowledged: null == acknowledged ? _self.acknowledged : acknowledged // ignore: cast_nullable_to_non_nullable
as bool,acknowledgedBy: freezed == acknowledgedBy ? _self.acknowledgedBy : acknowledgedBy // ignore: cast_nullable_to_non_nullable
as String?,acknowledgedAt: freezed == acknowledgedAt ? _self.acknowledgedAt : acknowledgedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,resolved: null == resolved ? _self.resolved : resolved // ignore: cast_nullable_to_non_nullable
as bool,resolvedAt: freezed == resolvedAt ? _self.resolvedAt : resolvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Alarm].
extension AlarmPatterns on Alarm {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Alarm value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Alarm() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Alarm value)  $default,){
final _that = this;
switch (_that) {
case _Alarm():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Alarm value)?  $default,){
final _that = this;
switch (_that) {
case _Alarm() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'alarm_id')  String id, @JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'event_id')  String? definitionId,  String type,  String severity,  DateTime timestamp,  bool acknowledged, @JsonKey(name: 'acknowledged_by')  String? acknowledgedBy, @JsonKey(name: 'acknowledged_at')  DateTime? acknowledgedAt,  bool resolved, @JsonKey(name: 'resolved_at')  DateTime? resolvedAt,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Alarm() when $default != null:
return $default(_that.id,_that.sessionId,_that.definitionId,_that.type,_that.severity,_that.timestamp,_that.acknowledged,_that.acknowledgedBy,_that.acknowledgedAt,_that.resolved,_that.resolvedAt,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'alarm_id')  String id, @JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'event_id')  String? definitionId,  String type,  String severity,  DateTime timestamp,  bool acknowledged, @JsonKey(name: 'acknowledged_by')  String? acknowledgedBy, @JsonKey(name: 'acknowledged_at')  DateTime? acknowledgedAt,  bool resolved, @JsonKey(name: 'resolved_at')  DateTime? resolvedAt,  String? description)  $default,) {final _that = this;
switch (_that) {
case _Alarm():
return $default(_that.id,_that.sessionId,_that.definitionId,_that.type,_that.severity,_that.timestamp,_that.acknowledged,_that.acknowledgedBy,_that.acknowledgedAt,_that.resolved,_that.resolvedAt,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'alarm_id')  String id, @JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'event_id')  String? definitionId,  String type,  String severity,  DateTime timestamp,  bool acknowledged, @JsonKey(name: 'acknowledged_by')  String? acknowledgedBy, @JsonKey(name: 'acknowledged_at')  DateTime? acknowledgedAt,  bool resolved, @JsonKey(name: 'resolved_at')  DateTime? resolvedAt,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _Alarm() when $default != null:
return $default(_that.id,_that.sessionId,_that.definitionId,_that.type,_that.severity,_that.timestamp,_that.acknowledged,_that.acknowledgedBy,_that.acknowledgedAt,_that.resolved,_that.resolvedAt,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Alarm extends Alarm {
  const _Alarm({@JsonKey(name: 'alarm_id') required this.id, @JsonKey(name: 'session_id') required this.sessionId, @JsonKey(name: 'event_id') this.definitionId, required this.type, required this.severity, required this.timestamp, this.acknowledged = false, @JsonKey(name: 'acknowledged_by') this.acknowledgedBy, @JsonKey(name: 'acknowledged_at') this.acknowledgedAt, this.resolved = false, @JsonKey(name: 'resolved_at') this.resolvedAt, this.description}): super._();
  factory _Alarm.fromJson(Map<String, dynamic> json) => _$AlarmFromJson(json);

@override@JsonKey(name: 'alarm_id') final  String id;
@override@JsonKey(name: 'session_id') final  String sessionId;
@override@JsonKey(name: 'event_id') final  String? definitionId;
@override final  String type;
@override final  String severity;
@override final  DateTime timestamp;
@override@JsonKey() final  bool acknowledged;
@override@JsonKey(name: 'acknowledged_by') final  String? acknowledgedBy;
@override@JsonKey(name: 'acknowledged_at') final  DateTime? acknowledgedAt;
@override@JsonKey() final  bool resolved;
@override@JsonKey(name: 'resolved_at') final  DateTime? resolvedAt;
@override final  String? description;

/// Create a copy of Alarm
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlarmCopyWith<_Alarm> get copyWith => __$AlarmCopyWithImpl<_Alarm>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlarmToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Alarm&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.definitionId, definitionId) || other.definitionId == definitionId)&&(identical(other.type, type) || other.type == type)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.acknowledged, acknowledged) || other.acknowledged == acknowledged)&&(identical(other.acknowledgedBy, acknowledgedBy) || other.acknowledgedBy == acknowledgedBy)&&(identical(other.acknowledgedAt, acknowledgedAt) || other.acknowledgedAt == acknowledgedAt)&&(identical(other.resolved, resolved) || other.resolved == resolved)&&(identical(other.resolvedAt, resolvedAt) || other.resolvedAt == resolvedAt)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sessionId,definitionId,type,severity,timestamp,acknowledged,acknowledgedBy,acknowledgedAt,resolved,resolvedAt,description);

@override
String toString() {
  return 'Alarm(id: $id, sessionId: $sessionId, definitionId: $definitionId, type: $type, severity: $severity, timestamp: $timestamp, acknowledged: $acknowledged, acknowledgedBy: $acknowledgedBy, acknowledgedAt: $acknowledgedAt, resolved: $resolved, resolvedAt: $resolvedAt, description: $description)';
}


}

/// @nodoc
abstract mixin class _$AlarmCopyWith<$Res> implements $AlarmCopyWith<$Res> {
  factory _$AlarmCopyWith(_Alarm value, $Res Function(_Alarm) _then) = __$AlarmCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'alarm_id') String id,@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'event_id') String? definitionId, String type, String severity, DateTime timestamp, bool acknowledged,@JsonKey(name: 'acknowledged_by') String? acknowledgedBy,@JsonKey(name: 'acknowledged_at') DateTime? acknowledgedAt, bool resolved,@JsonKey(name: 'resolved_at') DateTime? resolvedAt, String? description
});




}
/// @nodoc
class __$AlarmCopyWithImpl<$Res>
    implements _$AlarmCopyWith<$Res> {
  __$AlarmCopyWithImpl(this._self, this._then);

  final _Alarm _self;
  final $Res Function(_Alarm) _then;

/// Create a copy of Alarm
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sessionId = null,Object? definitionId = freezed,Object? type = null,Object? severity = null,Object? timestamp = null,Object? acknowledged = null,Object? acknowledgedBy = freezed,Object? acknowledgedAt = freezed,Object? resolved = null,Object? resolvedAt = freezed,Object? description = freezed,}) {
  return _then(_Alarm(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,definitionId: freezed == definitionId ? _self.definitionId : definitionId // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,acknowledged: null == acknowledged ? _self.acknowledged : acknowledged // ignore: cast_nullable_to_non_nullable
as bool,acknowledgedBy: freezed == acknowledgedBy ? _self.acknowledgedBy : acknowledgedBy // ignore: cast_nullable_to_non_nullable
as String?,acknowledgedAt: freezed == acknowledgedAt ? _self.acknowledgedAt : acknowledgedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,resolved: null == resolved ? _self.resolved : resolved // ignore: cast_nullable_to_non_nullable
as bool,resolvedAt: freezed == resolvedAt ? _self.resolvedAt : resolvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
