---
description: Show SDLC progress — prints the manifest(s) under docs/sdlc/ (current phase, gate status, open questions) and the Notion ticket link if enabled.
argument-hint: "[feature slug]"
---

# /sdlc-status

1. If `$ARGUMENTS` names a slug, read `docs/sdlc/<slug>/00-manifest.md` and print: request, current phase, status, phase log, decisions, and open questions.
2. If no slug, list every folder under `docs/sdlc/` with each one's current phase + status (one line each), so the user sees all features at a glance.
3. If `.sdlc/notion.json` has `enabled: true`, also print the Notion ticket/board link from the manifest.
4. Read-only — never modify artifacts.
