---
description: Run the dream-team review loop — QA reviews & tests the change, routes fixes to the dev/devops/QA owners, and re-verifies the listed findings until clean.
argument-hint: "[uncommitted | <PR/MR number or URL> | <path>] [--quick | --security]"
allowed-tools: Read, Grep, Glob, Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git ls-files:*), Bash(git show:*), Bash(git rev-parse:*), Bash(gh pr diff:*), Bash(gh pr view:*)
---

# /dream-team-review

Orchestrate the claude-dream-team review → fix → verify loop over a change. You are a pure router: dispatch agents with the Agent tool, relay their results, and never do their work inline.

## Arguments
`$ARGUMENTS` holds a **target** and optional **scope flags** (in any order).

**Target**
- empty or `uncommitted` → the working tree's uncommitted changes (`git diff` + untracked files from `git ls-files --others --exclude-standard`).
- a PR/MR number or URL → fetch that PR/MR's diff (`gh pr diff`, or the platform's API).
- a path → review changes under that path.

If the target is ambiguous, or empty with a clean tree, ask the user what to review.

**Scope flags**
- *(none)* — full QA pass: unit, E2E and security testing where applicable, plus code review.
- `--quick` — unit tests + code review only; skip E2E and active security testing.
- `--security` — security testing + code review only, and always include the `security-analyst`.

Pass the chosen scope to `qa-engineer` verbatim so it reports skipped areas as `NOT RUN` (never as PASS).

## Loop (max 3 iterations, then report and ask)

1. **Review + test.** Dispatch `qa-engineer` on the target with the scope. It must answer in the format of `qa-testing` → `references/report-contract.md`.
   - **Dependency check (iteration 1 only).** If the diff touches a dependency manifest/lockfile (`package.json`, `package-lock.json`, `composer.json/.lock`, `requirements*.txt`, `poetry.lock`, `go.mod/.sum`, `Cargo.toml/.lock`, `Gemfile*`) or a `Dockerfile`/CI base image — or `--security` was passed — also dispatch the read-only `security-analyst` in parallel and merge its routed items into the findings list, assigning IDs continuing the QA sequence.
2. **Verdict.** Read the `VERDICT:` line and findings table. If there are no open `blocker` or `major` findings → stop and report **PASS** with the full QA report. If the report is not in the contract format, ask `qa-engineer` to restate it before continuing.
3. **Route + fix.** Group open blocker/major findings by owner tag and give each agent only its own findings (ID, severity, repro, recommended fix) and the relevant files:
   - `[fullstack-developer]` → application code, schema, UI.
   - `[devops-engineer]` → Dockerfiles, CI/CD, infra, IAM.
   - `[qa-engineer]` → missing/flaky/outdated tests (QA is the only agent that writes tests).
   
   **Ordering:** dispatch `fullstack-developer` and `devops-engineer` in parallel **only if** their file sets are disjoint; if they touch the same files, run them sequentially (developer first). Run `[qa-engineer]` test fixes **after** code fixes land, since tests target the updated behavior.
4. **Re-verify.** Re-dispatch `qa-engineer` with the list of finding IDs, asking for a `## Re-verification` table (`FIXED` / `STILL OPEN` / `REGRESSION`) and a re-run of only the touched scope. Go back to step 2.
5. After 3 iterations with blocker/major findings still open, stop and report what's left for the user to decide.

## Rules
- Apply fixes to the **working tree only**. Do not commit, push, deploy, or merge — leave that to the user.
- Preserve each agent's boundaries (e.g. the devops-engineer confirms before destructive infra actions; the qa-engineer edits test files only; the security-analyst never edits).
- Relay any question an agent asks the user; don't guess answers.
- Final output: the latest `VERDICT`, a per-iteration list of what each agent changed (by finding ID), the Re-verification table, and any unresolved findings.
