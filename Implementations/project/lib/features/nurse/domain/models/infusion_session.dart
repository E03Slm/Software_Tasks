import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../doctor/domain/models/drug.dart';

part 'infusion_session.freezed.dart';
part 'infusion_session.g.dart';

@freezed
abstract class InfusionSession with _$InfusionSession {
  const InfusionSession._();

  const factory InfusionSession({
    @JsonKey(name: 'session_id') required String id,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'drug_id') String? drugId,
    @JsonKey(name: 'drug') Drug? drug,
    @JsonKey(name: 'rate') required double infusionRate,
    @JsonKey(name: 'total_volume') required double totalVolume,
    @JsonKey(name: 'volume_infused') @Default(0.0) double volumeInfused,
    @JsonKey(name: 'status') @Default('Idle') String status,
    @JsonKey(name: 'start_time') DateTime? startTime,
    @JsonKey(name: 'end_time') DateTime? endTime,
    @JsonKey(name: 'bolus_enabled') @Default(false) bool bolusEnabled,
    @JsonKey(name: 'kvo_enabled') @Default(false) bool kvoEnabled,
    @JsonKey(name: 'kvo_rate') double? kvoRate,
    @JsonKey(name: 'patient_weight') @Default(70.0) double patientWeight,
    @JsonKey(name: 'target_dose') double? targetDose,
    @JsonKey(name: 'dose_unit') @Default('mcg/kg/min') String doseUnit,
    @JsonKey(name: 'battery_level') @Default(100) int? batteryLevel,
    @JsonKey(name: 'clinician') Map<String, dynamic>? clinicianData,
  }) = _InfusionSession;

  String? get clinicianName => clinicianData?['username'] as String?;

  factory InfusionSession.fromJson(Map<String, dynamic> json) => _$InfusionSessionFromJson(json);

  factory InfusionSession.initial() => InfusionSession(
        id: const Uuid().v4(),
        infusionRate: 0,
        totalVolume: 0,
        status: 'Idle',
      );

  double get volumeRemaining => (totalVolume - volumeInfused).clamp(0.0, totalVolume);

  Duration get timeRemaining {
    if (infusionRate <= 0) return Duration.zero;
    final hoursLeft = volumeRemaining / infusionRate;
    return Duration(seconds: (hoursLeft * 3600).round());
  }

  double get progressFraction {
    if (totalVolume <= 0) return 0;
    return (volumeInfused / totalVolume).clamp(0.0, 1.0);
  }
}
