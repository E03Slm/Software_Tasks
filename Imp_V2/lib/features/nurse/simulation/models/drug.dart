import 'package:freezed_annotation/freezed_annotation.dart';

part 'drug.freezed.dart';
part 'drug.g.dart';

@freezed
abstract class Drug with _$Drug {
  const factory Drug({
    @JsonKey(name: 'drug_id') required String id,
    required String name,
    required double concentration,
    @JsonKey(name: 'concentration_unit') required String concentrationUnit,
    @JsonKey(name: 'default_rate') required double defaultRate,
    @JsonKey(name: 'rate_unit') required String rateUnit,
    @JsonKey(name: 'hard_limit_high') required double hardLimitCeiling,
    @JsonKey(name: 'soft_limit_high') required double softLimitThreshold,
    @JsonKey(name: 'created_by') required String createdBy,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_by') String? updatedBy,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'Is_Deleted') required bool isArchived,
  }) = _Drug;

  factory Drug.fromJson(Map<String, dynamic> json) => _$DrugFromJson(json);

  factory Drug.empty() => Drug(
        id: '',
        name: '',
        concentration: 0,
        concentrationUnit: 'mg/mL',
        defaultRate: 0,
        rateUnit: 'mL/hr',
        hardLimitCeiling: 0,
        softLimitThreshold: 0,
        createdBy: '',
        createdAt: DateTime.now(),
        isArchived: false,
      );
}
