import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://jxhitikmhurzybgksmup.supabase.co',
    anonKey: 'sb_publishable_mwGPrhzvT6mIXDAOBqi5xQ_BDp1K-ut',
  );

  runApp(
    const ProviderScope(
      child: SmartInfusionApp(),
    ),
  );
}
