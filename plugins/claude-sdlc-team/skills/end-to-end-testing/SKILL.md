---
name: end-to-end-testing
description: Drive a running web app end-to-end as a real user (mouse + keyboard) with Playwright and record a screen video — with a visible mouse pointer — for review. Use in the review phase (the e2e-tester agent and /sdlc-e2e) to produce a per-feature recording the user approves before merge. No-ops when there's no web UI; asks before installing Playwright. Encodes the how-to; the orchestrator gates on the video.
---

# End-to-End Testing (Playwright + video review)

Drive the **running app** as a user would and capture a **screen video** of the feature/fix — **with a visible mouse pointer** — so the user can watch and approve it before it merges to `development`. The video lives with the feature's docs and is never committed. Behavioral/black-box, like `qa-tester`, but against the live app. The repo's `docs/sdlc/` tree stays canonical.

**Deliverable is always a video, never screenshots** — and the recording must **show the cursor** so a reviewer can follow what the "user" is doing.

## When this applies (web-UI detection)
Run E2E only when the project has a **web UI**. Detect, in order:
1. A dev/start script in the package manifest (`package.json` `scripts.dev`/`start`/`serve`, or a framework CLI).
2. A web framework dependency (React/Vue/Svelte/Angular/Next/Nuxt/Vite/Remix/Astro, or a server-rendered web framework).
3. A configured/served HTTP port (from the design, env, or `stack-detection`).

**No web UI → no-op:** write a one-line `04e-e2e.md` noting "E2E not applicable (no web UI)", return `VERDICT: PASS (n/a)`, and install nothing. CLIs, APIs, and libraries take this path.

## Playwright provisioning (ask first)
If a web UI exists but Playwright is not installed/configured, **do not install silently** — surface a `QUESTIONS FOR USER` asking whether to scaffold Playwright (Yes / No).
- **Yes:** install Playwright as a dev dependency with the project's package manager (`npm i -D @playwright/test && npx playwright install --with-deps chromium`, or the pnpm/yarn/bun equivalent) and add a minimal config.
- **No:** no-op with a notice (`VERDICT: PASS (n/a)`).

## Recording location & non-committability
- Write videos to **`docs/sdlc/<slug>/e2e-recordings/`**, named **`<slug>-<flow>.webm`** (one per user flow).
- Before recording, ensure the project `.gitignore` contains the line **`docs/sdlc/**/e2e-recordings/`** (append if missing) so video binaries are never committed. The text artifact `04e-e2e.md` stays committed and references the local video path.

## Running the flows (emulate the user)
1. Start the app with the project's own command (from `stack-detection`); wait until its URL is reachable. Tear it down afterward.
2. Configure a Playwright browser context with video recording, e.g.:
   ```js
   const context = await browser.newContext({
     recordVideo: { dir: 'docs/sdlc/<slug>/e2e-recordings', size: { width: 1280, height: 720 } },
   });
   ```
3. **Make the pointer visible (required).** Playwright's `recordVideo` does **not** capture the OS mouse cursor — it dispatches synthetic input events, so a plain recording shows things reacting to clicks with no pointer. Inject a fake cursor overlay that renders *into the page* (so it is captured) and follows every mouse event. Add it on the **context** via `addInitScript` so it survives navigations:
   ```js
   await context.addInitScript(() => {
     const dot = document.createElement('div');
     dot.setAttribute('data-pw-cursor', '');
     Object.assign(dot.style, {
       position: 'fixed', left: '-100px', top: '-100px',
       width: '22px', height: '22px', borderRadius: '50%',
       background: 'rgba(255,64,64,0.55)', border: '2px solid rgba(255,255,255,0.95)',
       boxShadow: '0 0 6px rgba(0,0,0,0.5)', zIndex: '2147483647',
       pointerEvents: 'none', transform: 'translate(-50%, -50%)',
       transition: 'width .08s ease, height .08s ease',
     });
     const mount = () => document.body && document.body.appendChild(dot);
     document.readyState === 'loading' ? addEventListener('DOMContentLoaded', mount) : mount();
     addEventListener('mousemove', e => { dot.style.left = e.clientX + 'px'; dot.style.top = e.clientY + 'px'; }, true);
     const pulse = on => { const s = on ? '14px' : '22px'; dot.style.width = s; dot.style.height = s; };
     addEventListener('mousedown', () => pulse(true), true);
     addEventListener('mouseup', () => pulse(false), true);
   });
   ```
4. Derive one flow per acceptance criterion from `01-requirements.md`. Emulate a **real user with mouse + keyboard** — navigate, click, type, press keys, assert visible outcomes (Playwright locators + `getByRole`/`getByText`; `page.mouse` / `page.keyboard` where a raw gesture matters). Move the pointer **visibly** between targets so the cursor travels on camera rather than teleporting — before a key click, do `await page.mouse.move(x, y, { steps: 20 })` (use `locator.boundingBox()` for coordinates), and add short `waitForTimeout` pauses so the reviewer can follow. A `slowMo` on the browser launch (e.g. `{ slowMo: 250 }`) also makes the run watchable.
5. Close the context so Playwright finalizes the `.webm`; rename it to `<slug>-<flow>.webm`. Quickly verify the file is a non-empty `.webm` (not a screenshot/PNG) before recording its path.

## The 04e-e2e.md artifact
Per `sdlc-artifacts`, start with `# 04e E2E — <slug>` + a one-line summary, then:
- **Flows exercised** — each acceptance area, the steps, pass/fail.
- **Recording(s)** — local path(s) `docs/sdlc/<slug>/e2e-recordings/<slug>-<flow>.webm` (video with a visible cursor; gitignored, not committed). State explicitly that the artifact is a video, not screenshots.
- **Failures** — repro steps for any failing flow.
- `## Open Questions`.

## No-op / degradation contract (non-blocking)
Never hard-halt the pipeline. Degrade to a clear notice + verdict when: no web UI (n/a); Playwright declined (n/a); the app won't start or Playwright errors (`VERDICT: ISSUES FOUND` with the error, or `PASS (n/a)` if environmental/out of scope). Always explain what happened in `04e-e2e.md`.

## How it's used
- **`e2e-tester` agent** — the Phase-4 consumer (writes `04e-e2e.md`, returns the verdict).
- **`/sdlc-e2e`** — runs it on demand for a feature.
- **`skills/sdlc` orchestrator** — dispatches it in Phase 4 and gates Gate ③ on the user watching + approving the recording.
