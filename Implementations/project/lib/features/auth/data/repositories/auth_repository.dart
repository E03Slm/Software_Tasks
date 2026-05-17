import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
import '../../domain/models/app_user.dart';
import '../../../doctor/data/repositories/audit_repository.dart';

class AuthRepository {
  final _client = Supabase.instance.client;
  final AuditRepository _auditRepo;

  AuthRepository(this._auditRepo);

  /// Performs login by searching for a bcrypted National ID and verifying password.
  /// 
  /// Logic:
  /// 1. Fetches all records from 'users' table.
  /// 2. Iterates through records using an async-friendly loop (to prevent UI freeze).
  /// 3. For each record, uses BCrypt.checkpw to verify input National ID against 'national_id' column.
  /// 4. Once user is found, verifies input password against 'password_hash' column.
  /// 5. Returns AppUser if successful, null otherwise.
  Future<AppUser?> signIn({
    required String nationalId,
    required String password,
  }) async {
    try {


      // Step 1: Fetch all users
      final response = await _client.from('users').select().eq('Is_Deleted', false);
      final List<Map<String, dynamic>> records = (response as List).cast<Map<String, dynamic>>();

      // Step 2: Identify user by National ID hash in a separate isolate
      final matchedUserRecord = await compute(_findMatchingUser, {
        'records': records,
        'nationalId': nationalId,
      });

      if (matchedUserRecord == null) {
        print('Auth: No user found matching National ID');
        return null;
      }

      // Step 3: Verify Password in a separate isolate
      final String? storedPasswordHash = matchedUserRecord['password_hash'];
      if (storedPasswordHash == null) {
        print('Auth: No password hash stored');
        return null;
      }

      final isValid = await compute(_verifyPassword, {
        'password': password,
        'hash': storedPasswordHash,
      });

      if (!isValid) {
        print('Auth: Password mismatch');
        return null;
      }

      // Step 5: Post-login updates (Non-blocking)
      _finalizeLogin(matchedUserRecord);

      // Step 6: Return the user model
      return AppUser.fromJson(matchedUserRecord);
    } catch (e) {
      print('Auth Exception: $e');
      return null;
    }
  }

  /// Handles non-critical post-login tasks like auditing and timestamps.
  void _finalizeLogin(Map<String, dynamic> userRecord) {
    final userId = userRecord['user_id'];
    
    // Update last login timestamp
    _client.from('users').update({
      'last_login': DateTime.now().toIso8601String(),
    }).eq('user_id', userId).then((_) {
      print('Auth: Updated last_login for $userId');
    }).catchError((error) {
      print('Auth: Error updating last_login: $error');
    });

    // Log the successful login to audit trail
    _auditRepo.logAction(
      actionType: 'LOGIN',
      entityType: 'USER',
      entityId: userId,
      performerId: userId,
      newValue: {'status': 'success'},
    ).then((_) => null).catchError((_) => null);
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId != null) {
        await _auditRepo.logAction(
          actionType: 'LOGOUT',
          entityType: 'USER',
          entityId: userId,
          performerId: userId,
        );
      }
      await _client.auth.signOut();
    } catch (e) {
      print('SignOut Error: $e');
    }
  }
}

// Top-level functions (required by compute)

Map<String, dynamic>? _findMatchingUser(Map<String, dynamic> args) {
  final records = args['records'] as List<Map<String, dynamic>>;
  final nationalId = args['nationalId'] as String;

  for (var record in records) {
    final storedIdHash = record['national_id'] ?? record['user_id'];
    if (storedIdHash != null && storedIdHash.startsWith(r'$')) {
      if (BCrypt.checkpw(nationalId, storedIdHash)) {
        return record;
      }
    }
  }
  return null;
}

bool _verifyPassword(Map<String, dynamic> args) {
  return BCrypt.checkpw(args['password'], args['hash']);
}
