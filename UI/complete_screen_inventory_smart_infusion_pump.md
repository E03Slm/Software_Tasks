--------------------------------------------------
STEP 1 — IDENTIFY ALL SCREENS
--------------------------------------------------
DOCTOR SCREENS:
- Analytics Dashboard
- Drug Management (List)
- Drug Detail (Edit)
- Reports
- Logs
- [Doctor] Session Log

NURSE SCREENS:
- Nurse Dashboard
- Drug Library (Selection)
- Infusion Setup
- Active Infusion
- Pump Controls (Pause/Stop)
- Alarm Panel
- [Nurse] Session Log

ADMIN SCREENS:
- System Health Overview
- User Management
- Add/Edit User
- System Config
- Pump Logs
- Audit Logs
- Calibration

SHARED SCREENS:
- Login Screen (PIN/Biometric)
- Role Router / Splash
- Session Timeout Warning
- Hard Limit Blocking Modal
- Battery Critical Alert

--------------------------------------------------
STEP 2 — FORCE VALIDATION
--------------------------------------------------
- Doctor: 6 screens
- Nurse: 7 screens
- Admin: 7 screens
- Shared: 5 screens
TOTAL = 25 screens

--------------------------------------------------
STEP 3 — EXPAND EACH SCREEN (MANDATORY)
--------------------------------------------------

[Login Screen]
Role: Shared
Purpose: Secure entry into the system
UI Layout:
- Top bar: Battery Status, System Time
- Main area: Numeric Keypad (PIN), Biometric Icon
- Bottom/navigation: None
UI Components:
- Buttons: Numeric (0-9), Clear, Login, Biometric trigger
- Inputs: PIN entry fields (masked)
- Indicators: Battery, Time
User Actions:
- Tap: Enter digits
- Hold: None
States:
- Default: Empty fields
- Active: Digits entered
- Error: Invalid PIN (red shake animation)
Validation Rules: 4-6 digit PIN required
Edge Cases: Biometric failure fallback
Access Rules: Public (Pre-auth)

----------------------------------
[Role Router / Splash]
Role: Shared
Purpose: Determine user navigation path based on credentials
UI Layout:
- Main area: Loading spinner, Branding
UI Components:
- Indicators: Progress Spinner
User Actions: None
States: Transitioning
Access Rules: Post-auth

----------------------------------
[Nurse Dashboard]
Role: Nurse
Purpose: Summary of active/pending pump tasks
UI Layout:
- Top bar: Role Badge (NURSE), Battery, Time, Logout
- Main area: Status cards (Active Infusions, Pending Setups)
- Bottom/navigation: Bottom Tabs (Dashboard, Drug Library, Active Infusion, Logs)
UI Components:
- Cards: Summary cards for each pump
- Badges: Status (Idle, Running, Alarm)
User Actions:
- Tap: Navigate to specific pump
States:
- Default: List of pumps
- Alarm: Flashing card if pump in error
Access Rules: Nurse Only

----------------------------------
[Drug Library (Selection)]
Role: Nurse
Purpose: Choose a medication for infusion
UI Layout:
- Top bar: Search bar, Role Badge
- Main area: Scrollable list of drugs
- Bottom/navigation: Bottom Tabs
UI Components:
- Inputs: Search field
- Lists: Drug list (Name, Concentration)
User Actions:
- Tap: Select drug
- Swipe: Scroll
States:
- Active: Highlighted selection
Access Rules: Nurse Only

----------------------------------
[Infusion Setup]
Role: Nurse
Purpose: Configure parameters for selected drug
UI Layout:
- Top bar: Drug Name, Step Indicator
- Main area: Parameter form (Rate, VTBI)
- Bottom/navigation: Confirm/Start Footer
UI Components:
- Buttons: Long-press "Confirm & Start"
- Inputs: Numeric keypad for Rate/VTBI
- Banners: Soft Limit Warning (Yellow)
User Actions:
- Tap: Input data
- Hold: Start Infusion (2s)
States:
- Error: Out of range (Inline red)
- Warning: Soft limit exceeded
Validation Rules: Must be >0; Check against drug library limits
Access Rules: Nurse Only

