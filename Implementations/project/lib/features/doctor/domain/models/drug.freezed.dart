// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'drug.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Drug {

@JsonKey(name: 'drug_id') String get id; String get name; double get concentration;@JsonKey(name: 'concentration_unit') String get concentrationUnit;@JsonKey(name: 'default_rate') double get defaultRate;@JsonKey(name: 'rate_unit') String get rateUnit;@JsonKey(name: 'hard_limit_high') double get hardLimitHigh;@JsonKey(name: 'soft_limit_high') double? get softLimitHigh;@JsonKey(name: 'Is_Deleted') bool get isDeleted;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'created_by') String? get createdBy;@JsonKey(name: 'updated_at') DateTime? get updatedAt;@JsonKey(name: 'updated_by') String? get updatedBy;
/// Create a copy of Drug
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DrugCopyWith<Drug> get copyWith => _$DrugCopyWithImpl<Drug>(this as Drug, _$identity);

  /// Serializes this Drug to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Drug&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.concentration, concentration) || other.concentration == concentration)&&(identical(other.concentrationUnit, concentrationUnit) || other.concentrationUnit == concentrationUnit)&&(identical(other.defaultRate, defaultRate) || other.defaultRate == defaultRate)&&(identical(other.rateUnit, rateUnit) || other.rateUnit == rateUnit)&&(identical(other.hardLimitHigh, hardLimitHigh) || other.hardLimitHigh == hardLimitHigh)&&(identical(other.softLimitHigh, softLimitHigh) || other.softLimitHigh == softLimitHigh)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,concentration,concentrationUnit,defaultRate,rateUnit,hardLimitHigh,softLimitHigh,isDeleted,createdAt,createdBy,updatedAt,updatedBy);

@override
String toString() {
  return 'Drug(id: $id, name: $name, concentration: $concentration, concentrationUnit: $concentrationUnit, defaultRate: $defaultRate, rateUnit: $rateUnit, hardLimitHigh: $hardLimitHigh, softLimitHigh: $softLimitHigh, isDeleted: $isDeleted, createdAt: $createdAt, createdBy: $createdBy, updatedAt: $updatedAt, updatedBy: $updatedBy)';
}


}

