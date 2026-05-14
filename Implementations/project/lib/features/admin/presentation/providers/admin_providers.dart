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
class AdminUserList extends _$AdminUserList {
  @override
  Future<List<ManagedUser>> build() async {
    return ref.watch(adminRepositoryProvider).fetchUsers();
  }

  Future<void> addUser(ManagedUser user, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(adminRepositoryProvider).createUser(user, password);
      return ref.read(adminRepositoryProvider).fetchUsers();
    });
  }

  Future<void> updateUser(ManagedUser user) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(adminRepositoryProvider).updateUser(user);
      return ref.read(adminRepositoryProvider).fetchUsers();
    });
  }

  Future<void> deleteUser(String userId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(adminRepositoryProvider).deleteUser(userId);
      return ref.read(adminRepositoryProvider).fetchUsers();
    });
  }
}

@riverpod
Future<List<AuditLog>> adminAuditLogs(Ref ref) async {
  return ref.watch(adminRepositoryProvider).fetchAuditLogs();
}

@riverpod
Future<Map<String, dynamic>> systemStats(Ref ref) async {
  return ref.watch(adminRepositoryProvider).fetchSystemStats();
}

@riverpod
class UserSearchQuery extends _$UserSearchQuery {
  @override
  String build() => '';

  void setQuery(String query) {
    state = query;
  }
}
