import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/managed_user.dart';
import '../../domain/repositories/admin_repository.dart';
import '../../data/repositories/supabase_admin_repository.dart';
import '../../../doctor/data/repositories/audit_repository.dart';
import '../../../doctor/domain/models/audit_log.dart';

part 'admin_providers.g.dart';

@riverpod
AdminRepository adminRepository(Ref ref) {
  // Assuming AuditRepository is already provided somewhere. 
  // In this project it seems to be instantiated directly in some places or provided.
  return SupabaseAdminRepository(AuditRepository());
}

@riverpod
Stream<List<ManagedUser>> adminUserList(Ref ref) {
  return ref.watch(adminRepositoryProvider).streamUsers();
}

@riverpod
Future<List<AuditLog>> adminAuditLogs(Ref ref) async {
  return ref.watch(adminRepositoryProvider).fetchAuditLogs();
}

@riverpod
Future<Map<String, dynamic>> systemStats(Ref ref) async {
  return ref.watch(adminRepositoryProvider).fetchSystemStats();
}

final userNamesMapProvider = FutureProvider<Map<String, String>>((ref) async {
  final users = await ref.watch(adminRepositoryProvider).fetchUsers();
  return {for (final u in users) u.id: u.fullName};
});

@riverpod
class UserSearchQuery extends _$UserSearchQuery {
  @override
  String build() => '';

  void setQuery(String query) {
    state = query;
  }
}
