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
| PDF Export | pdf package + printing |
| Encryption | flutter_secure_storage + AES-256 (at rest) |
| Realtime | Supabase Realtime (pump state broadcast) |
| Code Gen | build_runner + riverpod_generator + freezed + json_serializable |

---

## 3. Folder Structure

lib/
├── main.dart
├── app.dart                    # MaterialApp + ProviderScope + GoRouter

├── core/
│   ├── router.dart             # GoRouter + auth/RBAC guards
│   ├── theme.dart              # ThemeData for all 3 roles
│   ├── constants.dart
│   └── utils.dart              # validators + formatters + errors/failures

├── features/
│   ├── auth/
│   │   ├── auth_repository.dart    # datasource مدمج + AppUser model + RoleType enum
│   │   └── auth_screen.dart        # LoginScreen + AuthProvider

│   ├── doctor/
│   │   ├── doctor_repository.dart  # Drug + Report repos + models + use cases
│   │   ├── doctor_providers.dart   # DrugProvider + ReportProvider
│   │   ├── doctor_shell.dart       # Bottom nav scaffold
│   │   └── doctor_screens.dart     # Dashboard + DrugLibrary + DrugEditor + Logs + Reports

│   ├── nurse/
│   │   ├── nurse_repository.dart   # Infusion + Alarm repos + models + enums
│   │   ├── simulation.dart         # FSM + BatterySimulator + LimitValidator + KvoHandler
│   │   ├── nurse_providers.dart    # InfusionProvider + AlarmProvider + BatteryProvider
│   │   ├── nurse_shell.dart        # 3-tab bottom nav + Emergency FAB
│   │   └── nurse_screens.dart      # Dashboard + DrugSelection + ParameterEntry + Alarm + SessionLog

│   └── admin/
│       ├── admin_repository.dart   # User + SystemHealth repos + ManagedUser model + use cases
│       ├── admin_providers.dart    # UserProvider + SystemHealthProvider
│       ├── admin_shell.dart        # Drawer navigation
│       └── admin_screens.dart      # Dashboard + UserList + UserEditor + Logs

└── shared/
    ├── shared_widgets.dart         # RoleBadge + ConfirmationDialog + TimeoutBanner + AccessDenied
    └── session_provider.dart
---

## 4. Database Schema (Supabase / PostgreSQL)



