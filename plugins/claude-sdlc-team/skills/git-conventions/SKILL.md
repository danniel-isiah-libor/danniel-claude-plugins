---
name: git-conventions
description: Apply Conventional Commits and Conventional Branch naming, the three-tier branch model, the per-task branch workflow, and the promotion policy (every stage merge goes through a PR/MR; merged non-protected branches are deleted, the protected main/staging/development are not). Use when committing, creating branches, bootstrapping a repo's branch model, promoting between stages, starting work on a new feature/fix, or running multiple tickets in parallel via git worktrees. Backs /sdlc-init and the orchestrator's per-task branching.
---

# Git Conventions

## Conventional Commits
`<type>(<optional scope>): <description>`
Types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`.
- Imperative, lowercase, no trailing period in the subject.
- Breaking change: `feat!:` or a `BREAKING CHANGE:` footer.
- Body explains *why*; footers carry metadata (e.g. `Refs #123`).

## Conventional Branches
`<type>/<short-kebab-description>` — e.g. `feature/password-reset`, `fix/login-redirect`, `chore/bump-deps`.
Prefixes: `feature`, `fix`, `chore`, `docs`, `refactor`, `release`, `hotfix`.

## Three-tier model (used by /sdlc-init)
`main` (production) ← `staging` (pre-prod/QA) ← `development` (integration). Feature branches cut from `development`; promote development → staging → main.

## Promotion policy — always via PR/MR + branch cleanup
Applies to **every** merge into a stage branch (`development`, `staging`, `main`):
1. **Always open a PR/MR first** — never push or merge directly into a stage branch when a remote exists. Each promotion (`<type>/<slug> → development`, `development → staging`, `staging → main`) goes through a PR/MR. *No remote?* PRs need a remote, so fall back to a local `git merge --no-ff` — the only case where a stage branch is merged without a PR.
2. **Protected branches — never deleted:** `main`, `staging`, `development`. Promotions between tiers therefore never delete their source branch.
3. **Delete the source branch once merged, if it is not protected** — `feature/*`, `fix/*`, `chore/*`, `docs/*`, `refactor/*`, `hotfix/*`, `release/*`. GitHub: merge with `--delete-branch`; local fallback: `git branch -d <branch>` after a successful merge. Never delete a branch whose PR is still open or whose merge hit conflicts / red required checks.

## Per-task branch workflow (used by the /sdlc orchestrator, Phase 0)
Every new task (feature or bugfix) gets its own branch cut from `development`. To reduce merge conflicts, sync `development` proactively — before AND after creating the branch:
1. Determine task type: `feature`, `fix`, or `chore` (infer from the request; ask if unclear).
2. **Before:** `git checkout development` then pull the latest (`git pull --ff-only` if a remote/upstream exists; skip silently if no remote).
3. Create the task branch: `git checkout -b <type>/<slug>` (e.g. `feature/add-password-reset`).
4. **After:** re-sync `development` into the task branch (`git merge development`), and do so again before the work is integrated, so the branch stays current.
5. Surface merge conflicts to the user — never force-resolve. Never force-push. No push without explicit confirmation.

**Running tickets in parallel?** Don't `git checkout development` here — use the worktree-per-ticket variant below instead.

## Parallel work — one git worktree per ticket (opt-in)
Run multiple tickets concurrently by giving each its own **worktree** (a separate working directory that shares the one `.git`) and its own Claude session. A worktree isolates the checked-out branch, the index, and uncommitted files, so parallel sessions never clobber each other — unlike multiple sessions in a single checkout, which share one global branch pointer and working tree. Use when 2+ tickets are in flight at once; for one ticket at a time, stay in the main checkout (Phase 0 above).

**Key constraint:** a branch can be checked out in only **one** worktree at a time. Keep the protected branches (`development`, `staging`, `main`) in the **main checkout** only — feature worktrees must never `git checkout development`. This is why Phase 0's `git checkout development && git pull` is replaced below.

**Create a ticket worktree** (replaces Phase 0 steps 2–3 in parallel mode):
1. `git fetch origin` (skip if no remote) — refresh refs without checking out `development`.
2. `git worktree add -b <type>/<slug> ../<repo>-<slug> origin/development` — branch cut from the latest integration base into a sibling directory. No remote: branch from `development` instead of `origin/development`.
3. Run one Claude session per worktree directory; one ticket per worktree.

