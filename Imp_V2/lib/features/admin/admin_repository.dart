import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../auth/models/role_type.dart';

part 'admin_repository.g.dart';

@riverpod
class AdminRepository extends _$AdminRepository {
  late final SupabaseClient _client;

  @override
  void build() {
    _client = Supabase.instance.client;
  }

  Stream<List<Map<String, dynamic>>> watchUsers() {
    return _client
        .from('users')
        .stream(primaryKey: ['user_id'])
        .order('Fname');
  }

  Future<void> saveUser({
    required String? userId,
    required String nationalId,
    required String role,
    required String firstName,
    required String middleName,
    required String lastName,
  }) async {
    final userData = {
      'national_id': nationalId,
      'role': role,
      'Fname': firstName,
      'Mname': middleName,
      'Lname': lastName,
      'Is_Deleted': false,
    };

    if (userId != null) {
      await _client.from('users').update(userData).eq('user_id', userId);
    } else {
      await _client.from('users').insert({
        ...userData,
        'created_at': DateTime.now().toIso8601String(),
        'password_hash': 'default_hashed_password', // In a real app, generate a temp password
      });
    }
  }
}

@riverpod
Stream<List<Map<String, dynamic>>> adminUsers(Ref ref) {
  return ref.watch(adminRepositoryProvider.notifier).watchUsers();
}
