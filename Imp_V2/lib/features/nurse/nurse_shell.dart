import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../nurse/simulation/infusion_state_machine.dart';
import '../../core/theme.dart';

class NurseShell extends ConsumerWidget {
  final Widget child;

  const NurseShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.path;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Infusion Monitor'),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF005EA4),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'Nurse',
              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          const CircleAvatar(
            radius: 16,
            child: Icon(Icons.person, size: 20),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: [
          // Vertical Emergency Stop Bar
          _VerticalEmergencyStop(),
          
          // Main Content
          Expanded(child: child),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _getSelectedIndex(location),
        onDestinationSelected: (index) => _onItemTapped(index, context),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined), 
            selectedIcon: Icon(Icons.dashboard), 
            label: 'Dashboard'
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined), 
            selectedIcon: Icon(Icons.notifications), 
            label: 'Alarms'
          ),
          NavigationDestination(
            icon: Icon(Icons.history), 
            label: 'Log'
          ),
        ],
      ),
    );
  }

  int _getSelectedIndex(String location) {
    if (location.startsWith('/nurse/alarms')) return 1;
    if (location.startsWith('/nurse/log')) return 2;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/nurse');
        break;
      case 1:
        context.go('/nurse/alarms');
        break;
      case 2:
        context.go('/nurse/log');
        break;
    }
  }
}

class _VerticalEmergencyStop extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onLongPress: () => ref.read(infusionProvider.notifier).emergencyStop(),
      child: Container(
        width: 60,
        decoration: const BoxDecoration(
          color: Color(0xFFE53935),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 0)),
          ],
        ),
        child: RotatedBox(
          quarterTurns: 3,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Text(
                  'HOLD TO EMERGENCY STOP',
                  style: labelCaps.copyWith(color: Colors.white, fontSize: 12, letterSpacing: 1.2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