**Re-sync** (Phase 0 step 4 / before integration): from inside the worktree, `git fetch origin && git merge origin/development` (no remote: `git merge development`). `git merge` consumes a ref and needs nothing checked out, so it works while `development` lives in another worktree. Surface conflicts; never force-resolve.

**Integrate (Gate ③):** the PR-based path is unchanged — PRs operate on pushed refs, not your local checkout, so auto-integration works as-is from a worktree. Only the **no-remote** fallback differs: run `git merge --no-ff <type>/<slug>` from the **main checkout** (which holds `development`), never from the feature worktree.

**Cleanup:** once the merged branch is deleted (promotion policy #3), remove its worktree — `git worktree remove ../<repo>-<slug>` then `git worktree prune`.

**Worktrees isolate files, not runtime.** Each worktree starts with no `node_modules`/venv and shares nothing at runtime — install dependencies per worktree, give each session its own dev/test **port** and its own test DB/schema, and copy any git-ignored `.env` into each. Otherwise parallel sessions collide on ports/data even though their files are isolated.

**Ceiling:** real parallelism is bounded by how many approval gates a human can clear and how many full stacks the machine can host at once — not by git. Size the number of active worktrees to both.

## Auto-integration (post Gate ③)
When the orchestrator's Gate ③ passes, integrate the task branch into `development` automatically — unless `.sdlc/config.json` sets `{ "autoIntegrate": false }`:
1. Re-sync: `git checkout <type>/<slug>` then `git merge development`. Surface conflicts to the user; never force-resolve.
2. GitHub: `gh pr create -B development -H <type>/<slug> -t "<type>: <slug>" -b "<summary>"` then `gh pr merge --merge --delete-branch` (use `--auto` when branch protection runs required checks). GitLab: the `glab mr create` / `glab mr merge` equivalents. No remote: `git checkout development && git merge --no-ff <type>/<slug>`, then delete the merged branch with `git branch -d <type>/<slug>` (promotion policy #3). In worktree mode, run this no-remote merge from the **main checkout** (it holds `development`), not the feature worktree.
3. On a merge conflict or a red **required** check: leave the PR open, notify the user, and continue — never force-merge or force-push. (Do not delete a branch whose PR is still open.)
4. Record the PR URL on the Notion ticket's `PR` field (if Notion is enabled).

## Staging promotion (at sprint close)
When `/sdlc-sprint close` runs, promote the sprint's integrated features to staging for UAT:
1. Open and auto-merge a PR `development → staging` (promotion policy — always via PR/MR). `development` is protected, so it is **not** deleted.
2. Trigger the staging deploy for UAT (manual-trigger). **No version bump, no tag, no `main`.**

## Production release (separate, after UAT)
When `/sdlc-release` runs — only when no sprint is Active and UAT on staging has passed:
1. Open a PR `staging → main` (promotion policy — always via PR/MR) — **do not merge it automatically**. `staging` is protected, so it is **not** deleted.
2. `release-engineer` produces the version bump + changelog + prod deploy config.
3. **Gate ④:** only after explicit user confirmation, merge `staging → main`; the production deploy is manual-trigger and cuts the annotated `vX.Y.Z` tag (see `release-management`, `devops-gcp`).
4. **Publish the forge Release.** A pushed tag alone does **not** appear on the Releases page (it lands under *Tags*), so the latest version can look stale. When a CI deploy job exists it publishes the Release (`devops-gcp`). When there is **no** deploy job (a docs/library/plugin repo with nothing to deploy), publish it manually right after pushing the tag: `gh release create vX.Y.Z --title "vX.Y.Z — <summary>" --notes "<CHANGELOG section>" --latest` (GitLab: `glab release create`). Idempotent — skip if the Release already exists (`gh release view vX.Y.Z`); skip silently when there is no remote or no forge CLI.
Never auto-merge to `main` or trigger a deploy without confirmation.

## Tags & versions
Released versions are annotated tags `vMAJOR.MINOR.PATCH` on `main`, created by the **production
deploy** (see `release-management` and `devops-gcp`) — not hand-cut. The tag's version is derived
from commit types the same way a release bump is (`feat`→minor, `fix`→patch, `!`/`BREAKING CHANGE`→major;
pre-1.0 churns the minor/patch instead).

Every tag is **paired with a published forge Release** (GitHub/GitLab) whose notes come from the
matching `CHANGELOG.md` section — the CI deploy job publishes it, or it is published manually at Gate ④
when there is no deploy job (see Production release step 4). A tag without a Release does not show on
the Releases page, so the version there looks stale.
