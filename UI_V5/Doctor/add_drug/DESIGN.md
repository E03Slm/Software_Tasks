---
name: Clinical Precision
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
  secondary: '#41655f'
  on-secondary: '#ffffff'
  secondary-container: '#c3ebe2'
  on-secondary-container: '#476b65'
  tertiary: '#91462c'
  on-tertiary: '#ffffff'
  tertiary-container: '#b05e41'
  on-tertiary-container: '#fffbff'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#8df5e4'
  primary-fixed-dim: '#70d8c8'
  on-primary-fixed: '#00201c'
  on-primary-fixed-variant: '#005048'
  secondary-fixed: '#c3ebe2'
  secondary-fixed-dim: '#a8cec6'
  on-secondary-fixed: '#00201c'
  on-secondary-fixed-variant: '#294d47'
  tertiary-fixed: '#ffdbcf'
  tertiary-fixed-dim: '#ffb59c'
  on-tertiary-fixed: '#390c00'
  on-tertiary-fixed-variant: '#763219'
  background: '#f6faf8'
  on-background: '#171d1b'
  surface-variant: '#dfe4e1'
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
    letterSpacing: 0.02em
  data-display:
    fontFamily: Inter
    fontSize: 32pt
    fontWeight: '700'
    lineHeight: 40pt
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
  card_padding: 16px
---

## Brand & Style

This design system is engineered for high-stakes medical environments where clarity, speed of cognition, and error prevention are paramount. The brand personality is authoritative yet calm, utilizing a **Corporate / Modern** aesthetic that prioritizes functional utility over decorative flair. 

The visual language follows a "Clinical Minimalism" approach: maximizing whitespace to reduce cognitive load while employing high-contrast elements to ensure critical infusion data is legible under various hospital lighting conditions. The emotional response is one of reliability and safety, reassuring the clinician that the interface is a precise instrument rather than a consumer application.

## Colors

The color palette is anchored by a **Dark Teal (#00897B)**, chosen for its professional association with healthcare and its excellent legibility when paired with white text. This primary tone is used for the most important interactive elements and the "Doctor" role badge. 

A neutral **Background (#F5F5F5)** provides a soft foundation that reduces screen glare, while **Surface (#FFFFFF)** is reserved for content cards to create clear containment. Success, Warning, and Error colors are strictly reserved for physiological alarms and pump status indicators, ensuring that the clinician's eye is drawn immediately to deviations in patient care. All color combinations meet or exceed WCAG AA standards for contrast.

## Typography

This design system utilizes **Inter** as the primary typeface due to its exceptional legibility in digital interfaces and its tall x-height, which aids in reading numerical values quickly. 

The type hierarchy is streamlined to three primary levels:
- **Title (20pt):** Used for screen headers and critical patient identifiers.
- **Body (16pt):** Used for medication names, dosage parameters, and general instructions.
- **Caption (13pt):** Used for secondary metadata and timestamps.

For the pump's "Flow Rate" and "Volume To Be Infused (VTBI)", a specialized **Data Display** style is used to ensure numerical values are the most prominent elements on the screen.

## Layout & Spacing

The layout is built on a rigorous **8pt grid system**, ensuring mathematical harmony across all components. A fluid grid model is employed to allow the simulator to adapt to different medical tablet or bedside monitor resolutions.

Margins and gutters are standardized at 16px to prevent visual crowding. **Internal card padding is strictly set to 16px**, creating a consistent "breathable" frame around critical data. Touch targets for buttons and interactive inputs must maintain a minimum height of 48px to accommodate gloved interaction in a clinical setting.

## Elevation & Depth

This design system uses **Tonal Layers** and **Low-Contrast Outlines** rather than heavy shadows to convey depth. This prevents the UI from feeling cluttered or "muddy."

- **Level 0 (Background):** #F5F5F5 - The base canvas.
- **Level 1 (Cards/Surfaces):** #FFFFFF - Used for primary content containers. These use a 1px border (#E0E0E0) to define edges.
- **Level 2 (Modals/Overlays):** These utilize a soft, ambient shadow (10% opacity, 12px blur) to signify temporary interaction states over the main interface.

Depth is used sparingly to indicate "interactability," where buttons may have a subtle 2px bottom-edge shadow to suggest tactile pressability.

## Shapes

The shape language is **Soft (0.25rem / 4px)**. This subtle rounding provides a modern, clean feel that is less aggressive than sharp corners while maintaining the professional, "industrial" look required for medical equipment.

Large containers like cards use the standard 4px radius, while buttons and chips follow this same logic to maintain a cohesive visual identity across the simulator.

## Components

### Buttons
- **Primary:** Solid #00897B fill with white text. High-emphasis for "Start Infusion" or "Confirm."
- **Secondary:** 2px #00897B outline with #00897B text. Used for "Cancel" or "Back."

### Role Badge
- **Doctor Chip:** A specialized pill-shaped component with a #00897B background and white "Doctor" text in 13pt bold caption style. Placed in the top-right of the global header.

### Cards
- Surfaces with white backgrounds, 4px rounded corners, and 16px internal padding. Used to group related parameters like "Drug Info" or "Patient Vitals."

### Input Fields
- Underlined or outlined with #4DB6AC when focused. Numerical pads should feature large, 24pt digits for error-free dosage entry.

### Infusion Progress Bar
- A thick 12px bar using #4DB6AC for the track and #00897B for the progress fill, providing a clear visual representation of completion.

### List Items
- Clean, 64px minimum height rows with 1px dividers. Title text is left-aligned; values are right-aligned for easy scanning.