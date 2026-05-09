import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/theme/nurse_theme.dart';
import 'core/theme/doctor_theme.dart';
import 'core/router/app_router.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/domain/enums/role_type.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://jxhitikmhurzybgksmup.supabase.co',
    anonKey: 'sb_publishable_mwGPrhzvT6mIXDAOBqi5xQ_BDp1K-ut',
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    const ProviderScope(
      child: SimulatorApp(),
    ),
  );
}

class SimulatorApp extends ConsumerWidget {
  const SimulatorApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRole = ref.watch(roleProvider);
    final router = ref.watch(routerProvider);
    
    return MaterialApp.router(
      title: 'Smart Infusion Pump Simulator',
      debugShowCheckedModeBanner: false,
      theme: userRole == RoleType.doctor ? doctorTheme : nurseTheme,
      routerConfig: router,
    );
  }
}
