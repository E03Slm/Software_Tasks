// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'infusion_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InfusionSession {

 String get id; String get nurseId; Drug get drug; double get concentration; String? get patientId; double get infusionRate; double get totalVolume; double get volumeInfused; double get volumeRemaining; InfusionState get currentState; double get batteryLevel; bool? get kvoEnabled; double? get kvoRate; double? get bolusDose; DateTime? get startedAt;
/// Create a copy of InfusionSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InfusionSessionCopyWith<InfusionSession> get copyWith => _$InfusionSessionCopyWithImpl<InfusionSession>(this as InfusionSession, _$identity);

  /// Serializes this InfusionSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InfusionSession&&(identical(other.id, id) || other.id == id)&&(identical(other.nurseId, nurseId) || other.nurseId == nurseId)&&(identical(other.drug, drug) || other.drug == drug)&&(identical(other.concentration, concentration) || other.concentration == concentration)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.infusionRate, infusionRate) || other.infusionRate == infusionRate)&&(identical(other.totalVolume, totalVolume) || other.totalVolume == totalVolume)&&(identical(other.volumeInfused, volumeInfused) || other.volumeInfused == volumeInfused)&&(identical(other.volumeRemaining, volumeRemaining) || other.volumeRemaining == volumeRemaining)&&(identical(other.currentState, currentState) || other.currentState == currentState)&&(identical(other.batteryLevel, batteryLevel) || other.batteryLevel == batteryLevel)&&(identical(other.kvoEnabled, kvoEnabled) || other.kvoEnabled == kvoEnabled)&&(identical(other.kvoRate, kvoRate) || other.kvoRate == kvoRate)&&(identical(other.bolusDose, bolusDose) || other.bolusDose == bolusDose)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nurseId,drug,concentration,patientId,infusionRate,totalVolume,volumeInfused,volumeRemaining,currentState,batteryLevel,kvoEnabled,kvoRate,bolusDose,startedAt);

@override
String toString() {
  return 'InfusionSession(id: $id, nurseId: $nurseId, drug: $drug, concentration: $concentration, patientId: $patientId, infusionRate: $infusionRate, totalVolume: $totalVolume, volumeInfused: $volumeInfused, volumeRemaining: $volumeRemaining, currentState: $currentState, batteryLevel: $batteryLevel, kvoEnabled: $kvoEnabled, kvoRate: $kvoRate, bolusDose: $bolusDose, startedAt: $startedAt)';
}


}

/// @nodoc
abstract mixin class $InfusionSessionCopyWith<$Res>  {
  factory $InfusionSessionCopyWith(InfusionSession value, $Res Function(InfusionSession) _then) = _$InfusionSessionCopyWithImpl;
@useResult
$Res call({
 String id, String nurseId, Drug drug, double concentration, String? patientId, double infusionRate, double totalVolume, double volumeInfused, double volumeRemaining, InfusionState currentState, double batteryLevel, bool? kvoEnabled, double? kvoRate, double? bolusDose, DateTime? startedAt
});


$DrugCopyWith<$Res> get drug;

}
/// @nodoc
class _$InfusionSessionCopyWithImpl<$Res>
    implements $InfusionSessionCopyWith<$Res> {
  _$InfusionSessionCopyWithImpl(this._self, this._then);

  final InfusionSession _self;
  final $Res Function(InfusionSession) _then;

/// Create a copy of InfusionSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nurseId = null,Object? drug = null,Object? concentration = null,Object? patientId = freezed,Object? infusionRate = null,Object? totalVolume = null,Object? volumeInfused = null,Object? volumeRemaining = null,Object? currentState = null,Object? batteryLevel = null,Object? kvoEnabled = freezed,Object? kvoRate = freezed,Object? bolusDose = freezed,Object? startedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nurseId: null == nurseId ? _self.nurseId : nurseId // ignore: cast_nullable_to_non_nullable
as String,drug: null == drug ? _self.drug : drug // ignore: cast_nullable_to_non_nullable
as Drug,concentration: null == concentration ? _self.concentration : concentration // ignore: cast_nullable_to_non_nullable
as double,patientId: freezed == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String?,infusionRate: null == infusionRate ? _self.infusionRate : infusionRate // ignore: cast_nullable_to_non_nullable
as double,totalVolume: null == totalVolume ? _self.totalVolume : totalVolume // ignore: cast_nullable_to_non_nullable
as double,volumeInfused: null == volumeInfused ? _self.volumeInfused : volumeInfused // ignore: cast_nullable_to_non_nullable
as double,volumeRemaining: null == volumeRemaining ? _self.volumeRemaining : volumeRemaining // ignore: cast_nullable_to_non_nullable
as double,currentState: null == currentState ? _self.currentState : currentState // ignore: cast_nullable_to_non_nullable
as InfusionState,batteryLevel: null == batteryLevel ? _self.batteryLevel : batteryLevel // ignore: cast_nullable_to_non_nullable
as double,kvoEnabled: freezed == kvoEnabled ? _self.kvoEnabled : kvoEnabled // ignore: cast_nullable_to_non_nullable
as bool?,kvoRate: freezed == kvoRate ? _self.kvoRate : kvoRate // ignore: cast_nullable_to_non_nullable
as double?,bolusDose: freezed == bolusDose ? _self.bolusDose : bolusDose // ignore: cast_nullable_to_non_nullable
as double?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of InfusionSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DrugCopyWith<$Res> get drug {
  
  return $DrugCopyWith<$Res>(_self.drug, (value) {
    return _then(_self.copyWith(drug: value));
  });
}
}


