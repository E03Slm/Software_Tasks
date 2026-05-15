---
name: Clinical Precision System
colors:
  surface: '#f8f9ff'
  surface-dim: '#d7dae2'
  surface-bright: '#f8f9ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f1f3fc'
  surface-container: '#ebeef6'
  surface-container-high: '#e5e8f0'
  surface-container-highest: '#e0e2ea'
  on-surface: '#181c22'
  on-surface-variant: '#404752'
  inverse-surface: '#2d3137'
  inverse-on-surface: '#eef0f9'
  outline: '#707783'
  outline-variant: '#c0c7d4'
  surface-tint: '#0060a8'
  primary: '#005ea4'
  on-primary: '#ffffff'
  primary-container: '#0077ce'
  on-primary-container: '#fdfcff'
  inverse-primary: '#a2c9ff'
  secondary: '#5e5e5e'
  on-secondary: '#ffffff'
  secondary-container: '#e3e2e2'
  on-secondary-container: '#646464'
  tertiary: '#8f4a00'
  on-tertiary: '#ffffff'
  tertiary-container: '#b35e00'
  on-tertiary-container: '#fffbff'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d3e4ff'
  primary-fixed-dim: '#a2c9ff'
  on-primary-fixed: '#001c38'
  on-primary-fixed-variant: '#004881'
  secondary-fixed: '#e3e2e2'
  secondary-fixed-dim: '#c7c6c6'
  on-secondary-fixed: '#1b1c1c'
  on-secondary-fixed-variant: '#464747'
  tertiary-fixed: '#ffdcc4'
  tertiary-fixed-dim: '#ffb780'
  on-tertiary-fixed: '#2f1400'
  on-tertiary-fixed-variant: '#6f3800'
  background: '#f8f9ff'
  on-background: '#181c22'
  surface-variant: '#e0e2ea'
typography:
  title:
    fontFamily: Inter
    fontSize: 20pt
    fontWeight: '600'
    lineHeight: 28pt
  body:
    fontFamily: Inter
    fontSize: 16pt
    fontWeight: '400'
    lineHeight: 24pt
  caption:
    fontFamily: Inter
    fontSize: 13pt
    fontWeight: '500'
    lineHeight: 18pt
  numeric-display:
    fontFamily: Inter
    fontSize: 32pt
    fontWeight: '700'
    lineHeight: 40pt
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base_unit: 8px
  internal_padding: 16px
  gutter: 16px
  margin_edge: 24px
  stack_space: 12px
---

## Brand & Style

The design system is engineered for high-stakes medical environments where cognitive load must be minimized and clarity is paramount. The target audience is nursing staff operating critical care machinery under time pressure. The UI evokes a sense of reliability, clinical safety, and absolute precision.

The visual style is **Corporate / Modern** with a focus on functional utility. It prioritizes information hierarchy and rapid scannability over decorative elements. By utilizing a clean, structured layout with high-contrast elements, the design system ensures that critical infusion data is legible from a distance and under varied lighting conditions, meeting WCAG AA standards for accessibility.

## Colors

The palette is anchored in a professional blue spectrum to promote a sense of calm and institutional trust. 

- **Primary & Action:** The primary blue is used for key interactive elements and the "Nurse" role identification. 
- **Functional Semantics:** Colors are strictly reserved for status communication. Red is used exclusively for errors and the Emergency Stop; Amber for warnings/cautions; Green for successful starts and active infusions.
- **Neutrality:** The background and surface colors utilize a light grey-to-white scale to provide a clean canvas that makes semantic colors "pop" during alerts.

## Typography

This design system utilizes **Inter** for its exceptional legibility in digital interfaces and its neutral, systematic tone. 

- **Title (20pt):** Used for screen headers and primary medication names.
- **Body (16pt):** The standard for all input labels, secondary data points, and instructions.
- **Caption (13pt):** Reserved for metadata, unit measurements (e.g., mL/hr), and timestamps.
- **Numeric Display:** A specialized bold treatment for dosage rates and volume remaining, ensuring these critical values are the most prominent elements on the screen.

## Layout & Spacing

The layout follows a **Fluid Grid** model optimized for touch interaction on medical tablets or pump screens. It utilizes an 8pt rhythm to maintain consistent vertical and horizontal pacing.

- **Internal Padding:** A strict 16px padding is applied to all containers and cards to ensure touch targets are accessible and content does not feel cramped.
- **Safe Areas:** A 24px margin is maintained at the edges of the display to prevent accidental touches and ensure visibility within physical pump frames.
- **Grouping:** Related data points (e.g., Dose, Rate, VTBI) are grouped with 12px spacing to visually link the information.

## Elevation & Depth

To maintain a clean, clinical look, this design system uses **Tonal Layers** and **Low-contrast Outlines** rather than heavy shadows.

- **Level 0 (Background):** The base layer using the light grey background hex.
- **Level 1 (Cards/Surface):** White surfaces with a 1px border (#E0E0E0) to define clear boundaries for data modules.
- **Level 2 (Modals/Overlays):** Used for high-priority alerts, utilizing a subtle ambient shadow (0px 4px 12px, 10% opacity) to provide focus without clutter.
- **Interactive States:** Buttons use a slight color shift or the Primary Light tint on hover/press to indicate tactility.

## Shapes

The design system employs **Round Eight** (8px) geometry across all standard components.

- **Standard Components:** Buttons, input fields, and data cards utilize a 0.5rem (8px) radius. This balances a modern aesthetic with a professional, structured feel.
- **Role Badge:** The "Nurse" chip uses a 1rem (16px) radius to create a distinct, pill-shaped appearance that differentiates user identity from actionable UI elements.
- **Emergency Stop:** A full-width rectangular element with minimal 4px rounding to emphasize its structural importance and urgency.

## Components

- **Buttons:** Primary buttons use the Primary Blue (#1E88E5) with white text. Secondary buttons use an outlined style. The "Start" button uses Success Green (#43A047).
- **Emergency Stop:** A full-width, high-visibility Red (#E53935) button fixed to the bottom of the active infusion screen.
- **Role Badge:** A chip-style element with Primary Blue background and white text, pre-labeled "Nurse," positioned in the global header.
- **Input Fields:** Large, 16pt text fields with defined 8px corners and 1px borders. Active states are highlighted with the Primary Blue border.
- **Data Cards:** White surface modules used to house specific infusion parameters. They use 16px internal padding and 8px rounding.
- **Status Indicators:** Icons or small badges using the semantic color palette (Info, Warning, Critical) to provide instant visual feedback on pump health.
- **Progress Bars:** High-contrast bars showing Volume To Be Infused (VTBI) progress, using Primary Blue for active and Surface for remaining.