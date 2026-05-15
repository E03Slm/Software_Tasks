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

@JsonKey(name: 'session_id') String get id;@JsonKey(name: 'user_id') String? get userId;@JsonKey(name: 'Patient_id') String? get patientId;@JsonKey(name: 'drug_id') String? get drugId;@JsonKey(name: 'drug') Drug? get drug;@JsonKey(name: 'rate') double get infusionRate;@JsonKey(name: 'total_volume') double get totalVolume;@JsonKey(name: 'volume_infused') double get volumeInfused;@JsonKey(name: 'status') String get status;@JsonKey(name: 'start_time') DateTime? get startTime;@JsonKey(name: 'end_time') DateTime? get endTime;@JsonKey(name: 'bolus_enabled') bool get bolusEnabled;@JsonKey(name: 'kvo_enabled') bool get kvoEnabled;@JsonKey(name: 'kvo_rate') double? get kvoRate;@JsonKey(name: 'patient_weight') double get patientWeight;@JsonKey(name: 'target_dose') double? get targetDose;@JsonKey(name: 'dose_unit') String get doseUnit;@JsonKey(name: 'battery_level') int? get batteryLevel;
/// Create a copy of InfusionSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InfusionSessionCopyWith<InfusionSession> get copyWith => _$InfusionSessionCopyWithImpl<InfusionSession>(this as InfusionSession, _$identity);

  /// Serializes this InfusionSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InfusionSession&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.drugId, drugId) || other.drugId == drugId)&&(identical(other.drug, drug) || other.drug == drug)&&(identical(other.infusionRate, infusionRate) || other.infusionRate == infusionRate)&&(identical(other.totalVolume, totalVolume) || other.totalVolume == totalVolume)&&(identical(other.volumeInfused, volumeInfused) || other.volumeInfused == volumeInfused)&&(identical(other.status, status) || other.status == status)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.bolusEnabled, bolusEnabled) || other.bolusEnabled == bolusEnabled)&&(identical(other.kvoEnabled, kvoEnabled) || other.kvoEnabled == kvoEnabled)&&(identical(other.kvoRate, kvoRate) || other.kvoRate == kvoRate)&&(identical(other.patientWeight, patientWeight) || other.patientWeight == patientWeight)&&(identical(other.targetDose, targetDose) || other.targetDose == targetDose)&&(identical(other.doseUnit, doseUnit) || other.doseUnit == doseUnit)&&(identical(other.batteryLevel, batteryLevel) || other.batteryLevel == batteryLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,patientId,drugId,drug,infusionRate,totalVolume,volumeInfused,status,startTime,endTime,bolusEnabled,kvoEnabled,kvoRate,patientWeight,targetDose,doseUnit,batteryLevel);

@override
String toString() {
  return 'InfusionSession(id: $id, userId: $userId, patientId: $patientId, drugId: $drugId, drug: $drug, infusionRate: $infusionRate, totalVolume: $totalVolume, volumeInfused: $volumeInfused, status: $status, startTime: $startTime, endTime: $endTime, bolusEnabled: $bolusEnabled, kvoEnabled: $kvoEnabled, kvoRate: $kvoRate, patientWeight: $patientWeight, targetDose: $targetDose, doseUnit: $doseUnit, batteryLevel: $batteryLevel)';
}


}

/// @nodoc
abstract mixin class $InfusionSessionCopyWith<$Res>  {
  factory $InfusionSessionCopyWith(InfusionSession value, $Res Function(InfusionSession) _then) = _$InfusionSessionCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'session_id') String id,@JsonKey(name: 'user_id') String? userId,@JsonKey(name: 'Patient_id') String? patientId,@JsonKey(name: 'drug_id') String? drugId,@JsonKey(name: 'drug') Drug? drug,@JsonKey(name: 'rate') double infusionRate,@JsonKey(name: 'total_volume') double totalVolume,@JsonKey(name: 'volume_infused') double volumeInfused,@JsonKey(name: 'status') String status,@JsonKey(name: 'start_time') DateTime? startTime,@JsonKey(name: 'end_time') DateTime? endTime,@JsonKey(name: 'bolus_enabled') bool bolusEnabled,@JsonKey(name: 'kvo_enabled') bool kvoEnabled,@JsonKey(name: 'kvo_rate') double? kvoRate,@JsonKey(name: 'patient_weight') double patientWeight,@JsonKey(name: 'target_dose') double? targetDose,@JsonKey(name: 'dose_unit') String doseUnit,@JsonKey(name: 'battery_level') int? batteryLevel
});


