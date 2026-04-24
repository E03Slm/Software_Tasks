```markdown
# Design System Document: The Clinical Sentinel

## 1. Overview & Creative North Star
This design system is built for the high-stakes environment of a Smart Infusion Pump Simulator. Our Creative North Star is **"The Clinical Sentinel."** 

In a medical context, software must be more than functional; it must be an authoritative partner. We are moving away from the "template" look of medical software—which is often cluttered and fragile—toward a signature, high-end editorial experience. We achieve this through **Intentional Asymmetry** (drawing the eye to critical vitals), **Tonal Depth** (creating a sense of physical hardware), and **Hyper-Legibility** (utilizing the Inter typeface at scale). The goal is a "Zero-Failure" aesthetic where the interface feels as solid and reliable as the physical pump itself.

---

## 2. Colors & Surface Philosophy
The palette is grounded in clinical precision, utilizing a range of blues and whites to establish a sterile, trustworthy environment, punctuated by high-intensity alert tokens.

### The "No-Line" Rule
**Explicit Instruction:** Designers are prohibited from using 1px solid borders to section off content. 
Boundaries must be defined solely through background color shifts or subtle tonal transitions. For example, a medication dosage area (`surface-container-low`) should sit on the main background (`surface`) without a stroke. This creates a more modern, integrated feel that mimics premium medical hardware.

### Surface Hierarchy & Nesting
Treat the UI as a series of physical layers. Use the following tiers to define importance:
*   **Background (`#f7faf9`):** The base "Hospital White."
*   **Surface-Container-Low (`#f1f4f3`):** For secondary information blocks (e.g., secondary infusion settings).
*   **Surface-Container-Lowest (`#ffffff`):** Use this for the most critical interactive cards (e.g., the "Current Rate" display) to make them "pop" off the screen.

### Signature Textures
To avoid a flat, "software-only" look, use subtle linear gradients for main headers. A transition from `primary` (`#003b5a`) to `primary_container` (`#1a5276`) adds a professional polish and "soul" that flat fills lack.

---

## 3. Typography: The Signal & The Noise
We use **Inter** exclusively. It is a typeface designed for screens, providing the bold, sans-serif clarity required for clinical settings.

*   **The Primary Signal (`display-lg` to `headline-lg`):** Reserved for the infusion rate (mL/h) and Volume To Be Infused (VTBI). This must be bold and immediate.
*   **The Guidance (`title-md`):** Used for medication names and concentration. This is the "Anchor" of the screen.
*   **The Metadata (`label-md` to `body-sm`):** Used for battery life, wireless signal, and secondary pump status.
*   **Hierarchy Note:** Use high-contrast weight (Bold) for the "Signal" and Medium/Regular for the "Noise" (metadata). This ensures that in a crisis, the clinician sees the number before the label.

---

## 4. Elevation & Depth
In this system, depth is a functional tool for safety, not just an aesthetic choice.

*   **The Layering Principle:** Achieve lift by stacking tiers. Place a `surface-container-lowest` card on a `surface-container-low` section. The slight shift in brightness creates a soft, natural lift.
*   **Ambient Shadows:** For floating modals or critical alarms, use "Clinical Shadows." These must be extra-diffused (Blur: 24px+) and low-opacity (4%-6%). The shadow color should be a tinted version of `on-surface` (`#181c1c`) to mimic ambient hospital lighting.
*   **The "Ghost Border" Fallback:** If a boundary is required for accessibility, use the `outline_variant` token at **15% opacity**. Never use 100% opaque, high-contrast borders.
*   **Glassmorphism & Urgency:** Use backdrop-blur (12px) on alert overlays using `error_container` or `tertiary_container` at 80% opacity. This allows the clinician to see the state of the pump behind the alert, maintaining situational awareness.

---

## 5. Components

### Buttons (Tap-Certainty)
*   **Primary Action:** High-contrast `primary` background with `on_primary` text. Large targets (min 64px height) for gloved hands.
*   **Secondary Action:** `primary_fixed_dim` background. 
*   **Corner Radius:** Use `md` (0.375rem) for a professional, "tooled" look.

### Alerts & Alarms
*   **Critical (Hard Limits):** Use `secondary` (`#b02d21`) for backgrounds. Text must be `on_secondary`. These should utilize a subtle pulse animation.
*   **Warning (Soft Limits/KVO):** Use `tertiary_container` (`#6f4400`) with `on_tertiary_container`. 

### Input Fields (Dosage Entry)
*   **State:** Forbid the standard "line" input. Use a `surface_container_highest` background with a `sm` (0.125rem) bottom-weighted focus indicator in `primary`. 
*   **Typography:** Numbers in input fields should use `headline-md` for maximum visibility during entry.

### Cards & Lists (The "Breathable" List)
*   **Structure:** Forbid divider lines. Separate list items using 16px of vertical white space from the spacing scale. 
*   **Interaction:** On hover or touch-down, shift the background of the list item to `surface_bright`.

### Additional Specialized Components
*   **The Infusion Gauge:** A custom progress component using a gradient from `primary` to `primary_fixed_dim` to show volume remaining.
*   **Titration Slider:** A thick, high-affordance track using `primary_container` with a large, `surface-container-lowest` thumb for tactile precision.

---

## 6. Do’s and Don’ts

### Do
*   **Do** use `surface-container` tiers to create hierarchy.
*   **Do** ensure all touch targets are at least 48x48dp, ideally larger (64dp+) for critical actions like "BOLUS" or "STOP."
*   **Do** use `headline-lg` for numeric values. In clinical simulators, the number is the most important data point.
*   **Do** use `display-sm` for the medication name to ensure it is readable from 10 feet away.

### Don't
*   **Don't** use 1px solid borders. It makes the software look like a legacy system.
*   **Don't** use pure black for text. Use `on_surface` (`#181c1c`) for a more sophisticated, high-end feel.
*   **Don't** use drop shadows on buttons. Use tonal shifts (`primary` to `on_primary_container`) to indicate state changes.
*   **Don't** crowd the screen. If the information isn't life-critical, move it to a secondary "Details" layer using a glassmorphic slide-over.

---

*Director's Note: Every pixel in this system must communicate stability. If an element feels "decorative," remove it. If an element feels "standard," elevate it.*```