import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'connection_provider.g.dart';

@riverpod
Future<bool> connectionStatus(Ref ref) async {
  try {
    // Attempt a simple query
    await Supabase.instance.client.from('users').select('user_id').limit(1);
    return true;
  } catch (e) {
    // Re-throw so the UI can catch it in .when(error: ...)
    throw e;
  }
}
