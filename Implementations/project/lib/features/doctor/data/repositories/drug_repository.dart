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
        .order('name', ascending: true);
    
    return (response as List).map((json) => Drug.fromJson(json)).toList();
  }

  Stream<List<Drug>> streamDrugs() {
    return _client
        .from('drug')
        .stream(primaryKey: ['drug_id'])
        .order('name', ascending: true)
        .map((data) => data.map((json) => Drug.fromJson(json)).toList());
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
      sessionId: result['drug_id'], // Map session_id to drug_id as requested
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
      sessionId: drug.id, // Map session_id to drug_id as requested
      performerId: userId,
    );
  }

  Future<void> deleteDrug(String id) async {
    final oldData = await _client
        .from('drug')
        .select()
        .eq('drug_id', id)
        .single();

    await _client.from('drug').delete().eq('drug_id', id);

    await _auditRepo.logAction(
      actionType: 'DELETE_DRUG',
      entityType: 'DRUG',
      entityId: id,
      oldValue: oldData,
    );
  }
}
