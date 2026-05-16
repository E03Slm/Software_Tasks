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

@JsonKey(name: 'event_id') String get id;@JsonKey(name: 'session_id') String get sessionId;@JsonKey(name: 'alarm_id') String get alarmId;// FK to alarms table
@JsonKey(name: 'timestamp') DateTime get alarmTime;@JsonKey(name: 'type') String? get type;@JsonKey(name: 'ack_res') bool get ackRes;@JsonKey(name: 'ack_res_by') String? get ackResBy;@JsonKey(name: 'ack_res_at') DateTime? get ackResAt;@JsonKey(name: 'definition') AlarmDefinition? get definition;
/// Create a copy of Alarm
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlarmCopyWith<Alarm> get copyWith => _$AlarmCopyWithImpl<Alarm>(this as Alarm, _$identity);

  /// Serializes this Alarm to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Alarm&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.alarmId, alarmId) || other.alarmId == alarmId)&&(identical(other.alarmTime, alarmTime) || other.alarmTime == alarmTime)&&(identical(other.type, type) || other.type == type)&&(identical(other.ackRes, ackRes) || other.ackRes == ackRes)&&(identical(other.ackResBy, ackResBy) || other.ackResBy == ackResBy)&&(identical(other.ackResAt, ackResAt) || other.ackResAt == ackResAt)&&(identical(other.definition, definition) || other.definition == definition));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sessionId,alarmId,alarmTime,type,ackRes,ackResBy,ackResAt,definition);

@override
String toString() {
  return 'Alarm(id: $id, sessionId: $sessionId, alarmId: $alarmId, alarmTime: $alarmTime, type: $type, ackRes: $ackRes, ackResBy: $ackResBy, ackResAt: $ackResAt, definition: $definition)';
}


}

/// @nodoc
abstract mixin class $AlarmCopyWith<$Res>  {
  factory $AlarmCopyWith(Alarm value, $Res Function(Alarm) _then) = _$AlarmCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'event_id') String id,@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'alarm_id') String alarmId,@JsonKey(name: 'timestamp') DateTime alarmTime,@JsonKey(name: 'type') String? type,@JsonKey(name: 'ack_res') bool ackRes,@JsonKey(name: 'ack_res_by') String? ackResBy,@JsonKey(name: 'ack_res_at') DateTime? ackResAt,@JsonKey(name: 'definition') AlarmDefinition? definition
});


$AlarmDefinitionCopyWith<$Res>? get definition;

}
/// @nodoc
class _$AlarmCopyWithImpl<$Res>
    implements $AlarmCopyWith<$Res> {
  _$AlarmCopyWithImpl(this._self, this._then);

  final Alarm _self;
  final $Res Function(Alarm) _then;

/// Create a copy of Alarm
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sessionId = null,Object? alarmId = null,Object? alarmTime = null,Object? type = freezed,Object? ackRes = null,Object? ackResBy = freezed,Object? ackResAt = freezed,Object? definition = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,alarmId: null == alarmId ? _self.alarmId : alarmId // ignore: cast_nullable_to_non_nullable
as String,alarmTime: null == alarmTime ? _self.alarmTime : alarmTime // ignore: cast_nullable_to_non_nullable
as DateTime,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,ackRes: null == ackRes ? _self.ackRes : ackRes // ignore: cast_nullable_to_non_nullable
as bool,ackResBy: freezed == ackResBy ? _self.ackResBy : ackResBy // ignore: cast_nullable_to_non_nullable
as String?,ackResAt: freezed == ackResAt ? _self.ackResAt : ackResAt // ignore: cast_nullable_to_non_nullable
as DateTime?,definition: freezed == definition ? _self.definition : definition // ignore: cast_nullable_to_non_nullable
as AlarmDefinition?,
  ));
}
/// Create a copy of Alarm
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AlarmDefinitionCopyWith<$Res>? get definition {
    if (_self.definition == null) {
    return null;
  }

  return $AlarmDefinitionCopyWith<$Res>(_self.definition!, (value) {
    return _then(_self.copyWith(definition: value));
  });
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'event_id')  String id, @JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'alarm_id')  String alarmId, @JsonKey(name: 'timestamp')  DateTime alarmTime, @JsonKey(name: 'type')  String? type, @JsonKey(name: 'ack_res')  bool ackRes, @JsonKey(name: 'ack_res_by')  String? ackResBy, @JsonKey(name: 'ack_res_at')  DateTime? ackResAt, @JsonKey(name: 'definition')  AlarmDefinition? definition)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Alarm() when $default != null:
return $default(_that.id,_that.sessionId,_that.alarmId,_that.alarmTime,_that.type,_that.ackRes,_that.ackResBy,_that.ackResAt,_that.definition);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'event_id')  String id, @JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'alarm_id')  String alarmId, @JsonKey(name: 'timestamp')  DateTime alarmTime, @JsonKey(name: 'type')  String? type, @JsonKey(name: 'ack_res')  bool ackRes, @JsonKey(name: 'ack_res_by')  String? ackResBy, @JsonKey(name: 'ack_res_at')  DateTime? ackResAt, @JsonKey(name: 'definition')  AlarmDefinition? definition)  $default,) {final _that = this;
switch (_that) {
case _Alarm():
return $default(_that.id,_that.sessionId,_that.alarmId,_that.alarmTime,_that.type,_that.ackRes,_that.ackResBy,_that.ackResAt,_that.definition);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'event_id')  String id, @JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'alarm_id')  String alarmId, @JsonKey(name: 'timestamp')  DateTime alarmTime, @JsonKey(name: 'type')  String? type, @JsonKey(name: 'ack_res')  bool ackRes, @JsonKey(name: 'ack_res_by')  String? ackResBy, @JsonKey(name: 'ack_res_at')  DateTime? ackResAt, @JsonKey(name: 'definition')  AlarmDefinition? definition)?  $default,) {final _that = this;
switch (_that) {
case _Alarm() when $default != null:
return $default(_that.id,_that.sessionId,_that.alarmId,_that.alarmTime,_that.type,_that.ackRes,_that.ackResBy,_that.ackResAt,_that.definition);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Alarm extends Alarm {
  const _Alarm({@JsonKey(name: 'event_id') required this.id, @JsonKey(name: 'session_id') required this.sessionId, @JsonKey(name: 'alarm_id') required this.alarmId, @JsonKey(name: 'timestamp') required this.alarmTime, @JsonKey(name: 'type') this.type, @JsonKey(name: 'ack_res') this.ackRes = false, @JsonKey(name: 'ack_res_by') this.ackResBy, @JsonKey(name: 'ack_res_at') this.ackResAt, @JsonKey(name: 'definition') this.definition}): super._();
  factory _Alarm.fromJson(Map<String, dynamic> json) => _$AlarmFromJson(json);

@override@JsonKey(name: 'event_id') final  String id;
@override@JsonKey(name: 'session_id') final  String sessionId;
@override@JsonKey(name: 'alarm_id') final  String alarmId;
// FK to alarms table
@override@JsonKey(name: 'timestamp') final  DateTime alarmTime;
@override@JsonKey(name: 'type') final  String? type;
@override@JsonKey(name: 'ack_res') final  bool ackRes;
@override@JsonKey(name: 'ack_res_by') final  String? ackResBy;
@override@JsonKey(name: 'ack_res_at') final  DateTime? ackResAt;
@override@JsonKey(name: 'definition') final  AlarmDefinition? definition;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Alarm&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.alarmId, alarmId) || other.alarmId == alarmId)&&(identical(other.alarmTime, alarmTime) || other.alarmTime == alarmTime)&&(identical(other.type, type) || other.type == type)&&(identical(other.ackRes, ackRes) || other.ackRes == ackRes)&&(identical(other.ackResBy, ackResBy) || other.ackResBy == ackResBy)&&(identical(other.ackResAt, ackResAt) || other.ackResAt == ackResAt)&&(identical(other.definition, definition) || other.definition == definition));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sessionId,alarmId,alarmTime,type,ackRes,ackResBy,ackResAt,definition);

