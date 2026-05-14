import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/auth_repository.dart';
import '../features/auth/models/role_type.dart';
import '../features/nurse/nurse_shell.dart';
import '../features/nurse/screens/dashboard_screen.dart';
import '../features/nurse/screens/drug_selection_screen.dart';
import '../features/nurse/screens/parameter_entry_screen.dart';
import '../features/nurse/screens/alarm_panel_screen.dart';
import '../features/nurse/screens/session_log_screen.dart';
import '../features/doctor/doctor_shell.dart';
import '../features/doctor/screens/dashboard_screen.dart';
import '../features/doctor/screens/drug_library_screen.dart';
import '../features/doctor/screens/drug_editor_screen.dart';
import '../features/doctor/screens/reports_logs_screens.dart';
import '../features/admin/admin_shell.dart';
import '../features/admin/screens/dashboard_screen.dart';
import '../features/admin/screens/user_list_screen.dart';
import '../features/admin/screens/user_editor_screen.dart';
import '../features/admin/screens/admin_logs_screen.dart';
import '../features/auth/screens/login_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authRepositoryProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final user = ref.read(authRepositoryProvider);
      final loggingIn = state.uri.path == '/login';

      if (user == null) {
        return loggingIn ? null : '/login';
      }

      if (loggingIn) {
        switch (user.role) {
          case RoleType.doctor:
            return '/doctor';
          case RoleType.nurse:
            return '/nurse';
          case RoleType.admin:
            return '/admin';
        }
      }

      final role = user.role;
      final path = state.uri.path;

      if (path.startsWith('/doctor') && role != RoleType.doctor) return '/access-denied';
      if (path.startsWith('/nurse') && role != RoleType.nurse) return '/access-denied';
      if (path.startsWith('/admin') && role != RoleType.admin) return '/access-denied';

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/access-denied',
        builder: (context, state) => const Scaffold(body: Center(child: Text('Access Denied'))),
      ),

      // DOCTOR SHELL
      ShellRoute(
        builder: (context, state, child) => DoctorShell(child: child),
        routes: [
          GoRoute(path: '/doctor', builder: (context, state) => const DoctorDashboardScreen()),
          GoRoute(path: '/doctor/drugs', builder: (context, state) => const DrugLibraryScreen()),
          GoRoute(path: '/doctor/drugs/add', builder: (context, state) => const DrugEditorScreen()),
          GoRoute(path: '/doctor/drugs/:id/edit', builder: (context, state) => DrugEditorScreen(drugId: state.pathParameters['id'])),
          GoRoute(path: '/doctor/logs', builder: (context, state) => const LogsViewerScreen()),
          GoRoute(path: '/doctor/reports', builder: (context, state) => const ReportsScreen()),
        ],
      ),

      // NURSE SHELL
      ShellRoute(
        builder: (context, state, child) => NurseShell(child: child),
        routes: [
          GoRoute(path: '/nurse', builder: (context, state) => const PumpDashboardScreen()),
          GoRoute(path: '/nurse/drug-selection', builder: (context, state) => const DrugSelectionScreen()),
          GoRoute(path: '/nurse/parameters', builder: (context, state) => const ParameterEntryScreen()),
          GoRoute(path: '/nurse/alarms', builder: (context, state) => const AlarmPanelScreen()),
          GoRoute(path: '/nurse/log', builder: (context, state) => const SessionLogScreen()),
        ],
      ),

      // ADMIN SHELL
      ShellRoute(
        builder: (context, state, child) => AdminShell(child: child),
        routes: [
          GoRoute(path: '/admin', builder: (context, state) => const AdminDashboardScreen()),
          GoRoute(path: '/admin/users', builder: (context, state) => const UserListScreen()),
          GoRoute(path: '/admin/users/add', builder: (context, state) => const UserEditorScreen()),
          GoRoute(path: '/admin/users/:id/edit', builder: (context, state) => UserEditorScreen(userId: state.pathParameters['id'])),
          GoRoute(path: '/admin/logs', builder: (context, state) => const AdminLogsScreen()),
          GoRoute(path: '/admin/setup', builder: (context, state) => const Center(child: Text('System Setup'))),
        ],
      ),
    ],
  );
});