$DrugCopyWith<$Res>? get drug;

}
/// @nodoc
class _$InfusionSessionCopyWithImpl<$Res>
    implements $InfusionSessionCopyWith<$Res> {
  _$InfusionSessionCopyWithImpl(this._self, this._then);

  final InfusionSession _self;
  final $Res Function(InfusionSession) _then;

/// Create a copy of InfusionSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = freezed,Object? patientId = freezed,Object? drugId = freezed,Object? drug = freezed,Object? infusionRate = null,Object? totalVolume = null,Object? volumeInfused = null,Object? status = null,Object? startTime = freezed,Object? endTime = freezed,Object? bolusEnabled = null,Object? kvoEnabled = null,Object? kvoRate = freezed,Object? patientWeight = null,Object? targetDose = freezed,Object? doseUnit = null,Object? batteryLevel = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,patientId: freezed == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String?,drugId: freezed == drugId ? _self.drugId : drugId // ignore: cast_nullable_to_non_nullable
as String?,drug: freezed == drug ? _self.drug : drug // ignore: cast_nullable_to_non_nullable
as Drug?,infusionRate: null == infusionRate ? _self.infusionRate : infusionRate // ignore: cast_nullable_to_non_nullable
as double,totalVolume: null == totalVolume ? _self.totalVolume : totalVolume // ignore: cast_nullable_to_non_nullable
as double,volumeInfused: null == volumeInfused ? _self.volumeInfused : volumeInfused // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime?,bolusEnabled: null == bolusEnabled ? _self.bolusEnabled : bolusEnabled // ignore: cast_nullable_to_non_nullable
as bool,kvoEnabled: null == kvoEnabled ? _self.kvoEnabled : kvoEnabled // ignore: cast_nullable_to_non_nullable
as bool,kvoRate: freezed == kvoRate ? _self.kvoRate : kvoRate // ignore: cast_nullable_to_non_nullable
as double?,patientWeight: null == patientWeight ? _self.patientWeight : patientWeight // ignore: cast_nullable_to_non_nullable
as double,targetDose: freezed == targetDose ? _self.targetDose : targetDose // ignore: cast_nullable_to_non_nullable
as double?,doseUnit: null == doseUnit ? _self.doseUnit : doseUnit // ignore: cast_nullable_to_non_nullable
as String,batteryLevel: freezed == batteryLevel ? _self.batteryLevel : batteryLevel // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of InfusionSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DrugCopyWith<$Res>? get drug {
    if (_self.drug == null) {
    return null;
  }

  return $DrugCopyWith<$Res>(_self.drug!, (value) {
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_id')  String id, @JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'Patient_id')  String? patientId, @JsonKey(name: 'drug_id')  String? drugId, @JsonKey(name: 'drug')  Drug? drug, @JsonKey(name: 'rate')  double infusionRate, @JsonKey(name: 'total_volume')  double totalVolume, @JsonKey(name: 'volume_infused')  double volumeInfused, @JsonKey(name: 'status')  String status, @JsonKey(name: 'start_time')  DateTime? startTime, @JsonKey(name: 'end_time')  DateTime? endTime, @JsonKey(name: 'bolus_enabled')  bool bolusEnabled, @JsonKey(name: 'kvo_enabled')  bool kvoEnabled, @JsonKey(name: 'kvo_rate')  double? kvoRate, @JsonKey(name: 'patient_weight')  double patientWeight, @JsonKey(name: 'target_dose')  double? targetDose, @JsonKey(name: 'dose_unit')  String doseUnit, @JsonKey(name: 'battery_level')  int? batteryLevel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InfusionSession() when $default != null:
return $default(_that.id,_that.userId,_that.patientId,_that.drugId,_that.drug,_that.infusionRate,_that.totalVolume,_that.volumeInfused,_that.status,_that.startTime,_that.endTime,_that.bolusEnabled,_that.kvoEnabled,_that.kvoRate,_that.patientWeight,_that.targetDose,_that.doseUnit,_that.batteryLevel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_id')  String id, @JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'Patient_id')  String? patientId, @JsonKey(name: 'drug_id')  String? drugId, @JsonKey(name: 'drug')  Drug? drug, @JsonKey(name: 'rate')  double infusionRate, @JsonKey(name: 'total_volume')  double totalVolume, @JsonKey(name: 'volume_infused')  double volumeInfused, @JsonKey(name: 'status')  String status, @JsonKey(name: 'start_time')  DateTime? startTime, @JsonKey(name: 'end_time')  DateTime? endTime, @JsonKey(name: 'bolus_enabled')  bool bolusEnabled, @JsonKey(name: 'kvo_enabled')  bool kvoEnabled, @JsonKey(name: 'kvo_rate')  double? kvoRate, @JsonKey(name: 'patient_weight')  double patientWeight, @JsonKey(name: 'target_dose')  double? targetDose, @JsonKey(name: 'dose_unit')  String doseUnit, @JsonKey(name: 'battery_level')  int? batteryLevel)  $default,) {final _that = this;
switch (_that) {
case _InfusionSession():
return $default(_that.id,_that.userId,_that.patientId,_that.drugId,_that.drug,_that.infusionRate,_that.totalVolume,_that.volumeInfused,_that.status,_that.startTime,_that.endTime,_that.bolusEnabled,_that.kvoEnabled,_that.kvoRate,_that.patientWeight,_that.targetDose,_that.doseUnit,_that.batteryLevel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'session_id')  String id, @JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'Patient_id')  String? patientId, @JsonKey(name: 'drug_id')  String? drugId, @JsonKey(name: 'drug')  Drug? drug, @JsonKey(name: 'rate')  double infusionRate, @JsonKey(name: 'total_volume')  double totalVolume, @JsonKey(name: 'volume_infused')  double volumeInfused, @JsonKey(name: 'status')  String status, @JsonKey(name: 'start_time')  DateTime? startTime, @JsonKey(name: 'end_time')  DateTime? endTime, @JsonKey(name: 'bolus_enabled')  bool bolusEnabled, @JsonKey(name: 'kvo_enabled')  bool kvoEnabled, @JsonKey(name: 'kvo_rate')  double? kvoRate, @JsonKey(name: 'patient_weight')  double patientWeight, @JsonKey(name: 'target_dose')  double? targetDose, @JsonKey(name: 'dose_unit')  String doseUnit, @JsonKey(name: 'battery_level')  int? batteryLevel)?  $default,) {final _that = this;
switch (_that) {
case _InfusionSession() when $default != null:
return $default(_that.id,_that.userId,_that.patientId,_that.drugId,_that.drug,_that.infusionRate,_that.totalVolume,_that.volumeInfused,_that.status,_that.startTime,_that.endTime,_that.bolusEnabled,_that.kvoEnabled,_that.kvoRate,_that.patientWeight,_that.targetDose,_that.doseUnit,_that.batteryLevel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InfusionSession extends InfusionSession {
  const _InfusionSession({@JsonKey(name: 'session_id') required this.id, @JsonKey(name: 'user_id') this.userId, @JsonKey(name: 'Patient_id') this.patientId, @JsonKey(name: 'drug_id') this.drugId, @JsonKey(name: 'drug') this.drug, @JsonKey(name: 'rate') required this.infusionRate, @JsonKey(name: 'total_volume') required this.totalVolume, @JsonKey(name: 'volume_infused') this.volumeInfused = 0.0, @JsonKey(name: 'status') this.status = 'Idle', @JsonKey(name: 'start_time') this.startTime, @JsonKey(name: 'end_time') this.endTime, @JsonKey(name: 'bolus_enabled') this.bolusEnabled = false, @JsonKey(name: 'kvo_enabled') this.kvoEnabled = false, @JsonKey(name: 'kvo_rate') this.kvoRate, @JsonKey(name: 'patient_weight') this.patientWeight = 70.0, @JsonKey(name: 'target_dose') this.targetDose, @JsonKey(name: 'dose_unit') this.doseUnit = 'mcg/kg/min', @JsonKey(name: 'battery_level') this.batteryLevel = 100}): super._();
  factory _InfusionSession.fromJson(Map<String, dynamic> json) => _$InfusionSessionFromJson(json);

@override@JsonKey(name: 'session_id') final  String id;
@override@JsonKey(name: 'user_id') final  String? userId;
@override@JsonKey(name: 'Patient_id') final  String? patientId;
@override@JsonKey(name: 'drug_id') final  String? drugId;
@override@JsonKey(name: 'drug') final  Drug? drug;
@override@JsonKey(name: 'rate') final  double infusionRate;
@override@JsonKey(name: 'total_volume') final  double totalVolume;
@override@JsonKey(name: 'volume_infused') final  double volumeInfused;
@override@JsonKey(name: 'status') final  String status;
@override@JsonKey(name: 'start_time') final  DateTime? startTime;
@override@JsonKey(name: 'end_time') final  DateTime? endTime;
@override@JsonKey(name: 'bolus_enabled') final  bool bolusEnabled;
@override@JsonKey(name: 'kvo_enabled') final  bool kvoEnabled;
@override@JsonKey(name: 'kvo_rate') final  double? kvoRate;
@override@JsonKey(name: 'patient_weight') final  double patientWeight;
@override@JsonKey(name: 'target_dose') final  double? targetDose;
@override@JsonKey(name: 'dose_unit') final  String doseUnit;
@override@JsonKey(name: 'battery_level') final  int? batteryLevel;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InfusionSession&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.drugId, drugId) || other.drugId == drugId)&&(identical(other.drug, drug) || other.drug == drug)&&(identical(other.infusionRate, infusionRate) || other.infusionRate == infusionRate)&&(identical(other.totalVolume, totalVolume) || other.totalVolume == totalVolume)&&(identical(other.volumeInfused, volumeInfused) || other.volumeInfused == volumeInfused)&&(identical(other.status, status) || other.status == status)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.bolusEnabled, bolusEnabled) || other.bolusEnabled == bolusEnabled)&&(identical(other.kvoEnabled, kvoEnabled) || other.kvoEnabled == kvoEnabled)&&(identical(other.kvoRate, kvoRate) || other.kvoRate == kvoRate)&&(identical(other.patientWeight, patientWeight) || other.patientWeight == patientWeight)&&(identical(other.targetDose, targetDose) || other.targetDose == targetDose)&&(identical(other.doseUnit, doseUnit) || other.doseUnit == doseUnit)&&(identical(other.batteryLevel, batteryLevel) || other.batteryLevel == batteryLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,patientId,drugId,drug,infusionRate,totalVolume,volumeInfused,status,startTime,endTime,bolusEnabled,kvoEnabled,kvoRate,patientWeight,targetDose,doseUnit,batteryLevel);

@override
String toString() {
  return 'InfusionSession(id: $id, userId: $userId, patientId: $patientId, drugId: $drugId, drug: $drug, infusionRate: $infusionRate, totalVolume: $totalVolume, volumeInfused: $volumeInfused, status: $status, startTime: $startTime, endTime: $endTime, bolusEnabled: $bolusEnabled, kvoEnabled: $kvoEnabled, kvoRate: $kvoRate, patientWeight: $patientWeight, targetDose: $targetDose, doseUnit: $doseUnit, batteryLevel: $batteryLevel)';
}


}

/// @nodoc
abstract mixin class _$InfusionSessionCopyWith<$Res> implements $InfusionSessionCopyWith<$Res> {
  factory _$InfusionSessionCopyWith(_InfusionSession value, $Res Function(_InfusionSession) _then) = __$InfusionSessionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'session_id') String id,@JsonKey(name: 'user_id') String? userId,@JsonKey(name: 'Patient_id') String? patientId,@JsonKey(name: 'drug_id') String? drugId,@JsonKey(name: 'drug') Drug? drug,@JsonKey(name: 'rate') double infusionRate,@JsonKey(name: 'total_volume') double totalVolume,@JsonKey(name: 'volume_infused') double volumeInfused,@JsonKey(name: 'status') String status,@JsonKey(name: 'start_time') DateTime? startTime,@JsonKey(name: 'end_time') DateTime? endTime,@JsonKey(name: 'bolus_enabled') bool bolusEnabled,@JsonKey(name: 'kvo_enabled') bool kvoEnabled,@JsonKey(name: 'kvo_rate') double? kvoRate,@JsonKey(name: 'patient_weight') double patientWeight,@JsonKey(name: 'target_dose') double? targetDose,@JsonKey(name: 'dose_unit') String doseUnit,@JsonKey(name: 'battery_level') int? batteryLevel
});


