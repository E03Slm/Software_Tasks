import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/audit_repository.dart';
import '../../domain/models/audit_log.dart';

part 'audit_provider.g.dart';

@riverpod
AuditRepository auditRepository(Ref ref) => AuditRepository();

@riverpod
class AuditLogList extends _$AuditLogList {
  @override
  Future<List<AuditLog>> build() async {
    return ref.watch(auditRepositoryProvider).fetchLogs();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(auditRepositoryProvider).fetchLogs(),
    );
  }
}