| table_name       | column_name        | data_type                   | is_nullable | key_type    |
| ---------------- | ------------------ | --------------------------- | ----------- | ----------- |
| alarm            | event_id           | uuid                        | NO          | PRIMARY KEY |
| alarm            | session_id         | uuid                        | NO          | FOREIGN KEY |
| alarm            | alarm_time         | timestamp without time zone | NO          | null        |
| alarm            | ack/res            | boolean                     | NO          | null        |
| alarm            | ack/res_by         | uuid                        | NO          | FOREIGN KEY |
| alarm            | ack/res_at         | timestamp without time zone | NO          | null        |
| alarm            | alarm_id           | uuid                        | NO          | FOREIGN KEY |
| alarms           | alarm_id           | uuid                        | NO          | PRIMARY KEY |
| alarms           | alarm_name         | text                        | NO          | UNIQUE      |
| alarms           | severity           | text                        | NO          | null        |
| alarms           | description        | text                        | NO          | null        |
| audit_log        | log_id             | uuid                        | NO          | PRIMARY KEY |
| audit_log        | user_id            | uuid                        | NO          | FOREIGN KEY |
| audit_log        | action             | text                        | NO          | null        |
| audit_log        | entity_type        | text                        | NO          | null        |
| audit_log        | entity_id          | uuid                        | NO          | FOREIGN KEY |
| audit_log        | entity_id          | uuid                        | NO          | FOREIGN KEY |
| audit_log        | entity_id          | uuid                        | NO          | FOREIGN KEY |
| audit_log        | entity_id          | uuid                        | NO          | FOREIGN KEY |
| audit_log        | old_value          | text                        | NO          | null        |
| audit_log        | new_value          | text                        | NO          | null        |
| audit_log        | timestamp          | timestamp without time zone | NO          | null        |
| drug             | drug_id            | uuid                        | NO          | PRIMARY KEY |
| drug             | name               | character varying           | NO          | UNIQUE      |
| drug             | concentration      | numeric                     | NO          | null        |
| drug             | concentration_unit | text                        | NO          | null        |
| drug             | default_rate       | numeric                     | NO          | null        |
| drug             | rate_unit          | character varying           | NO          | null        |
| drug             | hard_limit_high    | numeric                     | NO          | null        |
| drug             | soft_limit_high    | numeric                     | NO          | null        |
| drug             | created_by         | uuid                        | NO          | FOREIGN KEY |
| drug             | created_at         | timestamp without time zone | NO          | null        |
| drug             | updated_by         | uuid                        | NO          | FOREIGN KEY |
| drug             | updated_at         | timestamp without time zone | NO          | null        |
| drug             | Is_Deleted         | boolean                     | NO          | null        |
| infusion_session | session_id         | uuid                        | NO          | PRIMARY KEY |
| infusion_session | user_id            | uuid                        | NO          | FOREIGN KEY |
| infusion_session | drug_id            | uuid                        | NO          | FOREIGN KEY |
| infusion_session | rate               | numeric                     | NO          | null        |
| infusion_session | total_volume       | numeric                     | NO          | null        |
| infusion_session | volume_infused     | numeric                     | NO          | null        |
| infusion_session | status             | character varying           | NO          | null        |
| infusion_session | start_time         | timestamp without time zone | NO          | null        |
| infusion_session | end_time           | timestamp without time zone | NO          | null        |
| infusion_session | bolus_enabled      | boolean                     | NO          | null        |
| infusion_session | kvo_enabled        | boolean                     | YES         | null        |
| infusion_session | kvo_rate           | numeric                     | YES         | null        |
| infusion_session | battery_level      | integer                     | YES         | null        |
| infusion_session | Patient_id         | uuid                        | NO          | FOREIGN KEY |
| users            | national_id        | text                        | NO          | null        |
| users            | Fname              | text                        | NO          | UNIQUE      |
| users            | password_hash      | text                        | NO          | null        |
| users            | role               | text                        | NO          | null        |
| users            | created_at         | timestamp without time zone | NO          | null        |
| users            | last_login         | timestamp without time zone | NO          | null        |
| users            | Is_Deleted         | boolean                     | NO          | null        |
| users            | Mname              | text                        | NO          | null        |
| users            | Lname              | text                        | NO          | null        |
| users            | user_id            | uuid                        | NO          | PRIMARY KEY |
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
      │   └── selectedDrugProvider  # StateProvider<Drug?>
      │
      └── [Admin]
          ├── userListProvider      # AsyncNotifierProvider<List<ManagedUser>>
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
    required String nationalId,
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
    required bool isAcknowledgedortriggered,
    required DateTime AcknowledgedortriggeredAt,
    required String AcknowledgedortriggeredBy,
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


Typography (all roles use Inter):
const String kFontFamily = 'Inter';

const dataDisplay = TextStyle(fontSize: 32, height: 1.25, fontWeight: FontWeight.w700);
const titleStyle  = TextStyle(fontSize: 20, height: 1.4,  fontWeight: FontWeight.w600, letterSpacing: -0.2);
const bodyStyle   = TextStyle(fontSize: 16, height: 1.5,  fontWeight: FontWeight.w400);
const captionStyle= TextStyle(fontSize: 13, height: 1.38, fontWeight: FontWeight.w500, letterSpacing: 0.26);
const labelCaps   = TextStyle(fontSize: 11, height: 1.27, fontWeight: FontWeight.w700, letterSpacing: 0.55);

Border Radius (Doctor / Admin):
const radiusDefault = Radius.circular(2);
const radiusLg      = Radius.circular(4);
const radiusXl      = Radius.circular(8);
const radiusFull    = Radius.circular(12);  // chips, badges

Border Radius (Nurse — more rounded, clinical focus):
const nurseRadiusDefault = Radius.circular(4);
const nurseRadiusLg      = Radius.circular(8);
const nurseRadiusXl      = Radius.circular(12);
const nurseRadiusFull    = Radius.circular(9999); // pill buttons

Spacing Tokens:
const spaceXs = 4.0;
const spaceSm = 8.0;
const spaceMd = 16.0;  // card padding
const spaceLg = 24.0;
const spaceXl = 32.0;

Doctor Theme — Green-Teal #00685D:
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

Nurse Theme — Blue #005EA4:
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

// Nurse-specific semantic colors (ThemeExtension)
const nurseEmergencyRed  = Color(0xFFE53935);
const nurseStopGrey      = Color(0xFF757575);
const nurseStartGreen    = Color(0xFF2E7D32);
const nursePauseAmber    = Color(0xFFF57F17);
const nurseWarningYellow = Color(0xFFFFA000);
const nurseSeverityCritical = Color(0xFFE53935);
const nurseSeverityWarning  = Color(0xFFFFA000);
const nurseSeverityInfo     = Color(0xFF005EA4);

