---
description: Run or re-run the Requirements phase for a feature — dispatches the requirements-analyst to produce 01-requirements.md.
argument-hint: <feature request or existing slug>
---

# /sdlc-requirements

Run Phase 1 only. Read the `sdlc-artifacts` skill for conventions.

1. If `$ARGUMENTS` is a new request, slugify it and ensure `docs/sdlc/<slug>/00-manifest.md` exists (create per sdlc-artifacts). If it's an existing slug, read that manifest to resume.
2. Apply `capability-discovery` + `stack-detection`.
3. Dispatch the `requirements-analyst` agent (via the Agent tool, no model override) with the request + stack profile.
4. Relay any `QUESTIONS FOR USER` with AskUserQuestion; resume the same agent (SendMessage) with answers until `NO QUESTIONS`.
5. Present `01-requirements.md` and update the manifest. (This command stops after requirements; use /sdlc for the full gated pipeline.)
