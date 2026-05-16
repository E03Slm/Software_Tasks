import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/managed_user.dart';
import '../../domain/repositories/admin_repository.dart';
import '../../../doctor/data/repositories/audit_repository.dart';
import '../../../doctor/domain/models/audit_log.dart';

class SupabaseAdminRepository implements AdminRepository {
  final _client = Supabase.instance.client;
  final AuditRepository _auditRepo;

  SupabaseAdminRepository(this._auditRepo);

  @override
  Future<List<ManagedUser>> fetchUsers() async {
    final response = await _client
        .from('users')
        .select()
        .eq('Is_Deleted', false);
    
    final List list = response as List;
    return list
        .where((json) => json['user_id'] != null)
        .map((json) {
      final data = Map<String, dynamic>.from(json);
      // Map database user_id to model id
      data['id'] = data['user_id'];
      return ManagedUser.fromJson(data);
    }).toList();
  }

  @override
  Stream<List<ManagedUser>> streamUsers() {
    return _client
        .from('users')
        .stream(primaryKey: ['user_id'])
        .eq('Is_Deleted', false)
        .map((data) => data.map((json) {
              final d = Map<String, dynamic>.from(json);
              d['id'] = d['user_id'];
              return ManagedUser.fromJson(d);
            }).toList());
  }

  @override
  Future<void> createUser(ManagedUser user, String password, String performerId) async {
    final String userId = const Uuid().v4();
    
    // Hash both National ID and Password using Bcrypt if they are intended to be secure
    // Note: DESIGN.md says 'national_id' is text, but AuthRepository expects a hash.
    final nationalIdHash = user.nationalId != null ? BCrypt.hashpw(user.nationalId!, BCrypt.gensalt()) : null;
    final passwordHash = BCrypt.hashpw(password, BCrypt.gensalt());
    
    final userData = {
      'user_id': userId,
      'national_id': nationalIdHash,
      'Fname': user.fname,
      'Mname': user.mname,
      'Lname': user.lname,
      'password_hash': passwordHash,
      'role': user.role.name.toUpperCase(),
      'created_at': DateTime.now().toIso8601String(),
      'last_login': DateTime.now().toIso8601String(),
      'Is_Deleted': false,
    };

    await _client.from('users').insert(userData);

    await _auditRepo.logAction(
      actionType: 'CREATE_USER',
      entityType: 'USER',
      entityId: userId,
      performerId: performerId,
      newValue: {
        'role': user.role.name,
        'Fname': user.fname,
        'Lname': user.lname,
      },
    );
  }

  @override
  Future<void> updateUser(ManagedUser user, String performerId) async {
    final updateData = {
      'role': user.role.name.toUpperCase(),
      'Fname': user.fname,
      'Mname': user.mname,
      'Lname': user.lname,
    };

    await _client
        .from('users')
        .update(updateData)
        .eq('user_id', user.id);

    await _auditRepo.logAction(
      actionType: 'UPDATE_USER',
      entityType: 'USER',
      entityId: user.id,
      performerId: performerId,
      newValue: updateData,
    );
  }

  @override
  Future<void> deleteUser(String userId, String performerId) async {
    // Perform soft deletion as per requirement
    await _client
        .from('users')
        .update({'Is_Deleted': true})
        .eq('user_id', userId);

    await _auditRepo.logAction(
      actionType: 'DELETE_USER',
      entityType: 'USER',
      entityId: userId,
      performerId: performerId,
      newValue: {'Is_Deleted': true},
    );
  }

  @override
  Future<List<AuditLog>> fetchAuditLogs() async {
    return _auditRepo.fetchLogs();
  }

  @override
  Future<Map<String, dynamic>> fetchSystemStats() async {
    final userCountResponse = await _client
        .from('users')
        .select('user_id')
        .eq('Is_Deleted', false);
    
    final activeSessionsResponse = await _client
        .from('infusion_session')
        .select('session_id')
        .eq('status', 'Infusing');

    final alarmsCountResponse = await _client
        .from('alarm')
        .select('alarm_id');

    return {
      'total_users': (userCountResponse as List).length,
      'active_sessions': (activeSessionsResponse as List).length,
      'total_alarms': (alarmsCountResponse as List).length,
      'last_updated': DateTime.now().toIso8601String(),
    };
  }
}
