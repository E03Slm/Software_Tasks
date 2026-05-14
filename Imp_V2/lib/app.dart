import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router.dart';
import 'core/theme.dart';
import 'features/auth/auth_repository.dart';
import 'features/auth/models/role_type.dart';

class SmartInfusionApp extends ConsumerWidget {
  const SmartInfusionApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final role = ref.watch(roleProvider);

    ColorScheme scheme;
    switch (role) {
      case RoleType.doctor:
        scheme = doctorColorScheme;
        break;
      case RoleType.admin:
        scheme = adminColorScheme;
        break;
      case RoleType.nurse:
      default:
        scheme = nurseColorScheme;
        break;
    }

    return MaterialApp.router(
      title: 'Smart Infusion Pump Simulator',
      theme: getThemeForRole(scheme),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
