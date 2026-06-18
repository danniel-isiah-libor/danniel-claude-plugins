---
description: Run the optional Docs phase — dispatches the tech-writer to update README/API docs/changelog and write 06-docs.md.
argument-hint: <feature slug>
---

# /sdlc-docs

Run Phase 6 only.

1. Read `docs/sdlc/<slug>/` for the slug in `$ARGUMENTS` (if none, list slugs and ask).
2. Apply `capability-discovery` + `stack-detection`.
3. Dispatch the `tech-writer` agent with `01`/`02`/`03` + the diff.
4. Relay `QUESTIONS FOR USER`; resume the same agent until `NO QUESTIONS`.
5. Present `06-docs.md`; update the manifest.
