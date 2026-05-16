import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/audit_repository.dart';
import '../../domain/models/audit_log.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

part 'audit_provider.g.dart';

@riverpod
AuditRepository auditRepository(Ref ref) => AuditRepository();

@riverpod
class AuditLogList extends _$AuditLogList {
  @override
  Future<List<AuditLog>> build() async {
    final user = ref.watch(authProvider);
    return ref.watch(auditRepositoryProvider).fetchLogs(currentUserId: user?.id);
  }

  Future<void> refresh() async {
    final user = ref.read(authProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(auditRepositoryProvider).fetchLogs(currentUserId: user?.id),
    );
  }
}
