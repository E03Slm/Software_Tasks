import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DoctorShell extends StatelessWidget {
  final Widget child;

  const DoctorShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clinical Governance'),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF00685D),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'Doctor',
              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _getSelectedIndex(location),
        onDestinationSelected: (index) => _onItemTapped(index, context),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.medication_outlined), selectedIcon: Icon(Icons.medication), label: 'Drug Library'),
          NavigationDestination(icon: Icon(Icons.list_alt_outlined), selectedIcon: Icon(Icons.list_alt), label: 'Logs'),
          NavigationDestination(icon: Icon(Icons.assessment_outlined), selectedIcon: Icon(Icons.assessment), label: 'Reports'),
        ],
      ),
    );
  }

  int _getSelectedIndex(String location) {
    if (location.startsWith('/doctor/drugs')) return 1;
    if (location.startsWith('/doctor/logs')) return 2;
    if (location.startsWith('/doctor/reports')) return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/doctor');
        break;
      case 1:
        context.go('/doctor/drugs');
        break;
      case 2:
        context.go('/doctor/logs');
        break;
      case 3:
        context.go('/doctor/reports');
        break;
    }
  }
}
