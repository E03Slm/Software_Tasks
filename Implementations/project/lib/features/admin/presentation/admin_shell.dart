import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:project/core/theme/doctor_theme.dart'; // Admin uses same teal as doctor
import 'package:project/shared/widgets/role_badge.dart';
import 'package:project/features/auth/presentation/providers/auth_provider.dart';

class AdminShell extends ConsumerWidget {
  final Widget child;

  const AdminShell({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adminColors = Theme.of(context).extension<DoctorColors>() ?? 
                         doctorTheme.extension<DoctorColors>()!;
    final location = GoRouterState.of(context).uri.path;

    return Theme(
      data: doctorTheme,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_getTitle(location)),
          backgroundColor: adminColors.primary,
          foregroundColor: Colors.white,
          actions: [
            const RoleBadge(role: 'ADMIN'),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await ref.read(authProvider.notifier).logout();
              },
            ),
            const SizedBox(width: 16),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: adminColors.primary,
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.admin_panel_settings, color: Colors.teal),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'System Administrator',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Text(
                      'Technical Management',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const ListTile(
                title: Text('SYSTEM MANAGEMENT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
              ),
              ListTile(
                leading: const Icon(Icons.dashboard),
                title: const Text('Dashboard'),
                selected: location == '/admin',
                onTap: () {
                  context.go('/admin');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text('User Management'),
                selected: location.startsWith('/admin/users'),
                onTap: () {
                  context.go('/admin/users');
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              const ListTile(
                title: Text('SECURITY & AUDIT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
              ),
              ListTile(
                leading: const Icon(Icons.security),
                title: const Text('Audit Logs'),
                selected: location.startsWith('/admin/logs'),
                onTap: () {
                  context.go('/admin/logs');
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              const Spacer(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Logout', style: TextStyle(color: Colors.red)),
                onTap: () async {
                  await ref.read(authProvider.notifier).logout();
                },
              ),
            ],
          ),
        ),
        body: child,
      ),
    );
  }

  String _getTitle(String location) {
    if (location.startsWith('/admin/users')) return 'USER MANAGEMENT';
    if (location.startsWith('/admin/logs')) return 'SYSTEM AUDIT LOGS';
    return 'ADMIN DASHBOARD';
  }
}
