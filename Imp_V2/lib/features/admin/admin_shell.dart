import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminShell extends StatelessWidget {
  final Widget child;

  const AdminShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.settings_input_component, color: Color(0xFF6200EA)),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFEDE7F6),
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Text(
            'InfusionAdmin',
            style: TextStyle(color: Color(0xFF6200EA), fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.grey),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _getSelectedIndex(location),
        onDestinationSelected: (index) => _onItemTapped(index, context),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.analytics_outlined), selectedIcon: Icon(Icons.analytics), label: 'STATUS'),
          NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'USERS'),
          NavigationDestination(icon: Icon(Icons.list_alt_outlined), selectedIcon: Icon(Icons.list_alt), label: 'LOGS'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'SETUP'),
        ],
      ),
    );
  }

  int _getSelectedIndex(String location) {
    if (location.startsWith('/admin/users')) return 1;
    if (location.startsWith('/admin/logs')) return 2;
    if (location.startsWith('/admin/setup')) return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/admin');
        break;
      case 1:
        context.go('/admin/users');
        break;
      case 2:
        context.go('/admin/logs');
        break;
      case 3:
        context.go('/admin/setup');
        break;
    }
  }
}