@override $DrugCopyWith<$Res>? get drug;

}
/// @nodoc
class __$InfusionSessionCopyWithImpl<$Res>
    implements _$InfusionSessionCopyWith<$Res> {
  __$InfusionSessionCopyWithImpl(this._self, this._then);

  final _InfusionSession _self;
  final $Res Function(_InfusionSession) _then;

/// Create a copy of InfusionSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = freezed,Object? patientId = freezed,Object? drugId = freezed,Object? drug = freezed,Object? infusionRate = null,Object? totalVolume = null,Object? volumeInfused = null,Object? status = null,Object? startTime = freezed,Object? endTime = freezed,Object? bolusEnabled = null,Object? kvoEnabled = null,Object? kvoRate = freezed,Object? patientWeight = null,Object? targetDose = freezed,Object? doseUnit = null,Object? batteryLevel = freezed,}) {
  return _then(_InfusionSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,patientId: freezed == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String?,drugId: freezed == drugId ? _self.drugId : drugId // ignore: cast_nullable_to_non_nullable
as String?,drug: freezed == drug ? _self.drug : drug // ignore: cast_nullable_to_non_nullable
as Drug?,infusionRate: null == infusionRate ? _self.infusionRate : infusionRate // ignore: cast_nullable_to_non_nullable
as double,totalVolume: null == totalVolume ? _self.totalVolume : totalVolume // ignore: cast_nullable_to_non_nullable
as double,volumeInfused: null == volumeInfused ? _self.volumeInfused : volumeInfused // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime?,bolusEnabled: null == bolusEnabled ? _self.bolusEnabled : bolusEnabled // ignore: cast_nullable_to_non_nullable
as bool,kvoEnabled: null == kvoEnabled ? _self.kvoEnabled : kvoEnabled // ignore: cast_nullable_to_non_nullable
as bool,kvoRate: freezed == kvoRate ? _self.kvoRate : kvoRate // ignore: cast_nullable_to_non_nullable
as double?,patientWeight: null == patientWeight ? _self.patientWeight : patientWeight // ignore: cast_nullable_to_non_nullable
as double,targetDose: freezed == targetDose ? _self.targetDose : targetDose // ignore: cast_nullable_to_non_nullable
as double?,doseUnit: null == doseUnit ? _self.doseUnit : doseUnit // ignore: cast_nullable_to_non_nullable
as String,batteryLevel: freezed == batteryLevel ? _self.batteryLevel : batteryLevel // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of InfusionSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DrugCopyWith<$Res>? get drug {
    if (_self.drug == null) {
    return null;
  }

  return $DrugCopyWith<$Res>(_self.drug!, (value) {
    return _then(_self.copyWith(drug: value));
  });
}
}

// dart format on
