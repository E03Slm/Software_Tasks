# DESIGN.md — Smart Infusion Pump Software Simulator
**Version:** 1.0  
**Platform:** Flutter (iOS / Android)  
**Backend:** Supabase + PostgreSQL  
**State Management:** Riverpod  
**Routing:** GoRouter  

---

## 1. Project Overview

An educational mobile simulator replicating a real infusion pump. Three strictly separated roles: **Doctor** (clinical governance), **Nurse** (pump operator), **Admin** (technical management). No screen is shared between roles. Backend is Supabase (Auth + PostgreSQL + Realtime + Storage).

---

## 2. Tech Stack

| Layer | Technology |
|---|---|
| UI Framework | Flutter 3.x |
| State Management | Riverpod (flutter_riverpod + riverpod_annotation) |
| Routing | GoRouter 14.x |
| Backend | Supabase (Auth, Database, Realtime, Storage) |
| Database | PostgreSQL (via Supabase) |
| Local DB | Drift (SQLite) — offline simulation engine |
| PDF Export | pdf package + printing |
| Encryption | flutter_secure_storage + AES-256 (at rest) |
| Realtime | Supabase Realtime (pump state broadcast) |
| Code Gen | build_runner + riverpod_generator + freezed + json_serializable |

---

## 3. Folder Structure

```
lib/
├── main.dart
├── app.dart                        # MaterialApp + ProviderScope
│
├── core/
│   ├── router/
│   │   ├── app_router.dart         # GoRouter root — role-based routing
│   │   └── route_guards.dart       # Auth + RBAC guards
│   ├── theme/
│   │   ├── app_theme.dart          # ThemeData for all 3 role themes
│   │   ├── doctor_theme.dart       # Green-teal palette
│   │   ├── nurse_theme.dart        # Blue palette
│   │   └── admin_theme.dart        # Purple-grey palette
│   ├── constants/
│   │   └── app_constants.dart      # Timeouts, limits, magic numbers
│   ├── error/
│   │   ├── app_exception.dart      # Sealed class for all errors
│   │   └── failure.dart
│   └── utils/
│       ├── validators.dart
│       └── formatters.dart
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── auth_repository.dart
│   │   │   └── supabase_auth_datasource.dart
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   │   └── app_user.dart           # freezed
│   │   │   └── enums/
│   │   │       └── role_type.dart          # DOCTOR | NURSE | ADMIN
│   │   └── presentation/
│   │       ├── login_screen.dart
│   │       └── providers/
│   │           └── auth_provider.dart
│   │
│   ├── doctor/
│   │   ├── data/
│   │   │   ├── drug_repository.dart
│   │   │   ├── report_repository.dart
│   │   │   └── supabase_drug_datasource.dart
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   │   ├── drug.dart               # freezed
│   │   │   │   └── report.dart             # freezed
│   │   │   └── use_cases/
│   │   │       ├── add_drug_usecase.dart
│   │   │       ├── edit_drug_usecase.dart
│   │   │       ├── delete_drug_usecase.dart
│   │   │       └── generate_report_usecase.dart
│   │   └── presentation/
│   │       ├── doctor_shell.dart           # Bottom nav scaffold
│   │       ├── dashboard/
│   │       │   └── doctor_dashboard_screen.dart
│   │       ├── drug_library/
│   │       │   ├── drug_library_screen.dart
│   │       │   └── drug_editor_screen.dart
│   │       ├── logs/
│   │       │   └── logs_viewer_screen.dart
│   │       ├── reports/
│   │       │   └── reports_screen.dart
│   │       └── providers/
│   │           ├── drug_provider.dart
│   │           └── report_provider.dart
│   │
│   ├── nurse/
│   │   ├── data/
│   │   │   ├── infusion_repository.dart
│   │   │   └── alarm_repository.dart
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   │   ├── infusion_session.dart   # freezed
│   │   │   │   ├── alarm.dart              # freezed
│   │   │   │   └── infusion_parameters.dart # freezed
│   │   │   ├── enums/
│   │   │   │   ├── infusion_state.dart     # Idle|Programming|Running|Paused|...
│   │   │   │   ├── alarm_type.dart
│   │   │   │   └── severity_level.dart
│   │   │   └── use_cases/
│   │   │       ├── start_infusion_usecase.dart
│   │   │       ├── pause_infusion_usecase.dart
│   │   │       ├── stop_infusion_usecase.dart
│   │   │       ├── emergency_stop_usecase.dart
│   │   │       ├── validate_parameters_usecase.dart
│   │   │       └── acknowledge_alarm_usecase.dart
│   │   ├── simulation/
│   │   │   ├── infusion_state_machine.dart  # Core FSM logic
│   │   │   ├── battery_simulator.dart
│   │   │   ├── limit_validator.dart
│   │   │   └── kvo_handler.dart
│   │   └── presentation/
│   │       ├── nurse_shell.dart            # 3-tab bottom nav + Emergency FAB
│   │       ├── dashboard/
│   │       │   └── pump_dashboard_screen.dart
│   │       ├── drug_selection/
│   │       │   └── drug_selection_screen.dart
│   │       ├── parameter_entry/
│   │       │   └── parameter_entry_screen.dart
│   │       ├── alarm_panel/
│   │       │   └── alarm_panel_screen.dart
│   │       ├── session_log/
│   │       │   └── session_log_screen.dart
│   │       └── providers/
│   │           ├── infusion_provider.dart
│   │           ├── alarm_provider.dart
│   │           └── battery_provider.dart
│   │
│   └── admin/
│       ├── data/
│       │   ├── user_repository.dart
│       │   └── system_health_repository.dart
│       ├── domain/
│       │   ├── models/
│       │   │   └── managed_user.dart       # freezed
│       │   └── use_cases/
│       │       ├── create_user_usecase.dart
│       │       ├── deactivate_user_usecase.dart
│       │       └── delete_user_usecase.dart
│       └── presentation/
│           ├── admin_shell.dart            # Drawer navigation
│           ├── dashboard/
│           │   └── admin_dashboard_screen.dart
│           ├── user_management/
│           │   ├── user_list_screen.dart
│           │   └── user_editor_screen.dart
│           ├── logs/
│           │   └── admin_logs_screen.dart
│           └── providers/
│               ├── user_provider.dart
│               └── system_health_provider.dart
│
└── shared/
    ├── widgets/
    │   ├── role_badge.dart             # Coloured chip always visible in AppBar
    │   ├── confirmation_dialog.dart    # Destructive action dialogs
    │   ├── session_timeout_banner.dart # 60s countdown banner
    │   └── access_denied_screen.dart
    └── providers/
        └── session_provider.dart      # Session timeout logic
```

