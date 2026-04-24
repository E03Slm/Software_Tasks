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