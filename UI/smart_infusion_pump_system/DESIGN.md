---
name: Smart Infusion Pump System
colors:
  surface: '#f6faf8'
  surface-dim: '#d6dbd9'
  surface-bright: '#f6faf8'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f0f5f2'
  surface-container: '#eaefec'
  surface-container-high: '#e4e9e7'
  surface-container-highest: '#dfe4e1'
  on-surface: '#171d1b'
  on-surface-variant: '#3d4946'
  inverse-surface: '#2c3130'
  inverse-on-surface: '#edf2ef'
  outline: '#6d7a77'
  outline-variant: '#bcc9c5'
  surface-tint: '#006b5f'
  primary: '#00685d'
  on-primary: '#ffffff'
  primary-container: '#008376'
  on-primary-container: '#f4fffb'
  inverse-primary: '#70d8c8'
  secondary: '#4755b6'
  on-secondary: '#ffffff'
  secondary-container: '#8a99fe'
  on-secondary-container: '#1b2b8c'
  tertiary: '#4a5f69'
  on-tertiary: '#ffffff'
  tertiary-container: '#627882'
  on-tertiary-container: '#fbfdff'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#8df5e4'
  primary-fixed-dim: '#70d8c8'
  on-primary-fixed: '#00201c'
  on-primary-fixed-variant: '#005048'
  secondary-fixed: '#dfe0ff'
  secondary-fixed-dim: '#bbc3ff'
  on-secondary-fixed: '#000d5f'
  on-secondary-fixed-variant: '#2d3c9c'
  tertiary-fixed: '#cfe6f2'
  tertiary-fixed-dim: '#b4cad6'
  on-tertiary-fixed: '#071e27'
  on-tertiary-fixed-variant: '#354a53'
  background: '#f6faf8'
  on-background: '#171d1b'
  surface-variant: '#dfe4e1'
  nurse-primary: '#00897B'
  doctor-primary: '#303F9F'
  admin-primary: '#455A64'
  success-green: '#2E7D32'
  warning-amber: '#FFB300'
  critical-red: '#D32F2F'
  surface-neutral: '#F5F5F5'
  text-high-contrast: '#212121'
  soft-limit-bg: '#FFF8E1'
  hard-limit-bg: '#FFEBEE'
typography:
  metric-xl:
    fontFamily: Inter
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 56px
    letterSpacing: -0.02em
  metric-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
  headline-md:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-bold:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '700'
    lineHeight: 20px
  helper-text:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  touch-target-min: 48px
  gutter: 16px
  margin-edge: 20px
  stack-sm: 8px
  stack-md: 16px
  stack-lg: 24px
  input-height: 56px
---

# Smart Infusion Pump Simulator: UI/UX Specification

## 1. GLOBAL UI SYSTEM DESIGN
- **Platform Assumptions:** Mobile-first (Portrait orientation), high-density information display, optimized for one-handed operation in clinical settings.
- **Navigation Patterns:**
    - Nurse/Doctor: Bottom Tab Bar for primary navigation; hierarchical drill-down for settings.
    - Admin: Side Drawer for system-level configuration; Grid-based dashboard.
