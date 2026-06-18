---
description: Run or re-run the Implementation phase for a feature — dispatches the implementer to build the approved design with tests and produce 03-implementation.md.
argument-hint: <feature slug>
---

# /sdlc-implement

Run Phase 3 only. Requires an approved design.

1. Read `docs/sdlc/<slug>/` (`00-manifest.md`, `01-requirements.md`, `02-design.md`) for the slug in `$ARGUMENTS` (if none, list slugs and ask). If `02-design.md` is missing, tell the user to run /sdlc-design first.
2. Apply `capability-discovery` + `stack-detection`.
3. Dispatch the `implementer` agent with the approved `01` + `02`.
4. Relay `QUESTIONS FOR USER`; resume same agent until `NO QUESTIONS`.
5. Summarize `03-implementation.md` (files changed, test results); update the manifest. Do not commit/push unless the user asks.