/// Adds pattern-matching-related methods to [InfusionSession].
extension InfusionSessionPatterns on InfusionSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InfusionSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InfusionSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InfusionSession value)  $default,){
final _that = this;
switch (_that) {
case _InfusionSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InfusionSession value)?  $default,){
final _that = this;
switch (_that) {
case _InfusionSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String nurseId,  Drug drug,  double concentration,  String? patientId,  double infusionRate,  double totalVolume,  double volumeInfused,  double volumeRemaining,  InfusionState currentState,  double batteryLevel,  bool? kvoEnabled,  double? kvoRate,  double? bolusDose,  DateTime? startedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InfusionSession() when $default != null:
return $default(_that.id,_that.nurseId,_that.drug,_that.concentration,_that.patientId,_that.infusionRate,_that.totalVolume,_that.volumeInfused,_that.volumeRemaining,_that.currentState,_that.batteryLevel,_that.kvoEnabled,_that.kvoRate,_that.bolusDose,_that.startedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String nurseId,  Drug drug,  double concentration,  String? patientId,  double infusionRate,  double totalVolume,  double volumeInfused,  double volumeRemaining,  InfusionState currentState,  double batteryLevel,  bool? kvoEnabled,  double? kvoRate,  double? bolusDose,  DateTime? startedAt)  $default,) {final _that = this;
switch (_that) {
case _InfusionSession():
return $default(_that.id,_that.nurseId,_that.drug,_that.concentration,_that.patientId,_that.infusionRate,_that.totalVolume,_that.volumeInfused,_that.volumeRemaining,_that.currentState,_that.batteryLevel,_that.kvoEnabled,_that.kvoRate,_that.bolusDose,_that.startedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String nurseId,  Drug drug,  double concentration,  String? patientId,  double infusionRate,  double totalVolume,  double volumeInfused,  double volumeRemaining,  InfusionState currentState,  double batteryLevel,  bool? kvoEnabled,  double? kvoRate,  double? bolusDose,  DateTime? startedAt)?  $default,) {final _that = this;
switch (_that) {
case _InfusionSession() when $default != null:
return $default(_that.id,_that.nurseId,_that.drug,_that.concentration,_that.patientId,_that.infusionRate,_that.totalVolume,_that.volumeInfused,_that.volumeRemaining,_that.currentState,_that.batteryLevel,_that.kvoEnabled,_that.kvoRate,_that.bolusDose,_that.startedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InfusionSession implements InfusionSession {
  const _InfusionSession({required this.id, required this.nurseId, required this.drug, required this.concentration, required this.patientId, required this.infusionRate, required this.totalVolume, required this.volumeInfused, required this.volumeRemaining, required this.currentState, required this.batteryLevel, required this.kvoEnabled, required this.kvoRate, this.bolusDose, this.startedAt});
  factory _InfusionSession.fromJson(Map<String, dynamic> json) => _$InfusionSessionFromJson(json);

@override final  String id;
@override final  String nurseId;
@override final  Drug drug;
@override final  double concentration;
@override final  String? patientId;
@override final  double infusionRate;
@override final  double totalVolume;
@override final  double volumeInfused;
@override final  double volumeRemaining;
@override final  InfusionState currentState;
@override final  double batteryLevel;
@override final  bool? kvoEnabled;
@override final  double? kvoRate;
@override final  double? bolusDose;
@override final  DateTime? startedAt;

/// Create a copy of InfusionSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InfusionSessionCopyWith<_InfusionSession> get copyWith => __$InfusionSessionCopyWithImpl<_InfusionSession>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InfusionSessionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InfusionSession&&(identical(other.id, id) || other.id == id)&&(identical(other.nurseId, nurseId) || other.nurseId == nurseId)&&(identical(other.drug, drug) || other.drug == drug)&&(identical(other.concentration, concentration) || other.concentration == concentration)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.infusionRate, infusionRate) || other.infusionRate == infusionRate)&&(identical(other.totalVolume, totalVolume) || other.totalVolume == totalVolume)&&(identical(other.volumeInfused, volumeInfused) || other.volumeInfused == volumeInfused)&&(identical(other.volumeRemaining, volumeRemaining) || other.volumeRemaining == volumeRemaining)&&(identical(other.currentState, currentState) || other.currentState == currentState)&&(identical(other.batteryLevel, batteryLevel) || other.batteryLevel == batteryLevel)&&(identical(other.kvoEnabled, kvoEnabled) || other.kvoEnabled == kvoEnabled)&&(identical(other.kvoRate, kvoRate) || other.kvoRate == kvoRate)&&(identical(other.bolusDose, bolusDose) || other.bolusDose == bolusDose)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nurseId,drug,concentration,patientId,infusionRate,totalVolume,volumeInfused,volumeRemaining,currentState,batteryLevel,kvoEnabled,kvoRate,bolusDose,startedAt);

@override
String toString() {
  return 'InfusionSession(id: $id, nurseId: $nurseId, drug: $drug, concentration: $concentration, patientId: $patientId, infusionRate: $infusionRate, totalVolume: $totalVolume, volumeInfused: $volumeInfused, volumeRemaining: $volumeRemaining, currentState: $currentState, batteryLevel: $batteryLevel, kvoEnabled: $kvoEnabled, kvoRate: $kvoRate, bolusDose: $bolusDose, startedAt: $startedAt)';
}


}

/// @nodoc
abstract mixin class _$InfusionSessionCopyWith<$Res> implements $InfusionSessionCopyWith<$Res> {
  factory _$InfusionSessionCopyWith(_InfusionSession value, $Res Function(_InfusionSession) _then) = __$InfusionSessionCopyWithImpl;
@override @useResult
$Res call({
 String id, String nurseId, Drug drug, double concentration, String? patientId, double infusionRate, double totalVolume, double volumeInfused, double volumeRemaining, InfusionState currentState, double batteryLevel, bool? kvoEnabled, double? kvoRate, double? bolusDose, DateTime? startedAt
});


@override $DrugCopyWith<$Res> get drug;

}
/// @nodoc
class __$InfusionSessionCopyWithImpl<$Res>
    implements _$InfusionSessionCopyWith<$Res> {
  __$InfusionSessionCopyWithImpl(this._self, this._then);

  final _InfusionSession _self;
  final $Res Function(_InfusionSession) _then;

/// Create a copy of InfusionSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nurseId = null,Object? drug = null,Object? concentration = null,Object? patientId = freezed,Object? infusionRate = null,Object? totalVolume = null,Object? volumeInfused = null,Object? volumeRemaining = null,Object? currentState = null,Object? batteryLevel = null,Object? kvoEnabled = freezed,Object? kvoRate = freezed,Object? bolusDose = freezed,Object? startedAt = freezed,}) {
  return _then(_InfusionSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nurseId: null == nurseId ? _self.nurseId : nurseId // ignore: cast_nullable_to_non_nullable
as String,drug: null == drug ? _self.drug : drug // ignore: cast_nullable_to_non_nullable
as Drug,concentration: null == concentration ? _self.concentration : concentration // ignore: cast_nullable_to_non_nullable
as double,patientId: freezed == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String?,infusionRate: null == infusionRate ? _self.infusionRate : infusionRate // ignore: cast_nullable_to_non_nullable
as double,totalVolume: null == totalVolume ? _self.totalVolume : totalVolume // ignore: cast_nullable_to_non_nullable
as double,volumeInfused: null == volumeInfused ? _self.volumeInfused : volumeInfused // ignore: cast_nullable_to_non_nullable
as double,volumeRemaining: null == volumeRemaining ? _self.volumeRemaining : volumeRemaining // ignore: cast_nullable_to_non_nullable
as double,currentState: null == currentState ? _self.currentState : currentState // ignore: cast_nullable_to_non_nullable
as InfusionState,batteryLevel: null == batteryLevel ? _self.batteryLevel : batteryLevel // ignore: cast_nullable_to_non_nullable
as double,kvoEnabled: freezed == kvoEnabled ? _self.kvoEnabled : kvoEnabled // ignore: cast_nullable_to_non_nullable
as bool?,kvoRate: freezed == kvoRate ? _self.kvoRate : kvoRate // ignore: cast_nullable_to_non_nullable
as double?,bolusDose: freezed == bolusDose ? _self.bolusDose : bolusDose // ignore: cast_nullable_to_non_nullable
as double?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of InfusionSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DrugCopyWith<$Res> get drug {
  
  return $DrugCopyWith<$Res>(_self.drug, (value) {
    return _then(_self.copyWith(drug: value));
  });
}
}

// dart format on
