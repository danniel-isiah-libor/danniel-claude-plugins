---
description: Run the parallel inspection quintet (QA + code review + security + CI/CD pipeline + E2E video) on the current feature's changes and merge findings into one issue list.
argument-hint: <feature slug>
---

# /sdlc-inspect

Run Phase 4 only. Requires an implemented feature.

1. Read `docs/sdlc/<slug>/` (`00-manifest.md`, `01`, `02`, `03`) for the slug in `$ARGUMENTS` (if none, list slugs under docs/sdlc/ and ask). If `03-implementation.md` is missing, tell the user to run /sdlc-implement first.
2. Apply `capability-discovery` + `stack-detection`.
3. Dispatch `qa-tester`, `code-reviewer`, `security-reviewer`, `pipeline-reviewer`, and `e2e-tester` IN PARALLEL (multiple Agent calls in one turn) with the design + diff. Never pass a model override. The `pipeline-reviewer` no-ops if no CI/CD config exists; the `e2e-tester` no-ops if there is no web UI (and asks before installing Playwright).
4. Merge their findings (`04a`/`04b`/`04c`/`04d`/`04e`) into one deduplicated, severity-sorted issue list.
5. Relay any `QUESTIONS FOR USER`; resume the relevant agent until `NO QUESTIONS`.
6. Present the merged issue list and update the manifest. (Fixing is the implementer's job via /sdlc-implement or the full /sdlc fix loop.)
