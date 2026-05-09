import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/app_user.dart';
import '../../domain/enums/role_type.dart';
import '../../data/repositories/auth_repository.dart';
import '../../../doctor/presentation/providers/audit_provider.dart';

part 'auth_provider.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  final auditRepo = ref.watch(auditRepositoryProvider);
  return AuthRepository(auditRepo);
}

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AppUser? build() {
    // For now, return null to force login
    return null;
  }

  Future<bool> login(String username, String password) async {
    try {
      final user = await ref.read(authRepositoryProvider).signIn(
            username: username,
            password: password,
          );
      state = user;
      return user != null;
    } catch (e) {
      return false;
    }
  }

  void logout() async {
    await ref.read(authRepositoryProvider).signOut();
    state = null;
  }
}

@riverpod
RoleType? role(Ref ref) {
  final user = ref.watch(authProvider);
  return user?.role;
}