/// @nodoc
abstract mixin class $DrugCopyWith<$Res>  {
  factory $DrugCopyWith(Drug value, $Res Function(Drug) _then) = _$DrugCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'drug_id') String id, String name, double concentration,@JsonKey(name: 'concentration_unit') String concentrationUnit,@JsonKey(name: 'default_rate') double defaultRate,@JsonKey(name: 'rate_unit') String rateUnit,@JsonKey(name: 'hard_limit_high') double hardLimitHigh,@JsonKey(name: 'soft_limit_high') double? softLimitHigh,@JsonKey(name: 'Is_Deleted') bool isDeleted,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'created_by') String? createdBy,@JsonKey(name: 'updated_at') DateTime? updatedAt,@JsonKey(name: 'updated_by') String? updatedBy
});




}
/// @nodoc
class _$DrugCopyWithImpl<$Res>
    implements $DrugCopyWith<$Res> {
  _$DrugCopyWithImpl(this._self, this._then);

  final Drug _self;
  final $Res Function(Drug) _then;

/// Create a copy of Drug
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? concentration = null,Object? concentrationUnit = null,Object? defaultRate = null,Object? rateUnit = null,Object? hardLimitHigh = null,Object? softLimitHigh = freezed,Object? isDeleted = null,Object? createdAt = null,Object? createdBy = freezed,Object? updatedAt = freezed,Object? updatedBy = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,concentration: null == concentration ? _self.concentration : concentration // ignore: cast_nullable_to_non_nullable
as double,concentrationUnit: null == concentrationUnit ? _self.concentrationUnit : concentrationUnit // ignore: cast_nullable_to_non_nullable
as String,defaultRate: null == defaultRate ? _self.defaultRate : defaultRate // ignore: cast_nullable_to_non_nullable
as double,rateUnit: null == rateUnit ? _self.rateUnit : rateUnit // ignore: cast_nullable_to_non_nullable
as String,hardLimitHigh: null == hardLimitHigh ? _self.hardLimitHigh : hardLimitHigh // ignore: cast_nullable_to_non_nullable
as double,softLimitHigh: freezed == softLimitHigh ? _self.softLimitHigh : softLimitHigh // ignore: cast_nullable_to_non_nullable
as double?,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedBy: freezed == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Drug].
extension DrugPatterns on Drug {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Drug value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Drug() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Drug value)  $default,){
final _that = this;
switch (_that) {
case _Drug():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Drug value)?  $default,){
final _that = this;
switch (_that) {
case _Drug() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'drug_id')  String id,  String name,  double concentration, @JsonKey(name: 'concentration_unit')  String concentrationUnit, @JsonKey(name: 'default_rate')  double defaultRate, @JsonKey(name: 'rate_unit')  String rateUnit, @JsonKey(name: 'hard_limit_high')  double hardLimitHigh, @JsonKey(name: 'soft_limit_high')  double? softLimitHigh, @JsonKey(name: 'Is_Deleted')  bool isDeleted, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'created_by')  String? createdBy, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'updated_by')  String? updatedBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Drug() when $default != null:
return $default(_that.id,_that.name,_that.concentration,_that.concentrationUnit,_that.defaultRate,_that.rateUnit,_that.hardLimitHigh,_that.softLimitHigh,_that.isDeleted,_that.createdAt,_that.createdBy,_that.updatedAt,_that.updatedBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'drug_id')  String id,  String name,  double concentration, @JsonKey(name: 'concentration_unit')  String concentrationUnit, @JsonKey(name: 'default_rate')  double defaultRate, @JsonKey(name: 'rate_unit')  String rateUnit, @JsonKey(name: 'hard_limit_high')  double hardLimitHigh, @JsonKey(name: 'soft_limit_high')  double? softLimitHigh, @JsonKey(name: 'Is_Deleted')  bool isDeleted, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'created_by')  String? createdBy, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'updated_by')  String? updatedBy)  $default,) {final _that = this;
switch (_that) {
case _Drug():
return $default(_that.id,_that.name,_that.concentration,_that.concentrationUnit,_that.defaultRate,_that.rateUnit,_that.hardLimitHigh,_that.softLimitHigh,_that.isDeleted,_that.createdAt,_that.createdBy,_that.updatedAt,_that.updatedBy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'drug_id')  String id,  String name,  double concentration, @JsonKey(name: 'concentration_unit')  String concentrationUnit, @JsonKey(name: 'default_rate')  double defaultRate, @JsonKey(name: 'rate_unit')  String rateUnit, @JsonKey(name: 'hard_limit_high')  double hardLimitHigh, @JsonKey(name: 'soft_limit_high')  double? softLimitHigh, @JsonKey(name: 'Is_Deleted')  bool isDeleted, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'created_by')  String? createdBy, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'updated_by')  String? updatedBy)?  $default,) {final _that = this;
switch (_that) {
case _Drug() when $default != null:
return $default(_that.id,_that.name,_that.concentration,_that.concentrationUnit,_that.defaultRate,_that.rateUnit,_that.hardLimitHigh,_that.softLimitHigh,_that.isDeleted,_that.createdAt,_that.createdBy,_that.updatedAt,_that.updatedBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Drug extends Drug {
  const _Drug({@JsonKey(name: 'drug_id') required this.id, required this.name, required this.concentration, @JsonKey(name: 'concentration_unit') required this.concentrationUnit, @JsonKey(name: 'default_rate') required this.defaultRate, @JsonKey(name: 'rate_unit') this.rateUnit = 'mL/hr', @JsonKey(name: 'hard_limit_high') required this.hardLimitHigh, @JsonKey(name: 'soft_limit_high') this.softLimitHigh, @JsonKey(name: 'Is_Deleted') this.isDeleted = false, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'created_by') this.createdBy, @JsonKey(name: 'updated_at') this.updatedAt, @JsonKey(name: 'updated_by') this.updatedBy}): super._();
  factory _Drug.fromJson(Map<String, dynamic> json) => _$DrugFromJson(json);

@override@JsonKey(name: 'drug_id') final  String id;
@override final  String name;
@override final  double concentration;
@override@JsonKey(name: 'concentration_unit') final  String concentrationUnit;
@override@JsonKey(name: 'default_rate') final  double defaultRate;
@override@JsonKey(name: 'rate_unit') final  String rateUnit;
@override@JsonKey(name: 'hard_limit_high') final  double hardLimitHigh;
@override@JsonKey(name: 'soft_limit_high') final  double? softLimitHigh;
@override@JsonKey(name: 'Is_Deleted') final  bool isDeleted;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'created_by') final  String? createdBy;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;
@override@JsonKey(name: 'updated_by') final  String? updatedBy;

/// Create a copy of Drug
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DrugCopyWith<_Drug> get copyWith => __$DrugCopyWithImpl<_Drug>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DrugToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Drug&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.concentration, concentration) || other.concentration == concentration)&&(identical(other.concentrationUnit, concentrationUnit) || other.concentrationUnit == concentrationUnit)&&(identical(other.defaultRate, defaultRate) || other.defaultRate == defaultRate)&&(identical(other.rateUnit, rateUnit) || other.rateUnit == rateUnit)&&(identical(other.hardLimitHigh, hardLimitHigh) || other.hardLimitHigh == hardLimitHigh)&&(identical(other.softLimitHigh, softLimitHigh) || other.softLimitHigh == softLimitHigh)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,concentration,concentrationUnit,defaultRate,rateUnit,hardLimitHigh,softLimitHigh,isDeleted,createdAt,createdBy,updatedAt,updatedBy);

