// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alarm_definition.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AlarmDefinition {

@JsonKey(name: 'alarm_id') String get id;@JsonKey(name: 'alarm_name') String get name; String get severity; String get description;
/// Create a copy of AlarmDefinition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlarmDefinitionCopyWith<AlarmDefinition> get copyWith => _$AlarmDefinitionCopyWithImpl<AlarmDefinition>(this as AlarmDefinition, _$identity);

  /// Serializes this AlarmDefinition to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlarmDefinition&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,severity,description);

@override
String toString() {
  return 'AlarmDefinition(id: $id, name: $name, severity: $severity, description: $description)';
}


}

/// @nodoc
abstract mixin class $AlarmDefinitionCopyWith<$Res>  {
  factory $AlarmDefinitionCopyWith(AlarmDefinition value, $Res Function(AlarmDefinition) _then) = _$AlarmDefinitionCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'alarm_id') String id,@JsonKey(name: 'alarm_name') String name, String severity, String description
});




}
/// @nodoc
class _$AlarmDefinitionCopyWithImpl<$Res>
    implements $AlarmDefinitionCopyWith<$Res> {
  _$AlarmDefinitionCopyWithImpl(this._self, this._then);

  final AlarmDefinition _self;
  final $Res Function(AlarmDefinition) _then;

/// Create a copy of AlarmDefinition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? severity = null,Object? description = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AlarmDefinition].
extension AlarmDefinitionPatterns on AlarmDefinition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlarmDefinition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlarmDefinition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlarmDefinition value)  $default,){
final _that = this;
switch (_that) {
case _AlarmDefinition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlarmDefinition value)?  $default,){
final _that = this;
switch (_that) {
case _AlarmDefinition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'alarm_id')  String id, @JsonKey(name: 'alarm_name')  String name,  String severity,  String description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlarmDefinition() when $default != null:
return $default(_that.id,_that.name,_that.severity,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'alarm_id')  String id, @JsonKey(name: 'alarm_name')  String name,  String severity,  String description)  $default,) {final _that = this;
switch (_that) {
case _AlarmDefinition():
return $default(_that.id,_that.name,_that.severity,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'alarm_id')  String id, @JsonKey(name: 'alarm_name')  String name,  String severity,  String description)?  $default,) {final _that = this;
switch (_that) {
case _AlarmDefinition() when $default != null:
return $default(_that.id,_that.name,_that.severity,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AlarmDefinition implements AlarmDefinition {
  const _AlarmDefinition({@JsonKey(name: 'alarm_id') required this.id, @JsonKey(name: 'alarm_name') this.name = 'Unknown', this.severity = 'LOW', this.description = 'No description available'});
  factory _AlarmDefinition.fromJson(Map<String, dynamic> json) => _$AlarmDefinitionFromJson(json);

@override@JsonKey(name: 'alarm_id') final  String id;
@override@JsonKey(name: 'alarm_name') final  String name;
@override@JsonKey() final  String severity;
@override@JsonKey() final  String description;

/// Create a copy of AlarmDefinition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlarmDefinitionCopyWith<_AlarmDefinition> get copyWith => __$AlarmDefinitionCopyWithImpl<_AlarmDefinition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlarmDefinitionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlarmDefinition&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,severity,description);

@override
String toString() {
  return 'AlarmDefinition(id: $id, name: $name, severity: $severity, description: $description)';
}


}

/// @nodoc
abstract mixin class _$AlarmDefinitionCopyWith<$Res> implements $AlarmDefinitionCopyWith<$Res> {
  factory _$AlarmDefinitionCopyWith(_AlarmDefinition value, $Res Function(_AlarmDefinition) _then) = __$AlarmDefinitionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'alarm_id') String id,@JsonKey(name: 'alarm_name') String name, String severity, String description
});




}
/// @nodoc
class __$AlarmDefinitionCopyWithImpl<$Res>
    implements _$AlarmDefinitionCopyWith<$Res> {
  __$AlarmDefinitionCopyWithImpl(this._self, this._then);

  final _AlarmDefinition _self;
  final $Res Function(_AlarmDefinition) _then;

/// Create a copy of AlarmDefinition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? severity = null,Object? description = null,}) {
  return _then(_AlarmDefinition(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