---

## 4. Database Schema (Supabase / PostgreSQL)

```sql
-- ENUMS
CREATE TYPE role_type AS ENUM ('DOCTOR', 'NURSE', 'ADMIN');
CREATE TYPE infusion_state AS ENUM (
  'IDLE', 'PROGRAMMING', 'RUNNING', 'PAUSED',
  'ALARM', 'KVO', 'COMPLETE', 'EMERGENCY_STOP',
  'BATTERY_LOW', 'CRITICAL_BATTERY'
);
CREATE TYPE alarm_severity AS ENUM ('INFO', 'WARNING', 'CRITICAL');
CREATE TYPE alarm_type AS ENUM (
  'OCCLUSION', 'AIR_IN_LINE', 'EMPTY_RESERVOIR',
  'BATTERY_LOW', 'BATTERY_CRITICAL', 'HARD_LIMIT_EXCEEDED',
  'SOFT_LIMIT_WARNING', 'MANUAL_TRAINING', 'EMERGENCY_STOP'
);

-- USERS (extends Supabase auth.users)
CREATE TABLE public.profiles (
  id              UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  username        TEXT UNIQUE NOT NULL,
  role            role_type NOT NULL,
  is_active       BOOLEAN DEFAULT TRUE,
  created_at      TIMESTAMPTZ DEFAULT NOW(),
  updated_at      TIMESTAMPTZ DEFAULT NOW()
);

-- DRUGS
CREATE TABLE public.drugs (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name                  TEXT NOT NULL,
  concentration         NUMERIC(10,4) NOT NULL CHECK (concentration > 0),
  concentration_unit    TEXT NOT NULL DEFAULT 'mg/mL',
  default_rate          NUMERIC(10,4) NOT NULL CHECK (default_rate > 0),
  hard_limit_ceiling    NUMERIC(10,4) NOT NULL CHECK (hard_limit_ceiling > 0),
  soft_limit_threshold  NUMERIC(10,4) NOT NULL CHECK (soft_limit_threshold > 0),
  is_archived           BOOLEAN DEFAULT FALSE,
  kvo_enabled           BOOLEAN DEFAULT FALSE,
  kvo_rate              NUMERIC(10,4),
  created_by            UUID REFERENCES public.profiles(id),
  created_at            TIMESTAMPTZ DEFAULT NOW(),
  updated_at            TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT soft_below_hard CHECK (soft_limit_threshold < hard_limit_ceiling)
);

-- INFUSION SESSIONS
CREATE TABLE public.infusion_sessions (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nurse_id          UUID NOT NULL REFERENCES public.profiles(id),
  drug_id           UUID NOT NULL REFERENCES public.drugs(id),
  concentration     NUMERIC(10,4) NOT NULL,
  infusion_rate     NUMERIC(10,4) NOT NULL,
  total_volume      NUMERIC(10,4) NOT NULL,
  bolus_dose        NUMERIC(10,4),
  volume_infused    NUMERIC(10,4) DEFAULT 0,
  volume_remaining  NUMERIC(10,4),
  current_state     infusion_state DEFAULT 'IDLE',
  battery_level     NUMERIC(5,2) DEFAULT 100,
  started_at        TIMESTAMPTZ,
  completed_at      TIMESTAMPTZ,
  created_at        TIMESTAMPTZ DEFAULT NOW()
);

-- ALARMS
CREATE TABLE public.alarms (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id      UUID NOT NULL REFERENCES public.infusion_sessions(id),
  alarm_type      alarm_type NOT NULL,
  severity        alarm_severity NOT NULL,
  is_acknowledged BOOLEAN DEFAULT FALSE,
  acknowledged_by UUID REFERENCES public.profiles(id),
  acknowledged_at TIMESTAMPTZ,
  triggered_at    TIMESTAMPTZ DEFAULT NOW()
);

-- AUDIT LOG (IMMUTABLE — no UPDATE/DELETE via RLS)
CREATE TABLE public.audit_logs (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  performing_user   UUID NOT NULL REFERENCES public.profiles(id),
  action_type       TEXT NOT NULL,
  entity_type       TEXT NOT NULL,   -- 'DRUG' | 'USER' | 'SESSION' | 'ALARM' | 'CONFIG'
  entity_id         UUID,
  old_value         JSONB,
  new_value         JSONB,
  traceability_id   UUID DEFAULT gen_random_uuid(),
  session_id        UUID REFERENCES public.infusion_sessions(id),
  created_at        TIMESTAMPTZ DEFAULT NOW()
);

-- Prevent modification of audit logs
CREATE RULE no_update_audit AS ON UPDATE TO public.audit_logs DO INSTEAD NOTHING;
CREATE RULE no_delete_audit AS ON DELETE TO public.audit_logs DO INSTEAD NOTHING;

-- SYSTEM CONFIG
CREATE TABLE public.system_config (
  key         TEXT PRIMARY KEY,
  value       TEXT NOT NULL,
  updated_by  UUID REFERENCES public.profiles(id),
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);
```

