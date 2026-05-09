import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bcrypt/bcrypt.dart';
import '../../domain/models/app_user.dart';
import '../../../doctor/data/repositories/audit_repository.dart';

class AuthRepository {
  final _client = Supabase.instance.client;
  final AuditRepository _auditRepo;

  AuthRepository(this._auditRepo);

  /// Verifies user login by checking the bcrypt hash stored in the 'users' table.
  /// This follows the logic provided in the Python snippet.
  Future<AppUser?> signIn({
    required String username,
    required String password,
  }) async {
    try {
      // 1. Fetch user data by username
      final response = await _client
          .from('users')
          .select()
          .eq('username', username)
          .maybeSingle();

      if (response == null) return null; // User not found

      final String storedHash = response['password_hash'];

      // 2. Verify password using bcrypt
      final bool isPasswordCorrect = BCrypt.checkpw(password, storedHash);

      if (isPasswordCorrect) {
        // 3. Update last login timestamp
        await _client.from('users').update({
          'last_login': DateTime.now().toIso8601String(),
        }).eq('user_id', response['user_id']);

        final user = AppUser.fromJson(response);

        // 4. Log Action
        await _auditRepo.logAction(
          actionType: 'LOGIN',
          entityType: 'USER',
          entityId: user.id,
          performerId: user.id, // Explicitly pass the ID of the user who just logged in
          oldValue: {}, // Provide empty object to prevent null
          newValue: {'status': 'success', 'username': user.username}, // Provide explicit status to prevent null
        );

        return user;
      }

      return null; // Mismatch
    } catch (e) {
      print('Auth Error: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    final userId = _client.auth.currentUser?.id;
    if (userId != null) {
      await _auditRepo.logAction(
        actionType: 'LOGOUT',
        entityType: 'USER',
        entityId: userId,
        performerId: userId,
        oldValue: {'status': 'logged_in'},
        newValue: {'status': 'logged_out'},
      );
    }
    // Provider state will be cleared by the notifier.
  }
}