- **Color Themes per Role:**
    - **Nurse (Action-Oriented):** Primary: Teal (#00897B); Success: Green; Warning: Amber; Critical: Red.
    - **Doctor (Analytical):** Primary: Deep Indigo (#303F9F); Data-heavy views with neutral grays and high-contrast text.
    - **Admin (Systemic):** Primary: Slate Gray (#455A64); Focus on status indicators and system health.
- **Typography:** Clinical readability focus using Sans-Serif (e.g., Roboto or Inter). 
    - Body: 16px min for legibility.
    - Metrics (Rate/Volume): Large, bold tabular figures.
- **Accessibility:** 
    - Contrast ratio > 4.5:1.
    - Touch targets min 48x48dp.
    - Redundant coding (color + icons) for all alarms.
- **Session Rules:** 
    - 5-minute inactivity timeout.
    - Persistent role badge in header.
    - Secure PIN/Biometric login flow.
- **Persistent UI Elements:** 
    - Top Header: Role Badge, Battery Status, System Time, Logout Icon.
    - Emergency Stop: Floating Red Button (Nurse/Doctor infusion screens).

## 2. ROLE-BASED UI ARCHITECTURE

### NURSE ROLE
- **Navigation:** Bottom Tabs (Dashboard, Drug Library, Active Infusion, Logs).
- **Entry Screen:** Dashboard (Summary of active/pending tasks).
- **Restrictions:** Cannot edit drug library definitions or access system config.

### DOCTOR ROLE
- **Navigation:** Bottom Tabs (Analytics, Drug Management, Reports, Logs).
- **Entry Screen:** Analytics Dashboard (Population-level infusion trends).
- **Restrictions:** Cannot start/stop active infusions on physical pumps.

### ADMIN ROLE
- **Navigation:** Side Drawer (User Management, System Config, Pump Health, Audit Logs).
- **Entry Screen:** System Health Overview.
- **Restrictions:** No access to patient-specific medical data or drug administration.

## 3. SCREEN INVENTORY (DETAILED)

### [NURSE] - Infusion Setup Screen
- **Purpose:** Configure parameters for a selected drug.
- **Layout:** Header (Drug Name), Body (Form), Footer (Confirm/Start).
- **Components:** Numeric keypads, Soft Limit warnings, Progress Stepper.
- **Interactions:** Tap to input, swipe to clear, long-press "Start" to prevent accidental activation.
- **Validation:** Real-time check against Hard/Soft limits.

### [DOCTOR] - Drug Management Screen
- **Purpose:** Define and edit drug profiles.
- **Layout:** List view with search; Detail view with editable fields.
- **Components:** Text fields, Limit toggles (Hard/Soft), Unit selectors (mg, mcg, ml).
- **Edge Cases:** Preventing deletion of drugs currently in active use.

### [ADMIN] - User Management Screen
- **Purpose:** Create and manage staff accounts.
- **Layout:** Searchable table/list of users.
- **Components:** Add User FAB, Status Badges (Active/Inactive), Role Dropdowns.

## 4. COMPONENT-LEVEL BREAKDOWN
- **Buttons:**
    - Primary: Filled, high contrast.
    - Secondary: Outlined.
    - Emergency Stop: Large, Circular, Red, persistent elevation.
- **Input Fields:** Large numeric inputs with unit suffixes; error state highlights border in red.
- **Banners:** 
    - Soft Limit: Yellow background, "Confirm Overwrite" checkbox.
    - Hard Limit: Red background, "Action Blocked" message.
- **Badges:** Role-specific colors in the top right corner.

## 5. STATE-DRIVEN UI LOGIC
- **Pump States:**
    - *Idle:* Setup button enabled.
    - *Running:* Animated progress bar, "Pause" enabled, "Start" disabled.
    - *Alarm:* Screen flashes red/amber; persistent Alarm Panel appears.
- **Real-time Updates:** 1Hz refresh for "Volume Infused" and "Time Remaining."

## 6. SAFETY-CRITICAL UI ELEMENTS
- **Emergency Stop:** Always visible during infusion. Requires a 2-second hold to trigger.
- **Alarm Panel:** Overlays 80% of screen. Must be acknowledged to minimize. Critical alarms cannot be dismissed until the condition is resolved.

## 7. DATA VISUALIZATION
- **Metrics:** Bold, high-contrast digital-style clock/digits for Rate (mL/h).
- **Analytics:** Line charts for dosage trends over 24h (Doctor role).

## 8. ERROR HANDLING
- **Inline Validation:** Red text below fields for out-of-range values.
- **Blocking Modals:** For Hard Limit violations or System Failures.

## 9. CROSS-SCREEN RULES
- **Session Timeout:** Warning modal at 30s remaining.
- **Role Enforcement:** Navigation paths are strictly isolated per JWT/Role token.

## 10. COMPLETE USER FLOWS
### [NURSE] Infusion Flow:
1. Select "Drug Library" tab.
2. Search and tap "Dopamine."
3. Enter Rate (mL/h) and VTBI (Volume To Be Infused).
4. Review "Soft Limit" warning (if applicable).
5. Long-press "Start Infusion."

## 11. EDGE CASES
- **Battery Critical:** UI switches to high-contrast monochrome; "Battery Low" persistent banner.
- **Network Loss:** Offline mode indicator; local caching of logs.