### Row Level Security (RLS)

```sql
-- Enable RLS on all tables
ALTER TABLE public.profiles        ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.drugs           ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.infusion_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.alarms          ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audit_logs      ENABLE ROW LEVEL SECURITY;

-- Helper function to get current user role
CREATE OR REPLACE FUNCTION get_my_role()
RETURNS role_type AS $$
  SELECT role FROM public.profiles WHERE id = auth.uid();
$$ LANGUAGE sql SECURITY DEFINER;

-- DRUGS: Doctor can CRUD, Nurse can SELECT (non-archived only), Admin no access
CREATE POLICY drugs_doctor ON public.drugs
  USING (get_my_role() = 'DOCTOR');

CREATE POLICY drugs_nurse_read ON public.drugs
  FOR SELECT USING (get_my_role() = 'NURSE' AND is_archived = FALSE);

-- INFUSION SESSIONS: Nurse owns their sessions, Doctor/Admin can read all
CREATE POLICY sessions_nurse ON public.infusion_sessions
  USING (get_my_role() = 'NURSE' AND nurse_id = auth.uid());

CREATE POLICY sessions_read_all ON public.infusion_sessions
  FOR SELECT USING (get_my_role() IN ('DOCTOR', 'ADMIN'));

-- AUDIT LOGS: Doctor + Admin read all, Nurse reads own sessions only, INSERT only
CREATE POLICY audit_insert ON public.audit_logs
  FOR INSERT WITH CHECK (performing_user = auth.uid());

CREATE POLICY audit_doctor_admin_read ON public.audit_logs
  FOR SELECT USING (get_my_role() IN ('DOCTOR', 'ADMIN'));

CREATE POLICY audit_nurse_read ON public.audit_logs
  FOR SELECT USING (
    get_my_role() = 'NURSE' AND
    session_id IN (
      SELECT id FROM public.infusion_sessions WHERE nurse_id = auth.uid()
    )
  );

-- PROFILES: Admin manages all, others read own
CREATE POLICY profiles_admin ON public.profiles
  USING (get_my_role() = 'ADMIN');

CREATE POLICY profiles_self_read ON public.profiles
  FOR SELECT USING (id = auth.uid());
```

---

## 5. State Management (Riverpod)

### Provider Hierarchy

```
authProvider                        # StreamProvider<AppUser?>
  └── roleProvider                  # Provider<RoleType?>
      ├── sessionProvider           # StateNotifierProvider<SessionNotifier>
      │
      ├── [Doctor]
      │   ├── drugListProvider      # AsyncNotifierProvider<List<Drug>>
      │   ├── drugEditorProvider    # StateNotifierProvider<DrugEditorState>
      │   └── reportProvider        # AsyncNotifierProvider<ReportState>
      │
      ├── [Nurse]
      │   ├── infusionProvider      # StateNotifierProvider<InfusionState>  ← FSM
      │   ├── alarmListProvider     # StreamProvider<List<Alarm>>           ← Realtime
      │   ├── batteryProvider       # StateNotifierProvider<BatteryState>
      │   └── selectedDrugProvider  # StateProvider<Drug?>
      │
      └── [Admin]
          ├── userListProvider      # AsyncNotifierProvider<List<ManagedUser>>
          └── systemHealthProvider  # StreamProvider<SystemHealth>
```

### Key Notifiers

```dart
// Infusion FSM — core of the Nurse feature
@riverpod
class InfusionNotifier extends _$InfusionNotifier {
  @override
  InfusionSession build() => InfusionSession.initial();

  Future<void> start() async { ... }    // validates → transitions to Running
  void pause()              { ... }    // Running → Paused
  Future<void> resume()     async { ... }    // Paused → Running
  void stop()               { ... }    // any → Idle (logs event)
  void emergencyStop()      { ... }    // any → EmergencyStop (critical alarm)
  void triggerAlarm(AlarmType type) { ... }  // Running → Alarm
  void resolveAlarm(String alarmId) { ... }  // Alarm → Running / Programming
  void _transitionTo(InfusionState next) { ... }  // guarded state transitions
}

// Battery simulation — ticks every second during Running state
@riverpod
class BatteryNotifier extends _$BatteryNotifier {
  Timer? _timer;
  @override
  double build() => 100.0;

  void startDrain() { _timer = Timer.periodic(1.second, (_) => _drain()); }
  void stopDrain()  { _timer?.cancel(); }
  void _drain() {
    state -= 0.1;
    if (state <= 20) ref.read(alarmListProvider.notifier).add(AlarmType.batteryLow);
    if (state <= 5)  ref.read(infusionProvider.notifier).emergencyStop();
  }
}
```

---

## 6. Routing (GoRouter)

