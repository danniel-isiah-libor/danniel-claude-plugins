# Accessibility (WCAG 2.2 AA)

Accessibility is a build requirement, not polish. Target **WCAG 2.2 AA** unless the project states otherwise.

- **Semantics first:** native elements (`button`, `a`, `label`, `nav`, `main`, headings in order) before ARIA; ARIA only to fill gaps, and never to contradict native semantics.
- **Keyboard:** everything operable by keyboard, logical focus order, visible focus indicator (≥ 3:1 contrast), no keyboard traps, skip-to-content link, focus managed on route changes and dialogs.
- **Names & labels:** every input has a programmatic label; icon-only buttons have an accessible name; images have meaningful `alt` (empty for decorative); link text makes sense out of context.
- **Color & contrast:** text ≥ 4.5:1 (3:1 for large text and UI components); never convey meaning by color alone; support light/dark and `prefers-contrast`.
- **Targets & layout:** touch targets ≥ 24×24 CSS px minimum (≥ 44 recommended on mobile); content reflows at 320px and 200% zoom without loss.
- **Motion & media:** respect `prefers-reduced-motion`; captions/transcripts for media; no auto-playing audio; no content flashing more than 3×/second.
- **Forms:** inline, specific error messages tied to fields (`aria-describedby`), don't rely on placeholder text, preserve entered data, avoid unnecessary re-entry.
- **Dynamic content:** announce status/errors via live regions (`role="status"`/`alert`) sparingly.
- **Verify:** automated checks (axe, Lighthouse) catch ~a third of issues — also test with keyboard only and a screen reader on the key flows.
