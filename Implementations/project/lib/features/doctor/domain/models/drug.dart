import 'package:freezed_annotation/freezed_annotation.dart';

part 'drug.freezed.dart';
part 'drug.g.dart';

@freezed
abstract class Drug with _$Drug {
  const Drug._();

  const factory Drug({
    @JsonKey(name: 'drug_id') required String id,
    required String name,
    required double concentration,
    @JsonKey(name: 'concentration_unit') required String concentrationUnit,
    @JsonKey(name: 'default_rate') required double defaultRate,
    @JsonKey(name: 'rate_unit') @Default('mL/hr') String rateUnit,
    @JsonKey(name: 'hard_limit_high') required double hardLimitHigh,
    @JsonKey(name: 'soft_limit_high') double? softLimitHigh,
    @JsonKey(name: 'Is_Deleted') @Default(false) bool isDeleted,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'created_by') String? createdBy,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'updated_by') String? updatedBy,
  }) = _Drug;

  factory Drug.fromJson(Map<String, dynamic> json) => _$DrugFromJson(json);

  factory Drug.empty() => Drug(
        id: '',
        name: '',
        concentration: 0,
        concentrationUnit: 'mg/mL',
        defaultRate: 0,
        hardLimitHigh: 0,
        createdAt: DateTime.now(),
      );
}