```dart
// Route structure — strict role isolation
final appRouter = GoRouter(
  redirect: _rbacRedirect,    // checks auth + role on every navigation
  routes: [
    GoRoute(path: '/login',   builder: (_,__) => LoginScreen()),

    // DOCTOR SHELL
    ShellRoute(
      builder: (_, __, child) => DoctorShell(child: child),
      routes: [
        GoRoute(path: '/doctor',               builder: (_,__) => DoctorDashboardScreen()),
        GoRoute(path: '/doctor/drugs',         builder: (_,__) => DrugLibraryScreen()),
        GoRoute(path: '/doctor/drugs/add',     builder: (_,__) => DrugEditorScreen()),
        GoRoute(path: '/doctor/drugs/:id/edit',builder: (_,s)  => DrugEditorScreen(drugId: s.pathParameters['id'])),
        GoRoute(path: '/doctor/logs',          builder: (_,__) => LogsViewerScreen()),
        GoRoute(path: '/doctor/reports',       builder: (_,__) => ReportsScreen()),
      ],
    ),

    // NURSE SHELL
    ShellRoute(
      builder: (_, __, child) => NurseShell(child: child),
      routes: [
        GoRoute(path: '/nurse',                builder: (_,__) => PumpDashboardScreen()),
        GoRoute(path: '/nurse/drug-selection', builder: (_,__) => DrugSelectionScreen()),
        GoRoute(path: '/nurse/parameters',     builder: (_,__) => ParameterEntryScreen()),
        GoRoute(path: '/nurse/alarms',         builder: (_,__) => AlarmPanelScreen()),
        GoRoute(path: '/nurse/log',            builder: (_,__) => SessionLogScreen()),
      ],
    ),

    // ADMIN SHELL
    ShellRoute(
      builder: (_, __, child) => AdminShell(child: child),
      routes: [
        GoRoute(path: '/admin',                builder: (_,__) => AdminDashboardScreen()),
        GoRoute(path: '/admin/users',          builder: (_,__) => UserListScreen()),
        GoRoute(path: '/admin/users/add',      builder: (_,__) => UserEditorScreen()),
        GoRoute(path: '/admin/users/:id/edit', builder: (_,s)  => UserEditorScreen(userId: s.pathParameters['id'])),
        GoRoute(path: '/admin/logs',           builder: (_,__) => AdminLogsScreen()),
      ],
    ),

    // Access denied — shown when RBAC blocks navigation
    GoRoute(path: '/access-denied', builder: (_,__) => AccessDeniedScreen()),
  ],
);

// RBAC guard — runs on every route change
String? _rbacRedirect(BuildContext context, GoRouterState state) {
  final user = ref.read(authProvider);
  if (user == null) return '/login';

  final role = user.role;
  final path = state.uri.path;

  if (path.startsWith('/doctor') && role != RoleType.doctor) return '/access-denied';
  if (path.startsWith('/nurse')  && role != RoleType.nurse)  return '/access-denied';
  if (path.startsWith('/admin')  && role != RoleType.admin)  return '/access-denied';

  return null;
}
```

---

## 7. Data Models (Freezed)

```dart
// RoleType
enum RoleType { doctor, nurse, admin }

// AppUser
@freezed
class AppUser with _$AppUser {
  const factory AppUser({
    required String id,
    required String username,
    required RoleType role,
    required bool isActive,
  }) = _AppUser;
  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);
}

// Drug
@freezed
class Drug with _$Drug {
  const factory Drug({
    required String id,
    required String name,
    required double concentration,
    required String concentrationUnit,
    required double defaultRate,
    required double hardLimitCeiling,
    required double softLimitThreshold,
    required bool isArchived,
    required bool kvoEnabled,
    double? kvoRate,
    required DateTime createdAt,
  }) = _Drug;
  factory Drug.fromJson(Map<String, dynamic> json) => _$DrugFromJson(json);
}

// InfusionSession
@freezed
class InfusionSession with _$InfusionSession {
  const factory InfusionSession({
    required String id,
    required String nurseId,
    required Drug drug,
    required double concentration,
    required double infusionRate,
    required double totalVolume,
    required double volumeInfused,
    required double volumeRemaining,
    required InfusionState currentState,
    required double batteryLevel,
    double? bolusDose,
    DateTime? startedAt,
  }) = _InfusionSession;

  factory InfusionSession.initial() => InfusionSession(
    id: '', nurseId: '', drug: Drug.empty(),
    concentration: 0, infusionRate: 0, totalVolume: 0,
    volumeInfused: 0, volumeRemaining: 0,
    currentState: InfusionState.idle, batteryLevel: 100,
  );
}

// Alarm
@freezed
class Alarm with _$Alarm {
  const factory Alarm({
    required String id,
    required String sessionId,
    required AlarmType alarmType,
    required AlarmSeverity severity,
    required bool isAcknowledged,
    required DateTime triggeredAt,
    String? acknowledgedBy,
    DateTime? acknowledgedAt,
  }) = _Alarm;
}

// InfusionState enum (mirrors PostgreSQL enum)
enum InfusionState {
  idle, programming, running, paused,
  alarm, kvo, complete, emergencyStop,
  batteryLow, criticalBattery
}
```

---

## 8. Simulation Engine

The simulation engine runs **locally on-device** (no server needed). It uses a `Timer.periodic(1.second)` tick loop managed by the `InfusionNotifier`.

```dart
// Tick logic — called every second while state == Running or KVO
void _onSimulationTick() {
  final session = state;
  if (session.currentState != InfusionState.running &&
      session.currentState != InfusionState.kvo) return;

  final ratePerSecond = session.infusionRate / 3600; // mL/hr → mL/s
  final newVolumeInfused    = session.volumeInfused + ratePerSecond;
  final newVolumeRemaining  = session.totalVolume - newVolumeInfused;

  // Complete condition
  if (newVolumeRemaining <= 0) {
    if (session.drug.kvoEnabled) {
      _transitionTo(InfusionState.kvo);
    } else {
      _transitionTo(InfusionState.complete);
    }
    return;
  }

  // Update session values
  state = session.copyWith(
    volumeInfused: newVolumeInfused,
    volumeRemaining: newVolumeRemaining,
  );

  // Log to Supabase every 60s (not every tick — avoid noise)
  if (newVolumeInfused % 1.0 < ratePerSecond) {
    _logEvent('TICK_UPDATE', {'volume_infused': newVolumeInfused});
  }
}
```

### Limit Validator

