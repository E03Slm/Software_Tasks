import 'package:freezed_annotation/freezed_annotation.dart';
import 'alarm_definition.dart';

part 'alarm.freezed.dart';
part 'alarm.g.dart';

@freezed
abstract class Alarm with _$Alarm {
  const Alarm._();

  const factory Alarm({
    @JsonKey(name: 'event_id') required String id,
    @JsonKey(name: 'session_id') required String sessionId,
    @JsonKey(name: 'alarm_id') required String alarmId, // FK to alarms table
    @JsonKey(name: 'timestamp') required DateTime alarmTime,
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'ack/res') @Default(false) bool ackRes,
    @JsonKey(name: 'ack/res_by') String? ackResBy,
    @JsonKey(name: 'ack/res_at') DateTime? ackResAt,
    @JsonKey(name: 'definition') AlarmDefinition? definition,
  }) = _Alarm;

  factory Alarm.fromJson(Map<String, dynamic> json) => _$AlarmFromJson(json);
}
