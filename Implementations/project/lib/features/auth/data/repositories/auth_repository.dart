import 'dart:convert';
import 'package:crypto/crypto.dart';
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


      // Step 1: Hash the National ID with SHA-256 for deterministic querying
      final hashedNationalId = sha256.convert(utf8.encode(nationalId)).toString();

      // Step 2: Fetch the specific user directly (O(1) query)
      final response = await _client
          .from('users')
          .select()
          .eq('Is_Deleted', false)
          .eq('national_id', hashedNationalId)
          .maybeSingle();

      if (response == null) {
        print('Auth: No user found matching National ID');
        return null;
      }

      final matchedUserRecord = response as Map<String, dynamic>;

      // Step 3: Verify Password (still using BCrypt for security)
      final String? storedPasswordHash = matchedUserRecord['password_hash'];
      if (storedPasswordHash == null || !BCrypt.checkpw(password, storedPasswordHash)) {
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
