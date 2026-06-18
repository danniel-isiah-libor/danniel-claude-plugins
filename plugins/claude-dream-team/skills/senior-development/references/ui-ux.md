# UI/UX — cross-platform & uniform design system

Prioritize the user: clarity, fast feedback, and consistency. Follow the project's existing design system if it has one (`project-adaptation`); otherwise establish the one below.

## Hybrid cross-platform (web / mobile / desktop)
- Design **responsive + adaptive**: fluid layouts and breakpoints for web; respect platform conventions for mobile (touch targets ≥44px, safe areas, gestures) and desktop (pointer, keyboard shortcuts, window resizing, menus).
- Build for **touch and pointer** both; never hide critical actions behind hover-only interactions.
- Reuse one component layer across platforms where the stack allows (responsive web, or the project's cross-platform framework); diverge only where a platform genuinely needs it.

## Uniform design system (single source of truth)
- **Design tokens:** define color, typography, spacing, radius, and elevation as tokens; reference tokens, never hardcoded values.
- **Color palette:** one semantic palette (primary / secondary / surface / success / warning / error …) with light + dark variants; meet WCAG contrast.
- **Icons:** a single icon set used at consistent sizes and stroke weights; never mix icon styles.
- **Typography:** one type scale and font-family set; consistent weights.
- **Components:** a shared, documented component library; compose every screen from it so the product looks like one product.

## Accessibility (non-negotiable)
- Semantic HTML / proper roles; full keyboard navigation with visible focus; sufficient contrast; labels on inputs; respect reduced-motion.

## UX essentials
- Every action gives feedback; handle loading, empty, and error states explicitly; prevent destructive mistakes (confirm / undo); keep copy clear and concise.
