import 'package:freezed_annotation/freezed_annotation.dart';

part 'alarm_definition.freezed.dart';
part 'alarm_definition.g.dart';

@freezed
abstract class AlarmDefinition with _$AlarmDefinition {
  const factory AlarmDefinition({
    @JsonKey(name: 'alarm_id') required String id,
    @JsonKey(name: 'alarm_name') required String type,
    required String severity,
    required String description,
  }) = _AlarmDefinition;

  factory AlarmDefinition.fromJson(Map<String, dynamic> json) => _$AlarmDefinitionFromJson(json);
}