```dart
class LimitValidator {
  ValidationResult validate(double rate, Drug drug) {
    if (rate > drug.hardLimitCeiling) {
      return ValidationResult.hardLimitViolation(
        'Rate ${rate} mL/hr exceeds hard limit of ${drug.hardLimitCeiling} mL/hr'
      );
    }
    if (rate > drug.softLimitThreshold) {
      return ValidationResult.softLimitWarning(
        'Rate ${rate} mL/hr exceeds soft limit of ${drug.softLimitThreshold} mL/hr'
      );
    }
    return ValidationResult.valid();
  }
}
```

---

## 9. Supabase Realtime

```dart
// Nurse subscribes to alarm updates for their active session
// in alarm_provider.dart

@riverpod
Stream<List<Alarm>> alarmList(AlarmListRef ref) {
  final session = ref.watch(infusionProvider);
  if (session.id.isEmpty) return Stream.value([]);

  return Supabase.instance.client
    .from('alarms')
    .stream(primaryKey: ['id'])
    .eq('session_id', session.id)
    .order('triggered_at', ascending: false)
    .map((rows) => rows.map(Alarm.fromJson).toList());
}
```

---

## 10. Theme System

> ⚠️ **Extracted directly from Stitch design files — use these exact values.**

### Typography (all roles use Inter)
```dart
// Single font family across all roles
const String kFontFamily = 'Inter';

// Text styles
const dataDisplay = TextStyle(fontSize: 32, height: 1.25, fontWeight: FontWeight.w700);
const titleStyle  = TextStyle(fontSize: 20, height: 1.4,  fontWeight: FontWeight.w600, letterSpacing: -0.2);
const bodyStyle   = TextStyle(fontSize: 16, height: 1.5,  fontWeight: FontWeight.w400);
const captionStyle= TextStyle(fontSize: 13, height: 1.38, fontWeight: FontWeight.w500, letterSpacing: 0.26);
const labelCaps   = TextStyle(fontSize: 11, height: 1.27, fontWeight: FontWeight.w700, letterSpacing: 0.55);
```

### Border Radius (Doctor / Admin)
```dart
const radiusDefault = Radius.circular(2);   // 0.125rem
const radiusLg      = Radius.circular(4);   // 0.25rem
const radiusXl      = Radius.circular(8);   // 0.5rem
const radiusFull    = Radius.circular(12);  // 0.75rem — chips, badges
```

### Border Radius (Nurse — more rounded, clinical focus)
```dart
const nurseRadiusDefault = Radius.circular(4);
const nurseRadiusLg      = Radius.circular(8);
const nurseRadiusXl      = Radius.circular(12);
const nurseRadiusFull    = Radius.circular(9999); // pill buttons
```

### Spacing Tokens
```dart
const spaceXs          = 4.0;
const spaceSm          = 8.0;
const spaceMd          = 16.0;   // card_padding
const spaceLg          = 24.0;
const spaceXl          = 32.0;
```

---

### Doctor Theme — Green-Teal `#00685d`
```dart
const doctorColorScheme = ColorScheme.light(
  primary:            Color(0xFF00685D),
  primaryContainer:   Color(0xFF008376),
  onPrimary:          Color(0xFFFFFFFF),
  onPrimaryContainer: Color(0xFFF4FFFB),
  secondary:          Color(0xFF41655F),
  secondaryContainer: Color(0xFFC3EBE2),
  surface:            Color(0xFFF6FAF8),
  surfaceVariant:     Color(0xFFDFE4E1),
  surfaceContainerHighest: Color(0xFFDFE4E1),
  surfaceContainerHigh:    Color(0xFFE4E9E7),
  surfaceContainer:        Color(0xFFEAEFEC),
  surfaceContainerLow:     Color(0xFFF0F5F2),
  onSurface:          Color(0xFF171D1B),
  onSurfaceVariant:   Color(0xFF3D4946),
  outline:            Color(0xFF6D7A77),
  outlineVariant:     Color(0xFFBCC9C5),
  error:              Color(0xFFBA1A1A),
  errorContainer:     Color(0xFFFFDAD6),
  onError:            Color(0xFFFFFFFF),
  onErrorContainer:   Color(0xFF93000A),
  inversePrimary:     Color(0xFF70D8C8),
  inverseSurface:     Color(0xFF2C3130),
);
// Doctor navigation: Sidebar drawer (web) / Bottom nav 4 tabs (mobile)
// Active nav item: bg teal-50, border-right 4px teal-600, text teal-700, icon FILL=1
// Inactive nav item: text slate-600, hover bg teal-50/50
```

### Nurse Theme — Blue `#005EA4`
```dart
const nurseColorScheme = ColorScheme.light(
  primary:            Color(0xFF005EA4),
  onPrimary:          Color(0xFFFFFFFF),
  secondary:          Color(0xFF4A6080),
  surface:            Color(0xFFF8F9FF),
  surfaceContainerHighest: Color(0xFFDEE3F0),
  onSurface:          Color(0xFF191C21),
  onSurfaceVariant:   Color(0xFF43474F),
  outline:            Color(0xFF73777F),
  outlineVariant:     Color(0xFFC3C7CF),
  error:              Color(0xFFBA1A1A),
  errorContainer:     Color(0xFFFFDAD6),
  onError:            Color(0xFFFFFFFF),
);

// Nurse-specific semantic colors (add to ThemeExtension)
const nurseEmergencyRed  = Color(0xFFE53935);  // Emergency Stop button ONLY
const nurseStopGrey      = Color(0xFF757575);  // Normal Stop button
const nurseStartGreen    = Color(0xFF2E7D32);  // Start button
const nursePauseAmber    = Color(0xFFF57F17);  // Pause button
const nurseWarningYellow = Color(0xFFFFA000);  // Soft limit warning banner
const nurseSeverityCritical = Color(0xFFE53935);
const nurseSeverityWarning  = Color(0xFFFFA000);
const nurseSeverityInfo     = Color(0xFF005EA4);

// Emergency Stop button: full-width, py-8, rounded-2xl, shadow-xl with red/20 shadow
// Must NEVER be covered by modals — rendered outside main scroll area
```