@override
String toString() {
  return 'Alarm(id: $id, sessionId: $sessionId, alarmId: $alarmId, alarmTime: $alarmTime, type: $type, ackRes: $ackRes, ackResBy: $ackResBy, ackResAt: $ackResAt, definition: $definition)';
}


}

/// @nodoc
abstract mixin class _$AlarmCopyWith<$Res> implements $AlarmCopyWith<$Res> {
  factory _$AlarmCopyWith(_Alarm value, $Res Function(_Alarm) _then) = __$AlarmCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'event_id') String id,@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'alarm_id') String alarmId,@JsonKey(name: 'timestamp') DateTime alarmTime,@JsonKey(name: 'type') String? type,@JsonKey(name: 'ack_res') bool ackRes,@JsonKey(name: 'ack_res_by') String? ackResBy,@JsonKey(name: 'ack_res_at') DateTime? ackResAt,@JsonKey(name: 'definition') AlarmDefinition? definition
});


@override $AlarmDefinitionCopyWith<$Res>? get definition;

}
/// @nodoc
class __$AlarmCopyWithImpl<$Res>
    implements _$AlarmCopyWith<$Res> {
  __$AlarmCopyWithImpl(this._self, this._then);

  final _Alarm _self;
  final $Res Function(_Alarm) _then;

/// Create a copy of Alarm
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sessionId = null,Object? alarmId = null,Object? alarmTime = null,Object? type = freezed,Object? ackRes = null,Object? ackResBy = freezed,Object? ackResAt = freezed,Object? definition = freezed,}) {
  return _then(_Alarm(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,alarmId: null == alarmId ? _self.alarmId : alarmId // ignore: cast_nullable_to_non_nullable
as String,alarmTime: null == alarmTime ? _self.alarmTime : alarmTime // ignore: cast_nullable_to_non_nullable
as DateTime,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,ackRes: null == ackRes ? _self.ackRes : ackRes // ignore: cast_nullable_to_non_nullable
as bool,ackResBy: freezed == ackResBy ? _self.ackResBy : ackResBy // ignore: cast_nullable_to_non_nullable
as String?,ackResAt: freezed == ackResAt ? _self.ackResAt : ackResAt // ignore: cast_nullable_to_non_nullable
as DateTime?,definition: freezed == definition ? _self.definition : definition // ignore: cast_nullable_to_non_nullable
as AlarmDefinition?,
  ));
}

/// Create a copy of Alarm
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AlarmDefinitionCopyWith<$Res>? get definition {
    if (_self.definition == null) {
    return null;
  }

  return $AlarmDefinitionCopyWith<$Res>(_self.definition!, (value) {
    return _then(_self.copyWith(definition: value));
  });
}
}

// dart format on
