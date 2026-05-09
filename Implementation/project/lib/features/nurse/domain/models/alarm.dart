import 'package:freezed_annotation/freezed_annotation.dart';

part 'alarm.freezed.dart';
part 'alarm.g.dart';

@freezed
abstract class Alarm with _$Alarm {
  const Alarm._();

  const factory Alarm({
    @JsonKey(name: 'event_id') required String id,
    @JsonKey(name: 'session_id') required String sessionId,
    @JsonKey(name: 'alarm_id') String? definitionId,
    required String type,
    required String severity,
    required DateTime timestamp,
    @Default(false) bool acknowledged,
    @JsonKey(name: 'acknowledged_by') String? acknowledgedBy,
    @JsonKey(name: 'acknowledged_at') DateTime? acknowledgedAt,
    @Default(false) bool resolved,
    @JsonKey(name: 'resolved_at') DateTime? resolvedAt,
    String? description,
  }) = _Alarm;

  factory Alarm.fromJson(Map<String, dynamic> json) => _$AlarmFromJson(json);
}
