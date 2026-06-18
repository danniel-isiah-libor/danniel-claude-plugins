---
description: Diagnose a failing CI/CD run and, if the cause is pipeline config, patch + re-run until green (gated). Routes code/test failures to /sdlc-implement; infra failures to a re-run.
argument-hint: <run-url-or-id | "latest">
---

# /sdlc-fix-ci

Operational — runs OUTSIDE the gated pipeline. Repairs **pipeline config only**; never touches `main`, never deploys, confirms every push.

1. Resolve the run from `$ARGUMENTS` (a run URL/ID, or "latest"/empty → the most recent failing run). Apply `stack-detection` for the forge (GitHub default; GitLab if the remote is a GitLab host).
2. Apply `cicd-failure-diagnosis` to fetch the failed-step logs: `gh run view <id> --log-failed` (GitHub) / `glab ci` (GitLab). If neither CLI is installed/authed, ask the user to paste the failing log.
3. Dispatch the `ci-doctor` agent with the logs + the repo's pipeline config. Relay any `QUESTIONS FOR USER`; resume it until `NO QUESTIONS`.
4. Act on `CLASSIFICATION`:
   - **config** → show the prescribed patch; **AskUserQuestion to confirm**. On confirm: apply it, commit on the current feature/fix branch (NEVER `main`), push (confirmed) so a fresh run triggers (or manually dispatch the workflow if CI is not push-triggered), then poll the new run (`gh run watch` / `glab ci view`) until it completes.
     - green → report what was fixed + the attempt count; stop.
     - still red → re-dispatch `ci-doctor` with the NEW logs; repeat under `LOOP-GUARD(3)` (`sdlc-gates`): after 3 attempts without green, ask the user to continue another attempt / hand off / stop.
   - **code-test** → do NOT edit app code. Tell the user to run `/sdlc-implement`, passing along the failing test/error from the diagnosis.
   - **infra** → recommend `gh run rerun <id>` / `glab ci retry` of the same commit (confirmed); no patch.
5. Never push to `main`; never deploy; confirm every remote action. If a slug context exists, note the repair under Decisions in `docs/sdlc/<slug>/00-manifest.md`.
