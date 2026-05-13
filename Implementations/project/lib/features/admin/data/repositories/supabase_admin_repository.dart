import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/managed_user.dart';
import '../../domain/repositories/admin_repository.dart';
import '../../../doctor/domain/models/audit_log.dart';
import '../../../doctor/data/repositories/audit_repository.dart';

class SupabaseAdminRepository implements AdminRepository {
  final _client = Supabase.instance.client;
  final AuditRepository _auditRepo;

  SupabaseAdminRepository(this._auditRepo);

  @override
  Future<List<ManagedUser>> fetchUsers() async {
    final response = await _client
        .from('users')
        .select()
        .order('username', ascending: true);
    
    final list = response as List;
    return list
        .where((json) => json['user_id'] != null && json['username'] != null && json['role'] != null)
        .map((json) {
      // Map user_id to id for ManagedUser
      final data = Map<String, dynamic>.from(json);
      data['id'] = data['user_id'];
      // Handle is_active if it doesn't exist in DB (default to true)
      data['isActive'] = data['is_active'] ?? true;
      return ManagedUser.fromJson(data);
    }).toList();
  }

  @override
  Future<void> createUser(ManagedUser user, String password) async {
    final passwordHash = BCrypt.hashpw(password, BCrypt.gensalt());
    final userId = const Uuid().v4();
    
    final userData = {
      'user_id': userId,
      'username': user.username,
      'password_hash': passwordHash,
      'role': user.role.name.toUpperCase(),
      'created_at': DateTime.now().toIso8601String(),
    };

    await _client.from('users').insert(userData);

    await _auditRepo.logAction(
      actionType: 'CREATE_USER',
      entityType: 'USER',
      entityId: userId,
      newValue: {'username': user.username, 'role': user.role.name},
    );
  }

  @override
  Future<void> updateUser(ManagedUser user) async {
    // Fetch old data for audit
    final oldData = await _client
        .from('users')
        .select()
        .eq('user_id', user.id)
        .single();

    final updateData = {
      'username': user.username,
      'role': user.role.name.toUpperCase(),
    };

    await _client.from('users').update(updateData).eq('user_id', user.id);

    await _auditRepo.logAction(
      actionType: 'UPDATE_USER',
      entityType: 'USER',
      entityId: user.id,
      oldValue: oldData,
      newValue: updateData,
    );
  }

  @override
  Future<void> deleteUser(String userId) async {
    // 1. Fetch old data for audit before anything else
    final oldData = await _client
        .from('users')
        .select()
        .eq('user_id', userId)
        .single();

    // 2. Log the deletion action FIRST (while user still exists)
    await _auditRepo.logAction(
      actionType: 'DELETE_USER',
      entityType: 'USER',
      entityId: userId,
      oldValue: oldData,
    );

    // 3. Nullify user_id in audit_log to satisfy foreign key constraint
    // This preserves the logs but removes the hard link to the deleted user
    await _client
        .from('audit_log')
        .update({'user_id': null})
        .eq('user_id', userId);

    // 4. Finally delete the user
    await _client.from('users').delete().eq('user_id', userId);
  }

  @override
  Future<List<AuditLog>> fetchAuditLogs() async {
    final logs = await _auditRepo.fetchLogs();
    // AuditRepo already returns objects, but if we wanted to filter here:
    return logs; 
  }

  @override
  Future<Map<String, dynamic>> fetchSystemStats() async {
    // Fetch data and get counts
    final userList = await _client.from('users').select('user_id');
    final sessionList = await _client.from('infusion_session').select('session_id');
    final alarmList = await _client.from('alarm').select('alarm_id'); // Fixed column name

    return {
      'total_users': (userList as List).length,
      'active_sessions': (sessionList as List).length,
      'total_alarms': (alarmList as List).length,
      'system_status': 'Healthy',
    };
  }
}
