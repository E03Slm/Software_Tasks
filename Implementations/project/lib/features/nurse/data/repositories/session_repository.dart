import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/infusion_session.dart';
import '../../../doctor/data/repositories/audit_repository.dart';

class SessionRepository {
  final _client = Supabase.instance.client;
  final AuditRepository _auditRepo;

  SessionRepository(this._auditRepo);

  Future<void> saveSession(InfusionSession session) async {
    final drugId = session.drugId ?? session.drug?.id;
    final finalDrugId = (drugId != null && drugId.isNotEmpty) ? drugId : null;
    final finalUserId = (session.userId != null && session.userId!.isNotEmpty) ? session.userId : null;

    try {
      final data = {
        'session_id': session.id,
        'user_id': finalUserId,
        'drug_id': finalDrugId,
        'rate': session.infusionRate,
        'total_volume': session.totalVolume,
        'volume_infused': session.volumeInfused,
        'status': session.status,
        'start_time': (session.startTime ?? DateTime.now()).toIso8601String(),
        'end_time': (session.endTime ?? DateTime(2099, 12, 31)).toIso8601String(),
        'bolus_enabled': session.bolusEnabled,
        'kvo_enabled': session.kvoEnabled,
        'kvo_rate': session.kvoRate ?? 0.0,
        'battery_level': session.batteryLevel ?? 100,
        'Patient_id': session.patientId,
      };

      await _client.from('infusion_session').upsert(data);

      await _auditRepo.logAction(
        actionType: 'SAVE_SESSION',
        entityType: 'INFUSION_SESSION',
        entityId: session.id,
        performerId: finalUserId,
        newValue: data,
      );
    } catch (e) {
      print('DEBUG: SessionRepository.saveSession error: $e');
      rethrow;
    }
  }

  Future<void> updateStatus(String sessionId, String status, String userId) async {
    await _client.from('infusion_session')
        .update({'status': status})
        .eq('session_id', sessionId);

    await _auditRepo.logAction(
      actionType: 'UPDATE_SESSION_STATUS',
      entityType: 'INFUSION_SESSION',
      entityId: sessionId,
      performerId: userId,
      newValue: {'status': status},
    );
  }
}
