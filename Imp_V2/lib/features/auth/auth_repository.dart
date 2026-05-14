import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/foundation.dart';
import 'models/app_user.dart';
import 'models/role_type.dart';

part 'auth_repository.g.dart';

@riverpod
class AuthRepository extends _$AuthRepository {
  late final SupabaseClient _client;

  @override
  AppUser? build() {
    _client = Supabase.instance.client;
    return null;
  }

  Future<void> login(String nationalId, String password) async {
    try {
      // 1. Fetch all users to verify bcrybted national_id
      // WARNING: This is inefficient for large user bases but follows the specific request logic.
      final List<dynamic> users = await _client.from('users').select();

      Map<String, dynamic>? targetUser;

      // Parallelization or batching could be used if many users, but keeping it simple for simulator.
      for (final user in users) {
        final storedHashedId = user['national_id'] as String?;
        if (storedHashedId != null) {
          try {
            if (BCrypt.checkpw(nationalId, storedHashedId)) {
              targetUser = user;
              break;
            }
          } catch (e) {
            // Skip invalid hashes
            continue;
          }
        }
      }

      if (targetUser == null) {
        throw Exception('User with this National ID not found.');
      }

      // 2. Check password bcrypt
      final storedHashedPassword = targetUser['password_hash'] as String?;
      if (storedHashedPassword == null || !BCrypt.checkpw(password, storedHashedPassword)) {
        throw Exception('Invalid password.');
      }

      // 3. Map role
      final roleStr = targetUser['role'] as String;
      final role = RoleType.values.firstWhere(
        (e) => e.name == roleStr.toLowerCase(),
        orElse: () => RoleType.nurse,
      );

      // 4. Update state (Local session management)
      state = AppUser(
        id: targetUser['user_id'],
        nationalId: nationalId,
        role: role,
        isActive: true,
      );
      
      debugPrint('Authenticated user: ${state?.id} as ${state?.role}');
    } catch (e) {
      state = null;
      debugPrint('Login error: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    state = null;
  }
}

@riverpod
RoleType? role(Ref ref) {
  final user = ref.watch(authRepositoryProvider);
  return user?.role;
}