----------------------------------
[Active Infusion]
Role: Nurse
Purpose: Real-time monitoring of running pump
UI Layout:
- Top bar: Status, Battery, Time
- Main area: Large metrics (Rate, Vol, Time)
- Bottom/navigation: Bottom Tabs, Emergency Stop (Floating)
UI Components:
- Indicators: Animated Progress Bar, VTBI Progress
- Buttons: Emergency Stop (Red, Floating)
- Banners: Battery Warning (Amber)
User Actions:
- Hold: Emergency Stop (2s)
States:
- Running: Metric updates at 1Hz
- Battery Critical: Monochrome high-contrast
Access Rules: Nurse Only

----------------------------------
[Pump Controls (Pause/Stop)]
Role: Nurse
Purpose: Manage active infusion state
UI Layout:
- Main area: Action buttons (Pause, Stop, Resume)
UI Components:
- Buttons: Pause (Primary), Stop (Secondary)
User Actions:
- Tap: Trigger state change
States:
- Paused: Resume button enabled
Access Rules: Nurse Only

----------------------------------
[Alarm Panel]
Role: Nurse / Shared
Purpose: High-visibility notification of critical errors
UI Layout:
- Main area: 80% screen overlay, Alarm title, Instructions
UI Components:
- Buttons: Silence, Acknowledge
- Banners: Severity-coded (Red/Amber)
User Actions:
- Tap: Acknowledge/Silence
States:
- Critical: Cannot dismiss until resolved
Access Rules: Active User

----------------------------------
[Analytics Dashboard]
Role: Doctor
Purpose: View population-level infusion trends
UI Layout:
- Top bar: Role Badge (DOCTOR), Logout
- Main area: Charts (Dosage trends, Usage)
- Bottom/navigation: Bottom Tabs (Analytics, Drug Management, Reports, Logs)
UI Components:
- Charts: Line charts (24h)
- Cards: Aggregate metrics
User Actions:
- Tap: Filter charts
Access Rules: Doctor Only

----------------------------------
[Drug Management (List)]
Role: Doctor
Purpose: Overview of all configured drugs
UI Layout:
- Top bar: Search, Add New icon
- Main area: List with metadata
- Bottom/navigation: Bottom Tabs
UI Components:
- Lists: Drug profiles
- Buttons: Add (+)
Access Rules: Doctor Only

----------------------------------
[Drug Detail (Edit)]
Role: Doctor
Purpose: Edit safety limits and baseline parameters
UI Layout:
- Top bar: Drug Name, Save button
- Main area: Form fields for limits
UI Components:
- Inputs: Hard/Soft limit fields
- Toggles: Enable/Disable limit
Validation Rules: Hard limit must be > Soft limit
Access Rules: Doctor Only

----------------------------------
[System Health Overview]
Role: Admin
Purpose: High-level status of all hardware/network
UI Layout:
- Top bar: Role Badge (ADMIN), Sidebar trigger
- Main area: Grid of pump statuses
- Bottom/navigation: None (Side Drawer)
UI Components:
- Indicators: Green/Red health dots
- Cards: Hardware summary
Access Rules: Admin Only

----------------------------------
[User Management]
Role: Admin
Purpose: List of staff accounts
UI Layout:
- Top bar: Search, Filter
- Main area: User cards/table
- Bottom/navigation: FAB (Add User)
UI Components:
- Buttons: Add User FAB
- Badges: Active/Inactive status
Access Rules: Admin Only

----------------------------------
[Session Timeout Warning]
Role: Shared
Purpose: Prevent unauthorized access on idle devices
UI Layout:
- Main area: Modal with countdown (30s)
UI Components:
- Buttons: Keep Session, Logout
User Actions:
- Tap: Reset timer
States:
- Active: Countdown running
Access Rules: All logged-in users

----------------------------------
[Hard Limit Blocking Modal]
Role: Shared
Purpose: Prevent unsafe medication administration
UI Layout:
- Main area: Red background, "Action Blocked" text
UI Components:
- Buttons: Back to Edit
Access Rules: Operational users

----------------------------------
[Calibration]
Role: Admin
Purpose: Hardware precision tuning
UI Layout:
- Main area: Step-by-step calibration guide
UI Components:
- Progress indicators
- Calibration values (numeric)
Access Rules: Admin Only

--------------------------------------------------
STEP 4 — SAFETY CHECK
--------------------------------------------------
- Total Screens: 25 (Exceeds minimum 15)
- Nurse role includes: Dashboard, Drug Selection, Setup, Active Infusion, Controls, Emergency Stop, Alarm Panel, Logs.
- Admin role includes: Health, User Mgmt, Config, Logs, Calibration.
- Shared includes: Login, Timeout, Blocking, Battery.
- All technical constraints and user actions mapped.
