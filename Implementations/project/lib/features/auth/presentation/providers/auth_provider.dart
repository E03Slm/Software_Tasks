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
    return null;
  }

  /// Attempts to log in the user with National ID and Password.
  /// Returns true if successful, false otherwise.
  Future<bool> login(String nationalId, String password) async {
    try {
      final user = await ref.read(authRepositoryProvider).signIn(
            nationalId: nationalId,
            password: password,
          );
      
      if (user != null) {
        state = user;
        return true;
      }
      return false;
    } catch (e) {
      print('AuthProvider Login Error: $e');
      return false;
    }
  }

  /// Resets the auth state.
  Future<void> logout() async {
    try {
      await ref.read(authRepositoryProvider).signOut();
    } finally {
      state = null;
    }
  }
}

@riverpod
RoleType? role(Ref ref) {
  final user = ref.watch(authProvider);
  return user?.role;
}