dmin Theme — Purple #6200EA (≠ Doctor teal):
// ⚠️ Admin uses PURPLE, not doctor's teal — confirmed from UI screenshots
const adminPrimary = Color(0xFF6200EA);   // deep purple — AppBar title, active nav, FAB
const adminColorScheme = ColorScheme.light(
  primary:          Color(0xFF6200EA),
  onPrimary:        Color(0xFFFFFFFF),
  surface:          Color(0xFFF5F5F5),
  onSurface:        Color(0xFF1C1B1F),
  onSurfaceVariant: Color(0xFF49454F),
  outline:          Color(0xFF79747E),
  error:            Color(0xFFBA1A1A),
  errorContainer:   Color(0xFFFFDAD6),
  onErrorContainer: Color(0xFF93000A),
);

// Admin semantic additions
const adminSeverityWarning = Color(0xFFFFA000);  // alert border-left + icon
const adminSeverityCritical = Color(0xFFE53935); // alert border-left + icon
const adminTextSecondary   = Color(0xFF757575);

Login Theme — Neutral #2C2C2C:
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


## 11. UI Component Specs (from Stitch)

Navigation Patterns:
Doctor  → Sidebar Drawer (tablet/web), 4 items: Dashboard · Drug Library · Logs · Reports
          Bottom Nav 4 tabs (mobile): same 4 items
Admin   → Bottom Nav 4 tabs only (mobile-first): STATUS · USERS · LOGS · SETUP
Nurse   → Bottom Nav 4 tabs: Dashboard · Pump · Alarm · Log
          (no standalone FAB — Emergency Stop is a full-width card INSIDE the screen body)
Login   → Standalone centered card, no navigation



Doctor — Drug Editor Layout:
Header: "New Pharmaceutical Protocol" (h1) + "Clinician Verified Mode" chip (top-right, outlined)

Sections (each is a rounded outlined card, rx-xl):
  ┌─ IDENTIFICATION ──────────────────────────────┐
  │  Drug Name *                                  │
  │  [text field — full width, placeholder shown] │
  └───────────────────────────────────────────────┘

  ┌─ POTENCY ─────────────────────────────────────┐
  │  Concentration *                              │
  │  [number field]              [unit: mg/mL]   │
  └───────────────────────────────────────────────┘

  ┌─ FLOW CONTROL ────────────────────────────────┐
  │  Default Rate *                               │
  │  [number field]              [unit: mL/hr]   │
  │                                               │
  │  Soft Limit *                                 │
  │  [number field]              [unit: mL/hr]   │
  │  italic muted: "Overrideable alert threshold."│
  │                                               │
  │  Hard Limit *                                 │
  │  [number field]              [unit: mL/hr]   │
  │  text-error: "Absolute maximum. Cannot be overridden." │
  └───────────────────────────────────────────────┘

Actions (bottom, side by side):
  [Cancel — outlined, rx-lg] [Save Drug Protocol — filled bg-primary, rx-lg]

Nurse — Parameter Entry Screen:
Header: "Parameter Entry" (h1)
Sub-header: drug name (e.g. "Channel A: Norepinephrine Bitartrate")
Top-right chip: "ⓘ Standard Protocol" (outlined, info color)

Input area (2-column card row):
  ┌─ Concentration ─┬─ Rate ✏ ─┐    ┌──────────┐
  │    [value]      │  [value]  │    │  1  2  3 │
  │    mg/mL        │  mL/hr    │    │  4  5  6 │
  │  ─────────      │  ─────    │    │  7  8  9 │
  │  Range:         │  Soft     │    │  .  0  ⌫ │
  │  1.0–16.0 mg/mL │  Limit:   │    └──────────┘
  │                 │  2.0–25.0 │
  └─────────────────┴───────────┘
  Active field (Rate): outlined blue border

  ┌─ Volume To Be Infused (VTBI) ──────────────────┐
  │  [0]  mL          [Select Total Volume dashed] │
  └────────────────────────────────────────────────┘

  ┌─ Dosing Calculation Summary ⊞ ─────────────────┐
  │  Dose          │ Total Infused │ Time Remaining │
  │  5.2 mcg/kg/m  │  2.8          │  06h           │
  └────────────────────────────────────────────────┘

Clinical Protocol Check panel (right side, tablet only):
  bg blue-50, blue text, contextual validation message