### Login Theme — Neutral `#2C2C2C`
```dart
const loginColorScheme = ColorScheme.light(
  primary:          Color(0xFF2C2C2C),
  primaryContainer: Color(0xFF424242),
  onPrimary:        Color(0xFFFFFFFF),
  surface:          Color(0xFFFDF8F8),
  surfaceContainerLowest: Color(0xFFFFFFFF),
  surfaceContainerLow:    Color(0xFFF7F3F2),
  onSurface:        Color(0xFF1C1B1B),
  onSurfaceVariant: Color(0xFF444748),
  outline:          Color(0xFF747878),
  outlineVariant:   Color(0xFFC4C7C7),
  error:            Color(0xFFBA1A1A),
  errorContainer:   Color(0xFFFFDAD6),
  onErrorContainer: Color(0xFF93000A),
);
// Login screen: centered card max-w-[420px], rounded-xl, shadow subtle
// Input height: 44px (min touch target)
// Login button: h-56px, rounded-xl, bg primaryContainer
// Biometric button: outlined, h-44px, rounded-xl, fingerprint icon
```

### Admin Theme — Same teal as Doctor `#00685D`
```dart
// Admin reuses Doctor's teal color scheme (confirmed from Stitch files)
// Admin navigation: Sidebar drawer with 2 sections
// Differentiator: layout is dashboard-focused with system health cards
const adminColorScheme = doctorColorScheme; // same palette
// Semantic additions for admin:
const adminSeverityWarning = Color(0xFFFFA000);
const adminTextSecondary   = Color(0xFF757575);
```

### Role Badge Colors (always visible in AppBar)
```dart
Color roleBadgeColor(RoleType role) => switch (role) {
  RoleType.doctor => const Color(0xFF00685D),
  RoleType.nurse  => const Color(0xFF005EA4),
  RoleType.admin  => const Color(0xFF00685D),
};

String roleBadgeLabel(RoleType role) => switch (role) {
  RoleType.doctor => 'Doctor',
  RoleType.nurse  => 'Nurse',
  RoleType.admin  => 'Admin',
};
// Badge style: bg-primary, text-white, text-[10px] font-bold, px-2 py-0.5, rounded-full
```

---

## 11. UI Component Specs (from Stitch)

### Navigation Patterns
```
Doctor/Admin → Sidebar Drawer (desktop web) / Bottom Nav 4 tabs (mobile)
Nurse        → Bottom Nav 3 tabs + Emergency Stop FAB above nav bar
Login        → Standalone centered card, no navigation
```

### Doctor — Drug Editor Layout (Bento Grid)
```
Row 1: [Drug Name — col-span-4] [Concentration — col-span-2]
Row 2: [Flow Control (Default Rate | Soft Limit | Hard Limit) — col-span-6]
Row 3: [Cancel (outlined)] [Save Drug Protocol (filled)] — right-aligned
```
- Section headers: icon + `UPPERCASE TRACKED` caption label in primary color
- Hard limit note: `text-error font-medium` — "Absolute maximum. Cannot be overridden."
- Soft limit note: italic muted — "Overrideable alert threshold."

### Nurse — Pump Controls Button States
```dart
Start   → bg nurseStartGreen (#2E7D32),   text-white, icon: play_arrow
Pause   → bg nursePauseAmber (#F57F17),   text-white, icon: pause
Resume  → bg nurseStartGreen,             text-white
Stop    → bg nurseStopGrey/10 (#757575),  text-grey, border (state-aware)
EmStop  → bg nurseEmergencyRed (#E53935), text-white, full-width, py-8,
          rounded-2xl, shadow-xl, requires 2s hold
```

### Nurse — Dashboard Real-time Display
```
┌─────────────────────────────┐
│  ACTIVE PARAMETERS (caps)   │
│  [Rate mL/hr]  [Vol Infused]│  ← 32pt bold data-display
│  [Vol Remain]  [Time Left]  │
│  Battery ██████░░ 72%       │
│  Progress bar               │
└─────────────────────────────┘
Refresh: 1Hz (Timer.periodic 1s)
```

### Alarm Severity Badges
```dart
Critical → bg-red-100,    text-red-700
Warning  → bg-amber-100,  text-amber-700   (#FFA000)
Info     → bg-blue-100,   text-blue-700
```

### AppBar Structure (all roles)
```
[Menu icon] [Screen Title — uppercase 13px tracked] ... [Notifications] [Logout]
```
- Role badge: bg-primary, text-white, 10px bold, rounded-full pill, in sidebar header
- TopAppBar: fixed, z-40, bg-white, border-b, h-16

### Login Screen Key Measurements
```
Container:  max-w-[420px], rounded-xl, shadow, p-xl(32pt)
Logo:       64x64px circle, bg-primary, rounded-full
Input:      h-44px, rounded-lg
Login btn:  h-56px, rounded-xl, bg-primaryContainer
Biometric:  h-44px, rounded-xl, outlined
Error:      bg-error-container, border #ffb4ab
```

---

## 12. Session Management

```dart
@riverpod
class SessionNotifier extends _$SessionNotifier {
  Timer? _timeoutTimer;
  Timer? _warningTimer;

  // Doctor/Nurse: 15 min, Admin: 10 min
  Duration get _timeout => switch (ref.read(roleProvider)) {
    RoleType.admin  => const Duration(minutes: 10),
    _               => const Duration(minutes: 15),
  };

  void resetTimer() {
    _timeoutTimer?.cancel();
    _warningTimer?.cancel();
    // Show 60s warning before timeout
    _warningTimer = Timer(_timeout - const Duration(seconds: 60), _showWarning);
    _timeoutTimer = Timer(_timeout, _forceLogout);
  }

  void _showWarning()  => state = state.copyWith(showTimeoutWarning: true);
  void _forceLogout()  => ref.read(authProvider.notifier).logout();
}
```

