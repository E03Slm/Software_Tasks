import '../models/managed_user.dart';
import '../../../doctor/domain/models/audit_log.dart';

abstract class AdminRepository {
  Future<List<ManagedUser>> fetchUsers();
  Stream<List<ManagedUser>> streamUsers();
  Future<void> createUser(ManagedUser user, String password, String performerId);
  Future<void> updateUser(ManagedUser user, String performerId);
  Future<void> deleteUser(String userId, String performerId);
  Future<List<AuditLog>> fetchAuditLogs();
  Future<Map<String, dynamic>> fetchSystemStats();
}
