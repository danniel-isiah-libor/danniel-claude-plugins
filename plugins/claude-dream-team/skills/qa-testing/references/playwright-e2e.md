# Playwright E2E

Use the project's existing Playwright config if present; otherwise scaffold minimally (`@playwright/test`). Ask before installing browsers or dependencies.

## What to cover
- **Critical journeys** end to end (sign-up/login, the money path, the core create-edit-delete loop) — not every screen.
- **Failure modes**: validation errors, server 4xx/5xx, offline/slow network, expired session, permission denied, empty states.
- **Platforms**: the project's target browsers and viewports (desktop + mobile projects in `playwright.config`).

## Writing reliable tests
- **Locators** by role/label/text first (`getByRole`, `getByLabel`), `data-testid` as a fallback; never CSS chains or XPath tied to layout.
- **Web-first assertions** (`await expect(locator).toBeVisible()`) that auto-wait. No `waitForTimeout`/sleeps.
- **Isolation**: each test creates its own data (API/DB seeding), logs in via a stored `storageState` rather than the UI, and cleans up. Tests must pass in any order and in parallel.
- **Page objects / fixtures** for repeated flows; keep assertions in the test, not hidden in helpers.
- **Network control**: mock third-party calls (`page.route`) and keep your own backend real.
- **Accessibility smoke**: run `@axe-core/playwright` on key pages when available; report violations as findings.
- **Visual checks** only where they add value, with pinned viewport/fonts and masked dynamic regions.

## CI and diagnosis
- Run headless; `retries: 1–2` in CI only to *detect* flakiness (a test that passes on retry is reported flaky, not green); `trace: 'on-first-retry'`, `screenshot: 'only-on-failure'`, `video: 'retain-on-failure'`.
- Shard large suites; cache browsers; upload the HTML report and traces as artifacts.
- Target **local or staging** only — never production, never third-party sites.

## Reporting
For failures include the failing step, trace/screenshot path, the expected vs actual, and a minimal repro; classify product bug vs test bug vs environment flake.