Emergency Stop bar (floating, above bottom actions):
  bg #E53935, full-width, icon ◆ + "EMERGENCY STOP" white bold

Bottom actions (3 buttons):
  [CANCEL — outlined] [REVIEW PARAMETERS — filled blue] [▶ START INFUSION — filled green]

Nurse — Pump Controls Button States:
// Running state — 2×2 grid layout:
Start   → disabled (greyed icon ▶, label "START"),   not tappable when running
Pause   → bg white, amber border + amber icon ⏸,     label "PAUSE" in amber  ← outlined, NOT filled
Resume  → disabled (greyed icon ▶|, label "RESUME"), not tappable when running
Stop    → bg white, grey border + grey icon ⏹,       label "STOP" in grey    ← outlined

// Emergency Stop — separate full-width section below 2×2 grid:
EmStop  → bg #E53935, text-white, rounded-xl
          icon ◆ left + "EMERGENCY STOP" (labelCaps, bold, center)
          sub-label: "HOLD 2S TO ACTIVATE" (smaller, white 70%)
          py-20, mx-16, shadow-lg
          requires 2s press-and-hold (GestureDetector onLongPress)

Nurse — Dashboard Real-time Display:
┌─ status pill ──────────────────────────────────────┐
│  ● RUNNING  (green pill)                           │
│  Infusion Active — Channel A   (body, muted)       │
└────────────────────────────────────────────────────┘

┌─ ACTIVE PARAMETERS  [ID: 884920-A chip] ───────────┐
│  INFUSION RATE        VOLUME INFUSED               │
│  125.0  mL/hr         538.2  mL        ← 32pt w700 │
│                                                    │
│  VOLUME REMAINING     TIME REMAINING               │
│  461.8  mL            03:42  hh:mm     ← blue bold │
└────────────────────────────────────────────────────┘

┌─ VTBI PROGRESS  54% ───────────────────────────────┐
│  ████████████████░░░░░░░  (blue progress bar)      │
│  Drug:      Sodium Chloride 0.9%                   │
│  Container: 1000 mL Bag                            │
└────────────────────────────────────────────────────┘

Battery row (above parameters card):
  🔋 85%  ⚡ AC POWER   (inline row, muted text)

Refresh: 1Hz (Timer.periodic 1s)





