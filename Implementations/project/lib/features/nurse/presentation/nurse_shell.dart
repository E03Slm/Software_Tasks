import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:project/features/nurse/presentation/providers/infusion_provider.dart';
import 'package:project/core/theme/nurse_theme.dart';
import 'package:project/features/auth/presentation/providers/auth_provider.dart';

class NurseShell extends ConsumerWidget {
  final Widget child;

  const NurseShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get current index based on route
    final location = GoRouterState.of(context).uri.path;
    int currentIndex = 0;
    if (location.startsWith('/nurse/alarms')) {
      currentIndex = 1;
    } else if (location.startsWith('/nurse/log')) {
      currentIndex = 2;
    }

    final colorScheme = Theme.of(context).colorScheme;
    final nurseColors = Theme.of(context).extension<NurseColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('INFUSION PUMP', style: TextStyle(fontSize: 13, letterSpacing: 1.5)),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'Nurse',
                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: Row(
        children: [
          // Vertical Emergency Stop Sidebar
          _EmergencyStopButton(),
          // Main Content
          Expanded(child: child),
        ],
      ),
      bottomNavigationBar: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            _buildNavButton(
              context,
              index: 0,
              currentIndex: currentIndex,
              label: 'DASHBOARD',
              icon: Icons.dashboard_rounded,
              color: colorScheme.primary,
              onTap: () => context.go('/nurse'),
            ),
            const SizedBox(width: 12),
            _buildNavButton(
              context,
              index: 1,
              currentIndex: currentIndex,
              label: 'ALARMS',
              icon: Icons.warning_amber_rounded,
              color: nurseColors.severityWarning,
              onTap: () => context.go('/nurse/alarms'),
            ),
            const SizedBox(width: 12),
            _buildNavButton(
              context,
              index: 2,
              currentIndex: currentIndex,
              label: 'LOGS',
              icon: Icons.history_rounded,
              color: nurseColors.stopGrey,
              onTap: () => context.go('/nurse/log'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton(
    BuildContext context, {
    required int index,
    required int currentIndex,
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isSelected = currentIndex == index;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? color : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? color : Colors.grey.shade400,
                size: 28,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? color : Colors.grey.shade500,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmergencyStopButton extends ConsumerStatefulWidget {
  @override
  ConsumerState<_EmergencyStopButton> createState() => _EmergencyStopButtonState();
}

class _EmergencyStopButtonState extends ConsumerState<_EmergencyStopButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _triggerStop();
        }
      });
  }

  void _triggerStop() {
    ref.read(infusionProvider.notifier).emergencyStop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('EMERGENCY STOP ACTIVATED'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
    _controller.reset();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     final nurseColors = Theme.of(context).extension<NurseColors>()!;
     
     return GestureDetector(
       onTapDown: (_) => _controller.forward(),
       onTapUp: (_) => _controller.reset(),
       onTapCancel: () => _controller.reset(),
       child: Container(
         width: 80, // Vertical sidebar width
         decoration: BoxDecoration(
           color: nurseColors.emergencyRed,
           boxShadow: [
             BoxShadow(
               color: Colors.black.withValues(alpha: 0.2),
               blurRadius: 10,
               offset: const Offset(2, 0),
             ),
           ],
         ),
         child: Stack(
           alignment: Alignment.bottomCenter,
           children: [
             // Progress Overlay (Fills Bottom to Top)
             AnimatedBuilder(
               animation: _controller,
               builder: (context, child) {
                 return FractionallySizedBox(
                   heightFactor: _controller.value,
                   child: Container(
                     width: 80,
                     decoration: BoxDecoration(
                       color: Colors.white.withValues(alpha: 0.35),
                     ),
                   ),
                 );
               },
             ),
             // Content
             Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 const Icon(Icons.emergency, color: Colors.white, size: 36),
                 const SizedBox(height: 60),
                 RotatedBox(
                   quarterTurns: 3, // Rotate text to read bottom-to-top
                   child: Column(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       const Text(
                         'EMERGENCY STOP',
                         style: TextStyle(
                           color: Colors.white,
                           fontWeight: FontWeight.w900,
                           fontSize: 24,
                           letterSpacing: 2,
                         ),
                       ),
                       const SizedBox(height: 16),
                       Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Text(
                            'HOLD 2S TO ACTIVATE',
                            style: TextStyle(
                              color: Colors.white, 
                              fontSize: 10, 
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                       ),
                     ],
                   ),
                 ),
                 const SizedBox(height: 60),
                 const Icon(Icons.touch_app, color: Colors.white54, size: 24),
               ],
             ),
           ],
         ),
       ),
     );
  }
}
