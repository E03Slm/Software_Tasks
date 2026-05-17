import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/drug.dart';
import './audit_repository.dart';

class DrugRepository {
  final _client = Supabase.instance.client;
  final AuditRepository _auditRepo;

  DrugRepository(this._auditRepo);

  Future<List<Drug>> fetchDrugs() async {
    final response = await _client
        .from('drug')
        .select()
        .eq('Is_Deleted', false)
        .order('name', ascending: true);
    
    final list = response as List;
    return list
        .where((json) => json['drug_id'] != null && json['name'] != null)
        .map((json) => Drug.fromJson(json))
        .toList();
  }

  Stream<List<Drug>> streamDrugs() {
    return _client
        .from('drug')
        .stream(primaryKey: ['drug_id'])
        .order('name', ascending: true)
        .map((data) => data
            .where((json) => json['drug_id'] != null && json['name'] != null && json['Is_Deleted'] == false)
            .map((json) => Drug.fromJson(json))
            .toList());
  }

  Future<void> addDrug(Drug drug, String userId) async {
    final now = DateTime.now();
    
    final json = drug.toJson();
    if (drug.id.isEmpty) {
      json.remove('drug_id');
    }
    
    // Inject audit fields from the provided active user ID
    json['created_by'] = userId;
    json['updated_by'] = userId;
    json['updated_at'] = now.toIso8601String();
    
    final result = await _client.from('drug').insert(json).select().single();
    
    await _auditRepo.logAction(
      actionType: 'CREATE_DRUG',
      entityType: 'DRUG',
      entityId: result['drug_id'],
      oldValue: {}, // Provide empty object to prevent null
      newValue: result,
      performerId: userId,
    );
  }

  Future<void> updateDrug(Drug drug, String userId) async {
    final now = DateTime.now();

    // Fetch old value for audit log
    final oldData = await _client
        .from('drug')
        .select()
        .eq('drug_id', drug.id)
        .single();

    final json = drug.toJson();
    // Prevent overwriting fixed metadata with null or original values
    json.remove('created_at');
    json.remove('created_by');
    json.remove('drug_id');

    // Inject update audit fields from the provided active user ID
    json['updated_by'] = userId;
    json['updated_at'] = now.toIso8601String();

    await _client
        .from('drug')
        .update(json)
        .eq('drug_id', drug.id);

    await _auditRepo.logAction(
      actionType: 'UPDATE_DRUG',
      entityType: 'DRUG',
      entityId: drug.id,
      oldValue: oldData,
      newValue: json,
      performerId: userId,
    );
  }

  Future<void> deleteDrug(String id, String userId) async {
    // Check for active infusion sessions using this drug
    final activeSessions = await _client
        .from('infusion_session')
        .select('session_id')
        .eq('drug_id', id)
        .neq('status', 'Stopped')
        .neq('status', 'Idle');

    if (activeSessions.isNotEmpty) {
      throw Exception('Drug is currently in use in an active infusion session.');
    }

    final oldData = await _client
        .from('drug')
        .select()
        .eq('drug_id', id)
        .single();

    await _client.from('drug').update({'Is_Deleted': true}).eq('drug_id', id);

    await _auditRepo.logAction(
      actionType: 'DELETE_DRUG',
      entityType: 'DRUG',
      entityId: id,
      oldValue: oldData,
      newValue: {'Is_Deleted': true},
      performerId: userId,
    );
  }
}
