import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Import Placeholder Screens
import '../../features/auth/presentation/login_screen.dart';
import '../../features/nurse/presentation/nurse_shell.dart';
import '../../features/nurse/presentation/dashboard/pump_dashboard_screen.dart';
import '../../features/nurse/presentation/drug_selection/drug_selection_screen.dart';
import '../../features/nurse/presentation/parameter_entry/parameter_entry_screen.dart';
import '../../features/nurse/presentation/alarm_panel/alarm_panel_screen.dart';
import '../../features/nurse/presentation/session_log/session_log_screen.dart';

// Doctor Screens
import '../../features/doctor/presentation/doctor_shell.dart';
import '../../features/doctor/presentation/drug_library/drug_library_screen.dart';
import '../../features/doctor/presentation/drug_library/add_edit_drug_screen.dart';
import '../../features/doctor/presentation/logs/doctor_logs_screen.dart';
import '../../features/doctor/presentation/logs/doctor_system_logs_screen.dart';
import '../../features/doctor/presentation/reports/doctor_reports_screen.dart';

// Admin Screens
import '../../features/admin/presentation/admin_shell.dart';
import '../../features/admin/presentation/dashboard/admin_dashboard_screen.dart';
import '../../features/admin/presentation/user_management/user_list_screen.dart';
import '../../features/admin/presentation/user_management/user_editor_screen.dart';
import '../../features/admin/presentation/logs/admin_logs_screen.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/domain/enums/role_type.dart';
import '../../shared/widgets/access_denied_screen.dart';

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  RouterNotifier(this._ref) {
    _ref.listen(authProvider, (previous, next) {
      notifyListeners();
    });
  }
}

final routerNotifierProvider = Provider<RouterNotifier>((ref) => RouterNotifier(ref));

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: notifier,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isLoggingIn = state.uri.path == '/login';
      
      if (authState == null) {
        return isLoggingIn ? null : '/login';
      }

      if (isLoggingIn) {
        if (authState.role == RoleType.admin) return '/admin';
        if (authState.role == RoleType.doctor) return '/doctor';
        return '/nurse';
      }

      // Role-based access control
      final path = state.uri.path;
      if (path.startsWith('/admin') && authState.role != RoleType.admin) return '/access-denied';
      if (path.startsWith('/doctor') && authState.role != RoleType.doctor) return '/access-denied';
      if (path.startsWith('/nurse') && authState.role != RoleType.nurse) return '/access-denied';

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(key: ValueKey('login_screen')),
      ),
      
      // NURSE SHELL
      ShellRoute(
        builder: (context, state, child) => NurseShell(child: child),
        routes: [
          GoRoute(
            path: '/nurse',
            builder: (context, state) => const PumpDashboardScreen(),
          ),
          GoRoute(
            path: '/nurse/drug-selection',
            builder: (context, state) => const DrugSelectionScreen(),
          ),
          GoRoute(
            path: '/nurse/parameters',
            builder: (context, state) => const ParameterEntryScreen(),
          ),
          GoRoute(
            path: '/nurse/alarms',
            builder: (context, state) => const AlarmPanelScreen(),
          ),
          GoRoute(
            path: '/nurse/log',
            builder: (context, state) => const SessionLogScreen(),
          ),
        ],
      ),

      // DOCTOR SHELL
      ShellRoute(
        builder: (context, state, child) => DoctorShell(child: child),
        routes: [
          GoRoute(
            path: '/doctor',
            builder: (context, state) => const DrugLibraryScreen(),
          ),
          GoRoute(
            path: '/doctor/logs',
            builder: (context, state) => const DoctorLogsScreen(),
            routes: [
              GoRoute(
                path: 'system',
                builder: (context, state) => const DoctorSystemLogsScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/doctor/reports',
            builder: (context, state) => const DoctorReportsScreen(),
          ),
          GoRoute(
            path: '/doctor/add-drug',
            builder: (context, state) => const AddEditDrugScreen(),
          ),
          GoRoute(
            path: '/doctor/edit-drug/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return AddEditDrugScreen(drugId: id);
            },
          ),
        ],
      ),

      // ADMIN SHELL
      ShellRoute(
        builder: (context, state, child) => AdminShell(child: child),
        routes: [
          GoRoute(
            path: '/admin',
            builder: (context, state) => const AdminDashboardScreen(),
          ),
          GoRoute(
            path: '/admin/users',
            builder: (context, state) => const UserListScreen(),
          ),
          GoRoute(
            path: '/admin/users/add',
            builder: (context, state) => const UserEditorScreen(),
          ),
          GoRoute(
            path: '/admin/users/:id/edit',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return UserEditorScreen(userId: id);
            },
          ),
          GoRoute(
            path: '/admin/logs',
            builder: (context, state) => const AdminLogsScreen(),
          ),
        ],
      ),
      
      GoRoute(
        path: '/access-denied',
        builder: (context, state) => const AccessDeniedScreen(),
      ),
    ],
  );
});
