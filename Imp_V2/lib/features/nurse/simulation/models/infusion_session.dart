import 'package:freezed_annotation/freezed_annotation.dart';
import 'drug.dart';
import 'infusion_state.dart';

part 'infusion_session.freezed.dart';
part 'infusion_session.g.dart';

@freezed
abstract class InfusionSession with _$InfusionSession {
  const factory InfusionSession({
    required String id,
    required String nurseId,
    required Drug drug,
    required double concentration,
    required String? patientId,
    required double infusionRate,
    required double totalVolume,
    required double volumeInfused,
    required double volumeRemaining,
    required InfusionState currentState,
    required double batteryLevel,
    required bool? kvoEnabled,
    required double? kvoRate,
    double? bolusDose,
    DateTime? startedAt,
  }) = _InfusionSession;

  factory InfusionSession.fromJson(Map<String, dynamic> json) =>
      _$InfusionSessionFromJson(json);

  factory InfusionSession.initial() => InfusionSession(
        id: '',
        nurseId: '',
        drug: Drug.empty(),
        concentration: 0,
        patientId: null,
        infusionRate: 0,
        totalVolume: 0,
        volumeInfused: 0,
        volumeRemaining: 0,
        currentState: InfusionState.idle,
        batteryLevel: 100,
        kvoEnabled: false,
        kvoRate: 0,
      );
}