---

## 13. Audit Logging

All significant actions are logged. Pattern: call `AuditLogger.log(...)` at the end of every use case.

```dart
class AuditLogger {
  final SupabaseClient _client;

  Future<void> log({
    required String actionType,    // e.g. 'DRUG_EDITED', 'INFUSION_STARTED'
    required String entityType,    // e.g. 'DRUG', 'SESSION', 'USER'
    String? entityId,
    Map<String, dynamic>? oldValue,
    Map<String, dynamic>? newValue,
    String? sessionId,
  }) async {
    await _client.from('audit_logs').insert({
      'performing_user': _client.auth.currentUser!.id,
      'action_type':     actionType,
      'entity_type':     entityType,
      'entity_id':       entityId,
      'old_value':       oldValue,
      'new_value':       newValue,
      'session_id':      sessionId,
    });
  }
}
```

### Events to Log

| Trigger | action_type |
|---|---|
| Drug added | `DRUG_ADDED` |
| Drug edited | `DRUG_EDITED` |
| Drug archived/deleted | `DRUG_ARCHIVED` |
| Safety limit changed | `LIMIT_CHANGED` |
| Infusion started | `INFUSION_STARTED` |
| Infusion paused | `INFUSION_PAUSED` |
| Infusion stopped | `INFUSION_STOPPED` |
| Emergency stop | `EMERGENCY_STOP` |
| Alarm acknowledged | `ALARM_ACKNOWLEDGED` |
| User created | `USER_CREATED` |
| User deactivated | `USER_DEACTIVATED` |
| Config changed (Admin) | `CONFIG_CHANGED` |

---

## 14. PDF Export (Doctor only)

```dart
// Uses 'pdf' and 'printing' packages
class ReportGenerator {
  Future<Uint8List> generateInfusionSummary({
    required List<InfusionSession> sessions,
    required DateTimeRange range,
  }) async {
    final doc = pw.Document();
    doc.addPage(pw.MultiPage(
      build: (context) => [
        pw.Header(text: 'Infusion Summary Report'),
        pw.Text('Date range: ${range.start} – ${range.end}'),
        _buildSessionTable(sessions),
      ],
    ));
    return doc.save();  // returns Uint8List → upload to Supabase Storage or share
  }
}
```

---

## 15. Security Checklist

- [x] Supabase Auth handles password hashing (bcrypt/Argon2 internally)
- [x] RLS enforces role boundaries at DB level — Flutter UI is secondary enforcement
- [x] `flutter_secure_storage` for storing session token on device
- [x] TLS enforced by Supabase (all traffic HTTPS)
- [x] Audit logs: no UPDATE/DELETE via PostgreSQL rules
- [x] Last Admin deletion blocked: check in `DeleteUserUseCase` before calling Supabase
- [x] Session timeout: 10 min Admin, 15 min Nurse/Doctor
- [x] Biometric auth: `local_auth` package as secondary auth method

---

## 16. Key Dependencies (pubspec.yaml)

```yaml
dependencies:
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5
  go_router: ^14.2.0
  supabase_flutter: ^2.5.3
  freezed_annotation: ^2.4.1
  json_annotation: ^4.9.0
  drift: ^2.18.0              # local SQLite for offline simulation
  pdf: ^3.11.0
  printing: ^5.13.0
  flutter_secure_storage: ^9.2.2
  local_auth: ^2.3.0
  permission_handler: ^11.3.1

dev_dependencies:
  build_runner: ^2.4.12
  riverpod_generator: ^2.4.3
  freezed: ^2.5.2
  json_serializable: ^6.8.0
```

---

## 17. Prompt للـ AI (Antigravity أو غيره)

لما تدي الـ AI الـ DESIGN.md ده، استخدم الـ prompt ده:

```
You are a senior Flutter engineer. Use this DESIGN.md as the single source of truth.
Do NOT deviate from:
- State management: Riverpod only (riverpod_annotation + code generation)
- Routing: GoRouter with ShellRoute per role
- Backend: Supabase (no Firebase, no REST outside Supabase client)
- Models: Freezed + json_serializable
- Architecture: Feature-first folder structure as defined

Start by generating: [feature name, e.g. "nurse/simulation/infusion_state_machine.dart"]
Follow the exact file path from the folder structure.
Include all imports. Use riverpod_annotation @riverpod syntax.
```

---

## 18. Development Strategy — "Vibe" vs "Logic"

> مستوحى من مبدأ: افصل الـ UI عن الـ Business Logic تماماً في مراحل البناء.

### المبدأ
Google Stitch بتطلعلك UI شكله تحفة — بس الواجهة لوحدها مش أبلكيشن.
الـ AI زي Antigravity يكسّر التصميم لـ Widgets صغيرة الأول، وبعدين يربط الـ Business Logic.

### المراحل العملية

**Phase 1 — Vibe (UI Shell)**
اطلب من الـ AI ينشئ الـ Widget بدون أي logic — بس شكل وـ layout:

```
Prompt: "Build the NurseDashboardScreen widget.
UI ONLY — no providers, no state, no logic.
Use hardcoded placeholder values.
Follow Section 11 (UI Component Specs) and Section 10 (Theme) from DESIGN.md exactly."
```

الناتج: Widget جاهز، يتعرض على المحاكي، يشبه التصميم بالظبط.

**Phase 2 — Logic (Wire Up)**
بعد ما الـ UI اتأكد، اطلب الـ logic:

