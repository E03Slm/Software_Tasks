import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/app_user.dart';
import '../../domain/enums/role_type.dart';
import '../../data/repositories/auth_repository.dart';
import '../../../doctor/presentation/providers/audit_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_provider.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  final auditRepo = ref.watch(auditRepositoryProvider);
  return AuthRepository(auditRepo);
}

@riverpod
class AuthNotifier extends _$AuthNotifier {
  RealtimeChannel? _authSubscription;

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
        _setupRealtimeListener(user.id);
        return true;
      }
      return false;
    } catch (e) {
      print('AuthProvider Login Error: $e');
      return false;
    }
  }

  void _setupRealtimeListener(String userId) {
    _authSubscription?.unsubscribe();
    _authSubscription = Supabase.instance.client
        .channel('public:users:auth_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'users',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) {
            final isDeleted = payload.newRecord['Is_Deleted'] == true;
            if (isDeleted) {
              logout();
            }
          },
        )
        .subscribe();
  }

  /// Resets the auth state.
  Future<void> logout() async {
    try {
      await ref.read(authRepositoryProvider).signOut();
    } finally {
      state = null;
      _authSubscription?.unsubscribe();
      _authSubscription = null;
    }
  }
}

@riverpod
RoleType? role(Ref ref) {
  final user = ref.watch(authProvider);
  return user?.role;
}
