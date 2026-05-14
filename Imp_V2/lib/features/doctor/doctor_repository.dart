import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../nurse/simulation/models/drug.dart';
import '../auth/auth_repository.dart';

part 'doctor_repository.g.dart';

@riverpod
class DoctorRepository extends _$DoctorRepository {
  late final SupabaseClient _client;

  @override
  void build() {
    _client = Supabase.instance.client;
  }

  Future<void> saveDrugProtocol({
    required Drug drug,
    Drug? oldDrug,
  }) async {
    final user = ref.read(authRepositoryProvider);
    if (user == null) throw Exception('User not authenticated');

    final drugData = {
      'name': drug.name,
      'concentration': drug.concentration,
      'concentration_unit': drug.concentrationUnit,
      'default_rate': drug.defaultRate,
      'rate_unit': drug.rateUnit,
      'soft_limit_high': drug.softLimitThreshold,
      'hard_limit_high': drug.hardLimitCeiling,
      'updated_by': user.id,
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (drug.id.isNotEmpty) {
      await _client.from('drug').update(drugData).eq('drug_id', drug.id);
      await saveAuditLog(
        action: 'UPDATE_DRUG',
        entityId: drug.id,
        entityType: 'drug',
        oldValue: oldDrug?.toJson().toString(),
        newValue: drug.toJson().toString(),
      );
    } else {
      final response = await _client.from('drug').insert({
        ...drugData,
        'created_by': user.id,
        'created_at': DateTime.now().toIso8601String(),
      }).select().single();
      
      await saveAuditLog(
        action: 'CREATE_DRUG',
        entityId: response['drug_id'],
        entityType: 'drug',
        newValue: drug.toJson().toString(),
      );
    }
  }

  Future<void> saveAuditLog({
    required String action,
    required String entityId,
    required String entityType,
    String? oldValue,
    String? newValue,
  }) async {
    final user = ref.read(authRepositoryProvider);
    await _client.from('audit_log').insert({
      'user_id': user?.id,
      'action': action,
      'entity_id': entityId,
      'entity_type': entityType,
      'old_value': oldValue,
      'new_value': newValue,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Stream<List<Map<String, dynamic>>> watchAuditLogs() {
    return _client
        .from('audit_log')
        .stream(primaryKey: ['log_id'])
        .order('timestamp', ascending: false);
  }

  Future<Map<String, int>> fetchDashboardStats() async {
    final drugs = await _client.from('drug').select('drug_id');
    final sessions = await _client.from('infusion_session').select('session_id');
    final alarms = await _client.from('alarm').select('event_id').eq('ack/res', false);

    return {
      'active_drugs': (drugs as List).length,
      'total_sessions': (sessions as List).length,
      'pending_alarms': (alarms as List).length,
    };
  }

  Future<void> generateReport({required String type}) async {
    final user = ref.read(authRepositoryProvider);
    await _client.from('report').insert({
      'type': type,
      'generated_by': user?.id,
      'generated_at': DateTime.now().toIso8601String(),
      'format': 'PDF',
      'parameters': {'scope': 'daily_summary'},
    });
  }

  Stream<List<Map<String, dynamic>>> watchReports() {
    return _client
        .from('report')
        .stream(primaryKey: ['report_id'])
        .order('generated_at', ascending: false);
  }
}

@riverpod
Stream<List<Map<String, dynamic>>> clinicalAuditLogs(Ref ref) {
  return ref.watch(doctorRepositoryProvider.notifier).watchAuditLogs();
}

@riverpod
Future<Map<String, int>> doctorDashboardStats(Ref ref) {
  return ref.watch(doctorRepositoryProvider.notifier).fetchDashboardStats();
}

@riverpod
Stream<List<Map<String, dynamic>>> clinicalReports(Ref ref) {
  return ref.watch(doctorRepositoryProvider.notifier).watchReports();
}
