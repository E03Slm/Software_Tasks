import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'simulation/models/infusion_session.dart';
import 'simulation/models/infusion_state.dart';

part 'nurse_repository.g.dart';

@riverpod
class NurseRepository extends _$NurseRepository {
  late final SupabaseClient _client;

  @override
  void build() {
    _client = Supabase.instance.client;
  }

  Future<void> saveInfusionSession(InfusionSession session) async {
    await _client.from('infusion_session').upsert({
      'session_id': session.id,
      'user_id': session.nurseId,
      'drug_id': session.drug.id,
      'rate': session.infusionRate,
      'total_volume': session.totalVolume,
      'volume_infused': session.volumeInfused,
      'status': session.currentState.name,
      'start_time': session.startedAt?.toIso8601String(),
      'battery_level': session.batteryLevel.toInt(),
      'Patient_id': session.patientId,
      'kvo_enabled': session.kvoEnabled,
      'kvo_rate': session.kvoRate,
    });
  }

  Stream<List<Map<String, dynamic>>> watchAlarms(String sessionId) {
    return _client
        .from('alarm')
        .stream(primaryKey: ['event_id']) // Primary key per DESIGN.md
        .eq('session_id', sessionId)
        .order('alarm_time', ascending: false);
  }

  Future<void> acknowledgeAlarm(String eventId, String nurseId) async {
    await _client.from('alarm').update({
      'ack/res': true, // Column name per DESIGN.md
      'ack/res_by': nurseId,
      'ack/res_at': DateTime.now().toIso8601String(),
    }).eq('event_id', eventId);
  }

  Future<List<Map<String, dynamic>>> fetchAlarmDefinitions() async {
    // Queries 'alarms' table as per DESIGN.md
    final response = await _client.from('alarms').select();
    return response as List<Map<String, dynamic>>;
  }
}
