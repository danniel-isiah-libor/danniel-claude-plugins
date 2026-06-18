---
description: Run the production-release step — promote staging → main after UAT, dispatch the release-engineer for versioning + changelog + prod deploy config, tag, and deploy (Gate ④). Refuses while a sprint is Active.
argument-hint: <feature slug>
---

# /sdlc-release

Production release (Phase 5). Run this **after** the sprint's features have been promoted to staging (via `/sdlc-sprint close`) and UAT has passed.

1. Read `docs/sdlc/<slug>/` for the slug in `$ARGUMENTS` (if none, list slugs and ask). Confirm review passed (`04*` present / Gate ③) — if not, warn the user.
2. **Release-when-not-active `PRECONDITION`** (`sdlc-gates`): if `.sdlc/notion.json` is `enabled: true` and a sprint is currently `Active`, warn that production release happens only after the sprint is closed and UAT'd on staging, then **stop** unless the user explicitly overrides. (No sprint, or Notion disabled → continue.)
3. Apply `capability-discovery` + `stack-detection`.
4. Dispatch the `release-engineer` agent with the prior artifacts + diff (version bump, changelog, prod deploy config, self-audit).
5. Relay `QUESTIONS FOR USER`; resume the same agent until `NO QUESTIONS`.
6. Apply `git-conventions` **production release**: open a PR `staging → main`. Present `05-release.md`; update the manifest. NEVER merge to `main`, tag, or deploy without explicit user confirmation — run `GATE` (`sdlc-gates`) for Gate ④; the production deploy cuts the `vX.Y.Z` tag.
