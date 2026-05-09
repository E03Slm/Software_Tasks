import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/doctor_theme.dart';
import '../../../shared/widgets/role_badge.dart';

class DoctorShell extends ConsumerWidget {
  final Widget child;

  const DoctorShell({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fallback to doctorTheme extension if not present in current context theme
    final doctorColors = Theme.of(context).extension<DoctorColors>() ?? 
                         doctorTheme.extension<DoctorColors>()!;
    final location = GoRouterState.of(context).uri.path;

    return Scaffold(
      appBar: AppBar(
        title: const Text('DRUG LIBRARY MGMT'),
        backgroundColor: doctorColors.primary,
        foregroundColor: Colors.white,
        actions: const [
          RoleBadge(role: 'DOCTOR'),
          SizedBox(width: 16),
        ],
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getSelectedIndex(location),
        selectedItemColor: doctorColors.primary,
        onTap: (index) => _onItemTapped(index, context),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Audit Logs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Reports',
          ),
        ],
      ),
    );
  }

  int _getSelectedIndex(String location) {
    if (location.startsWith('/doctor/logs')) return 1;
    if (location.startsWith('/doctor/reports')) return 2;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/doctor');
        break;
      case 1:
        context.go('/doctor/logs');
        break;
      case 2:
        context.go('/doctor/reports');
        break;
    }
  }
}