```
Prompt: "Now wire up NurseDashboardScreen to Riverpod.
- Replace hardcoded values with ref.watch(infusionProvider)
- Replace hardcoded alarms with ref.watch(alarmListProvider)
- Follow Section 5 (State Management) from DESIGN.md.
- Do NOT change any UI code — only add provider connections."
```

### ليه الفصل ده مهم؟

| بدون فصل | مع فصل |
|---|---|
| AI بيخلط UI + logic فبيجي spaghetti | كل ملف عنده مسؤولية واحدة |
| لو التصميم اتغيّر، بتكسر الـ logic | تغيّر الـ UI لوحده من غير ما تلمس الـ providers |
| صعب تعمل UI tests | ممكن تعمل Widget tests على الـ UI Shell بسهولة |
| الـ AI بيحتار ويخترع architecture | الـ DESIGN.md هو الـ source of truth دايماً |

### ترتيب البناء المقترح

```
1. Auth Shell         → Login screen (UI) → wire Supabase Auth
2. Role Router        → GoRouter guards (logic only, no UI)
3. Nurse UI Shell     → PumpDashboard + Controls (UI) → wire InfusionNotifier
4. Nurse Logic        → InfusionStateMachine + BatterySimulator
5. Doctor UI Shell    → DrugLibrary + DrugEditor (UI) → wire DrugNotifier
6. Doctor Logic       → LimitValidator + AuditLogger
7. Admin UI Shell     → UserManagement (UI) → wire UserNotifier
8. Integration        → Supabase Realtime alarms + RLS testing
9. PDF Export         → ReportGenerator (Doctor)
10. Polish            → Session timeout + offline Drift sync
```

### قاعدة ذهبية
> كل prompt للـ AI يبدأ بـ: **"Refer to DESIGN.md Section [X]"**
> ده بيمنع الـ AI من اختراع architecture جديدة في كل مرة.

---

## 19. Edge Cases — النقطة العمياء للـ AI

> الـ AI في Stitch بيرسملك الـ Happy Path دايماً. لازم تطلب منه الشاشات دي بنفسك قبل ما تنقل لخطوة البرمجة.

### Edge Case Screens المطلوبة لكل Role

**🔐 Auth (كل الـ Roles)**
| الحالة | الشاشة / السلوك |
|---|---|
| بيانات غلط | Error banner أحمر تحت الـ form |
| حساب deactivated | رسالة واضحة: "Account has been deactivated" |
| Session انتهى | 60s countdown banner → force logout |
| مفيش إنترنت عند login | "No connection — cannot authenticate" |
| Biometric فشل | Fallback لـ password بدون crash |

**👨‍⚕️ Doctor**
| الحالة | الشاشة / السلوك |
|---|---|
| Drug Library فاضية | Empty state: icon + "No drugs added yet" + Add button |
| حذف drug في session نشط | Blocking error modal: "Drug in active use" |
| Hard limit < Soft limit | Inline validation error على الـ form فوراً |
| Report — مفيش بيانات في الـ date range | Empty state داخل الـ report preview |
| PDF export فشل | Error snackbar + retry button |
| مفيش إنترنت عند generate report | "Offline — report unavailable" |

**👩‍⚕️ Nurse**
| الحالة | الشاشة / السلوك |
|---|---|
| Drug List فاضية | Empty state: "No drugs available — contact Doctor" |
| Hard limit exceeded | Start button disabled + blocking error modal |
| Soft limit exceeded | Yellow warning banner + "I understand — proceed" |
| Infusion خلصت (No KVO) | Auto-transition لـ Complete state + confirmation |
| Infusion خلصت (KVO enabled) | Auto-transition لـ KVO mode بدون input من الـ Nurse |
| Critical alarm أثناء infusion | Pump auto-pause + alarm panel يطلع فوراً |
| Battery 20% | Warning banner غير blocking |
| Battery 5% | Auto-stop + critical alarm + لا يكمل |
| Emergency Stop accidentally | 2s hold requirement — تأكيد بـ haptic feedback |
| مفيش إنترنت أثناء الـ session | Simulation تكمل offline — sync لما يرجع النت |

**🔧 Admin**
| الحالة | الشاشة / السلوك |
|---|---|
| حذف آخر Admin | Blocking error: "Cannot delete last admin account" |
| User List فاضية | Empty state + Add User button بارز |
| Deactivate نفسك | Warning: "You are deactivating your own account" |
| Config change يأثر على safety | Double confirmation + mandatory reason field |
| مفيش إنترنت | System health cards تعرض "Offline" badge |

---

### Prompt جاهز للـ AI عشان يعمل Edge Cases

بعد ما تخلص الـ Happy Path لأي screen، ابعت الـ prompt ده:

```
The current screen only handles the happy path.
Now add these edge case states to [ScreenName]:

1. Empty state — when the list/data is empty
2. Error state — when the API call fails
3. Offline state — when there is no internet connection
4. Loading state — skeleton loader, not a spinner

For each state:
- Add a named const to the Widget (emptyState, errorState, etc.)
- Follow the existing theme from DESIGN.md Section 10
- Do NOT change the happy path code
```

### قاعدة: الـ 4 States الأساسية لكل Screen

```
كل screen في الأبلكيشن لازم تتعامل مع:

1. Loading   → Skeleton loader (مش CircularProgressIndicator)
2. Empty     → Illustrated empty state + action button
3. Error     → Error message + retry button  
4. Success   → الـ happy path العادي
```

في Flutter مع Riverpod:
```dart
// Pattern موحد لكل AsyncNotifierProvider
ref.watch(myProvider).when(
  loading: () => const SkeletonLoader(),
  error:   (e, _) => ErrorStateWidget(onRetry: () => ref.invalidate(myProvider)),
  data:    (data) => data.isEmpty
      ? const EmptyStateWidget()
      : MyContentWidget(data: data),
);
```
