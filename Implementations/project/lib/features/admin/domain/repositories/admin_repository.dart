import '../models/managed_user.dart';
import '../../../doctor/domain/models/audit_log.dart';

abstract class AdminRepository {
  Future<List<ManagedUser>> fetchUsers();
  Future<void> createUser(ManagedUser user, String password);
  Future<void> updateUser(ManagedUser user);
  Future<void> deleteUser(String userId);
  Future<List<AuditLog>> fetchAuditLogs();
  Future<Map<String, dynamic>> fetchSystemStats();
}