Admin — Dashboard Layout:
AppBar: [pump icon] [InfusionAdmin — in lavender pill #EDE7F6, text #6200EA] ... [→ logout]
Session banner (conditional): bg amber-50, amber icon ⏱ + "Session expiring in 60s" + [Renew] button

Stat cards (2×2 grid, white, rx-xl, shadow-sm):
  ┌─ System Uptime ──────┐  ┌─ Active Sessions ─────┐
  │  ✅ (green icon)     │  │  👥 (purple icon)      │
  │  99.9%  (dataDisplay)│  │  42    (dataDisplay)   │
  │  Last restart: 14d   │  │  3 Admins, 39 Nurses   │
  └──────────────────────┘  └───────────────────────┘
  ┌─ Engine Status ──────┐  ┌─ Memory Usage ────────┐
  │  ⚙ (blue icon)      │  │  ≡ (amber icon)        │
  │  Stable (titleStyle) │  │  82%   (dataDisplay)   │
  │  ████████░ (blue bar)│  │  ██████░░ (amber bar)  │
  └──────────────────────┘  └───────────────────────┘

Active Alerts card (full-width, white, rx-xl):
  Title "Active Alerts" + red count badge (circle, bg #E53935, text white)
  Each alert row: left-border 3px colored + icon + title bold + body muted
    Warning  → border #FFA000, icon ⚠ amber
    Critical → border #E53935, icon 🔴 red

Safety Limits banner (full-width, bg #6200EA, rx-xl):
  [shield+ icon in rounded square] [Safety Limits bold white] [View global guardrails muted white] [›]

Bottom nav active: icon + label in #6200EA

Admin — Logs Screen:
Filter card (white, rx-xl, stacked fields):
  [📅 Date Range     | "Last 7 Days"        ] ← full-width outlined field
  [💊 Drug Name      | "All Drugs"          ]
  [👤 Patient/User ID| "Search ID..."       ]
  [≡ More Filters                           ] ← outlined full-width button

Log table (white card):
  Header row: Timestamp | Event Type | Description | User ID | Action (bg surface)
  Each row:
    - Timestamp: date bold + time + UTC (stacked, bodyStyle)
    - Event Type: 2-line badge stack (type chip on top, subtype chip below)
        CONFIG CHANGE  → bg blue-50,  text blue-700,  border blue-200
        CRITICAL ALERT → bg red-50,   text red-700,   border red-200
        AUTH SUCCESS   → bg green-50, text green-700, border green-200
    - Description: truncated with "..."
    - User ID: muted
    - Action: › chevron

  Pagination: "Showing 1–3 of 1,204 entries" + [‹] [1] [2] [3] [›]

Admin — Users Screen:
Header: "User Management" (h1, w700, large) + subtitle body muted
Search bar: full-width, rx-xl, [🔍 "Search by ID or Role..."] [≡ filter icon right]

User list (white card, rx-xl):
  Each row (divider-separated):
    [Avatar circle — initial letter, bg role-color-light] [ID bold + "Last login: ..." muted] [Role pill right-aligned]
      Doctor  → avatar bg teal-100,   initial teal-700,  pill bg #00685D text white
      Nurse   → avatar bg blue-100,   initial blue-700,  pill bg #005EA4 text white
      Admin   → avatar bg purple-100, initial purple-700, pill bg #6200EA text white
  Footer: "Showing 3 of 3 users" (caption muted)

System Access card (full-width, bg #6200EA, rx-xl):
  [shield icon watermark — ghost, right side]
  "System Access" bold white
  Total Users: 124  |  Active Sessions: 18  (dataDisplay white)
  FAB [+] bottom-right of card, bg darker purple (#4A00B4 approx), rx-xl


Alarm Severity Badges (log table chips):
// 2-line stacked chips per event (type on top, subtype below), both rx-sm
Critical → bg Color(0xFFFFEBEE), text Color(0xFFB71C1C), border Color(0xFFEF9A9A)
Warning  → bg Color(0xFFFFF8E1), text Color(0xFFE65100), border Color(0xFFFFCC02)  // amber
Success  → bg Color(0xFFE8F5E9), text Color(0xFF1B5E20), border Color(0xFFA5D6A7)  // green (AUTH)
Info     → bg Color(0xFFE3F2FD), text Color(0xFF0D47A1), border Color(0xFF90CAF9)  // blue (CONFIG)

AppBar Structure:
Doctor  (mobile): [≡ hamburger] [Screen title — labelCaps] ... (no role badge in AppBar)
Doctor  (tablet): no hamburger (sidebar always open) ... [🔔] [Logout]
Nurse   (mobile): [≡] [Infusion Monitor — wordmark] ... [Nurse pill — blue] [avatar circle]
Nurse   (tablet): [≡] [Infusion Monitor] ... [Nurse pill — blue]
Admin   (mobile): [pump icon] [InfusionAdmin inside lavender pill] ... [→ logout icon]

TopAppBar: fixed, z-40, bg white, border-b outlineVariant, h-56px
Screen title: labelCaps (11px w700 tracked), color onSurfaceVariant

Login Screen Key Measurements:
Page bg:    #FDF8F8 (warm off-white)
Container:  max-w-[420px], rounded-xl, shadow-md, p-32, bg-white

Logo:       64×64px circle, bg #2C2C2C, rounded-full, IV-bag icon white inside

Title:      "Smart Infusion Pump"      — titleStyle w700, ~24px, center
Subtitle:   "Smart Infusion Simulator" — bodyStyle, onSurfaceVariant, center

Error banner (conditional, shown above fields):
            bg #FFEBEE, border none, rx-lg, p-12
            red filled circle icon (●) + bold red message text

Input label: captionStyle, onSurface, mb-4
Input field: h-44px, rounded-lg, outlined (outlineVariant border)
             Password field: eye-toggle icon right (visibility_off)

Biometric:  h-44px, rounded-lg, outlined, fingerprint icon left, full-width
            label: "Sign in with biometrics"

Login btn:  h-56px, rounded-xl, bg #424242, text white w700, full-width
            label: "Log in"

Element order (top→bottom):
  logo → title → subtitle → [error banner] → User ID field → Password field
  → Biometric button → Login button




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
      'user_id'  :       userid
      'action_type':     action,
      'entity_type':     entityType,
      'entity_id':       entityId,
      'old_value':       oldValue,
      'new_value':       newValue,
      'timestamp':      timestamp,
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

Future<Uint8List> generateInfusionSummary({
  required List<InfusionSession> sessions,
  required DateTimeRange range,
  required String patientId,
  required String drugName,
}) async {
  final doc = pw.Document();
  doc.addPage(pw.MultiPage(
    build: (context) => [
      pw.Header(text: 'Infusion Summary Report'),
      pw.Text('Date range: ${range.start} – ${range.end}'),
      pw.Text('Patient ID: $patientId'),
      pw.Text('Drug: $drugName'),
      _buildSessionTable(sessions),
    ],
  ));
  return doc.save();
}


required String? patientId,   // null = all patients
required String? drugName,    // null = all drugs

if (patientId != null) pw.Text('Patient ID: $patientId'),
if (drugName  != null) pw.Text('Drug: $drugName'),
---

## 15. Security Checklist

- [x] Supabase Auth handles password and national id hashing (bcrypt internally)
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


## 17. Edge Cases — AI Blind Spots

> Stitch AI always generates the Happy Path only. Request these screens manually before moving to implementation.

### Edge Case Screens Required per Role

**🔐 Auth (All Roles)**

| State | Screen / Behavior |
|---|---|
| Wrong credentials | Red error banner above fields — `bg #FFEBEE` + red bold text |
| Deactivated account | Same banner: "Account has been deactivated" |
| Session expired | 60s countdown banner `bg amber-50` at top + `[Renew]` filled amber button |
| No internet at login | Same error banner: "No connection — cannot authenticate" |
| Biometric failed | Fallback to password — biometric button shows error state without crash |

**👨‍⚕️ Doctor**

| State | Screen / Behavior |
|---|---|
| Empty drug library | Empty state: icon + "No drugs added yet" + Add button (teal) |
| Delete drug in active session | Blocking error modal: "Drug in active use" |
| Hard Limit < Soft Limit | Inline validation below Hard Limit field — `text-error` immediately |
| Soft Limit > Default Rate | Inline warning below Soft Limit field — italic muted |
| Report — no data in range | Empty state inside report preview |
| PDF export failed | Error snackbar at bottom + retry |
| No internet | Sidebar footer changes: `● Offline` instead of `● Cloud Sync Active` |

**👩‍⚕️ Nurse**

| State | Screen / Behavior |
|---|---|
| Empty drug list | Empty state: "No drugs available — contact Doctor" |
| Hard Limit exceeded | START INFUSION button disabled + blocking modal |
| Soft Limit exceeded | Yellow warning banner `bg #FFF8E1` + "I understand — proceed" |
| Rate out of range | Field outline turns red + range hint turns red |
| Infusion complete (No KVO) | Auto-transition to Complete state + confirmation dialog |
| Infusion complete (KVO enabled) | Auto-transition to KVO mode — no nurse input required |
| Critical alarm during infusion | Pump auto-pause + alarm panel appears immediately over everything |
| Battery at 20% | `🔋 20%` non-blocking warning banner |
| Battery at 5% | Auto-stop + critical alarm + Emergency Stop shows active state |
| Emergency Stop accidental press | 2s hold required — progress fill during hold + haptic feedback on trigger |
| No internet during session | Simulation continues offline — "Last synced: X mins" in Session Log |

**🔧 Admin**

| State | Screen / Behavior |
|---|---|
| Delete last Admin | Blocking error: "Only one Admin account remaining. Create backup account." |
| Empty user list | Empty state + prominent Add User button (purple FAB) |
| Deactivate own account | Warning dialog: "You are deactivating your own account" |
| Config change affects safety | Double confirmation + mandatory reason field |
| Memory Usage > 80% | Memory card progress bar turns amber |
| Storage Low (Log partition > 90%) | Alert row in Active Alerts with red left-border + critical icon |
| No internet | System health cards show `● Offline` badge instead of live values |

---

## 18 — Proposed building arrangement
1.  Auth Shell        → Login screen (UI) → wire Supabase Auth
2.  Role Router       → GoRouter guards (logic only, no UI)
3.  Nurse UI Shell    → PumpDashboard + Controls + EmergencyStop (UI)
                        → wire InfusionNotifier + InfusionStateMachine
4.  Nurse Logic       → BatterySimulator + LimitValidator + KvoHandler
5.  Doctor UI Shell   → DrugLibrary + DrugEditor sections (UI)
                        → wire DrugNotifier
6.  Doctor Logic      → LimitValidator + AuditLogger + ReportGenerator
7.  Admin UI Shell    → StatusDashboard + UserManagement + LogsViewer (UI)
                        → wire UserNotifier + SystemHealthNotifier
8.  Integration       → Supabase Realtime alarms + RLS testing
9.  PDF Export        → ReportGenerator (Doctor, Section 14)
10. Polish            → Session timeout banner (60s) + offline Drift sync