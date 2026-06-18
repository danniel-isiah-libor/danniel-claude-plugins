---
description: Run the end-to-end test layer on demand — drive the running app as a user via Playwright and record a review video (with a visible mouse pointer, never screenshots) to docs/sdlc/<slug>/e2e-recordings/. No-ops without a web UI; asks before installing Playwright.
argument-hint: <feature slug>
---

# /sdlc-e2e

Run the Phase-4 E2E layer only, on demand. Requires an implemented feature.

1. Resolve the feature slug from `$ARGUMENTS`; if none, list slugs under `docs/sdlc/` and ask. If `03-implementation.md` is missing, tell the user to run `/sdlc-implement` first.
2. Apply `capability-discovery` + `stack-detection`.
3. Dispatch the `e2e-tester` agent (never pass a model override) with `01`/`02`/`03` + the diff. It detects a web UI and **no-ops with a notice if there is none**. Relay any `QUESTIONS FOR USER` (including the "scaffold Playwright?" prompt) and resume the agent until `NO QUESTIONS`.
4. Report the `VERDICT`, the `04e-e2e.md` summary, and the recording path (`docs/sdlc/<slug>/e2e-recordings/<slug>-<flow>.webm` — a video with a visible cursor; gitignored; open it locally to review). Fixing is the implementer's job via `/sdlc-implement`.
