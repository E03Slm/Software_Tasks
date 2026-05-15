import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:project/features/admin/domain/models/managed_user.dart';
import 'package:project/features/admin/data/repositories/supabase_admin_repository.dart';
import 'package:project/features/doctor/data/repositories/audit_repository.dart';
import 'package:project/features/auth/domain/enums/role_type.dart';

part 'patients_provider.g.dart';

@riverpod
Future<List<ManagedUser>> patients(Ref ref) async {
  final repo = SupabaseAdminRepository(AuditRepository());
  final allUsers = await repo.fetchUsers();
  return allUsers.where((u) => u.role == RoleType.patient).toList();
}