@override
String toString() {
  return 'Drug(id: $id, name: $name, concentration: $concentration, concentrationUnit: $concentrationUnit, defaultRate: $defaultRate, rateUnit: $rateUnit, hardLimitHigh: $hardLimitHigh, softLimitHigh: $softLimitHigh, isDeleted: $isDeleted, createdAt: $createdAt, createdBy: $createdBy, updatedAt: $updatedAt, updatedBy: $updatedBy)';
}


}

/// @nodoc
abstract mixin class _$DrugCopyWith<$Res> implements $DrugCopyWith<$Res> {
  factory _$DrugCopyWith(_Drug value, $Res Function(_Drug) _then) = __$DrugCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'drug_id') String id, String name, double concentration,@JsonKey(name: 'concentration_unit') String concentrationUnit,@JsonKey(name: 'default_rate') double defaultRate,@JsonKey(name: 'rate_unit') String rateUnit,@JsonKey(name: 'hard_limit_high') double hardLimitHigh,@JsonKey(name: 'soft_limit_high') double? softLimitHigh,@JsonKey(name: 'Is_Deleted') bool isDeleted,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'created_by') String? createdBy,@JsonKey(name: 'updated_at') DateTime? updatedAt,@JsonKey(name: 'updated_by') String? updatedBy
});




}
/// @nodoc
class __$DrugCopyWithImpl<$Res>
    implements _$DrugCopyWith<$Res> {
  __$DrugCopyWithImpl(this._self, this._then);

  final _Drug _self;
  final $Res Function(_Drug) _then;

/// Create a copy of Drug
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? concentration = null,Object? concentrationUnit = null,Object? defaultRate = null,Object? rateUnit = null,Object? hardLimitHigh = null,Object? softLimitHigh = freezed,Object? isDeleted = null,Object? createdAt = null,Object? createdBy = freezed,Object? updatedAt = freezed,Object? updatedBy = freezed,}) {
  return _then(_Drug(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,concentration: null == concentration ? _self.concentration : concentration // ignore: cast_nullable_to_non_nullable
as double,concentrationUnit: null == concentrationUnit ? _self.concentrationUnit : concentrationUnit // ignore: cast_nullable_to_non_nullable
as String,defaultRate: null == defaultRate ? _self.defaultRate : defaultRate // ignore: cast_nullable_to_non_nullable
as double,rateUnit: null == rateUnit ? _self.rateUnit : rateUnit // ignore: cast_nullable_to_non_nullable
as String,hardLimitHigh: null == hardLimitHigh ? _self.hardLimitHigh : hardLimitHigh // ignore: cast_nullable_to_non_nullable
as double,softLimitHigh: freezed == softLimitHigh ? _self.softLimitHigh : softLimitHigh // ignore: cast_nullable_to_non_nullable
as double?,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedBy: freezed == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
