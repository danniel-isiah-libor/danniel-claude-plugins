---
description: Run or re-run the Design phase for a feature — dispatches the solution-architect to produce 02-design.md.
argument-hint: <feature slug>
---

# /sdlc-design

Run Phase 2 only. Requires an existing feature.

1. Read `docs/sdlc/<slug>/00-manifest.md` and `01-requirements.md` for the slug in `$ARGUMENTS` (if no slug given, list available slugs under docs/sdlc/ and ask which). If `01-requirements.md` is missing, tell the user to run /sdlc-requirements first.
2. Apply `capability-discovery` + `stack-detection`.
3. Dispatch the `solution-architect` agent with the approved `01-requirements.md`.
4. Relay `QUESTIONS FOR USER` (AskUserQuestion); resume same agent until `NO QUESTIONS`.
5. Present `02-design.md`; update the manifest.
