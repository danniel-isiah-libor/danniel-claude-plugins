---
name: git-conventions
description: Apply Conventional Commits 1.0.0 and Conventional Branch 1.0.0 — consistent commit messages and branch names — and derive semantic versions from them for tags and releases. Use when committing, creating or naming branches, or tagging/releasing. Used by the fullstack-developer (commits/branches) and the devops-engineer (branches, tags, releases).
---

# Git Conventions

Run `project-adaptation` first — if the project already defines commit/branch rules (`CLAUDE.md`, commitlint, a CONTRIBUTING guide), follow those; these are the defaults otherwise.

## Conventional Commits (1.0.0)
Format: `type(scope)?: description` — imperative mood, lowercase, no trailing period; keep the subject ≤ ~72 chars.

Types: `feat` (new feature), `fix` (bug fix), `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`.

- **Scope** (optional): the area touched, e.g. `feat(auth): add SSO login`.
- **Breaking change:** add `!` before the colon (`feat!:`) and/or a `BREAKING CHANGE:` footer describing it.
- **Body** (optional): what & why, after a blank line. **Footers:** `Refs: #123`, `Co-authored-by:`, etc.

## Conventional Branch (1.0.0)
Format: `type/short-description` — lowercase, hyphen-separated (kebab-case), no spaces.

Prefixes: `feature/`, `bugfix/`, `hotfix/`, `release/`, `chore/` (plus `docs/`, `test/` as needed). Optionally include a ticket id: `feature/PROJ-123-add-login`.

**Match the repo.** If existing branches already use a variant — notably `fix/` instead of `bugfix/` (the `claude-sdlc-team` plugin uses `feature/ fix/ chore/`) — keep using it; consistency within a repo beats the spec's spelling. Never mix both in one repo.

Never commit straight to protected branches (`main`, `development`/`staging`) — branch, then open a PR/MR.

## Pull / merge requests
- One logical change per PR/MR; the **title is a Conventional Commit** (it becomes the squash/merge subject, which drives the version bump).
- Description: what and why, how it was tested, risk/rollback notes, linked issue (`Refs #123` / `Closes #123`), screenshots for UI changes, and any breaking-change or migration steps.
- Keep the branch current with its base (rebase or merge per the project's convention); resolve conflicts yourself, never force-resolve silently.
- Don't merge with failing required checks; don't merge your own PR where review is required. Delete the source branch after merge if it isn't protected.
- Never commit, push, or open a PR unless asked; confirm before any push.

## Reverts & hotfixes
- **Revert:** `git revert <sha>` (never rewrite shared history) with a commit `revert: <original subject>` and a body naming the reverted SHA and the reason. Reverting a merge: `git revert -m 1 <merge-sha>`.
- **Hotfix:** branch `hotfix/<short-description>` from the production branch (`main`), fix + test, PR into `main`, tag a **patch** release, then merge/cherry-pick the fix back into the integration branch (`development`) so it isn't lost. Hotfixes still pass the manual-approval gate for prod.

## Semantic versioning (for tags & releases)
Derive the next version from the commits since the last tag:
- `fix:` → **patch** (`x.y.Z`); `feat:` → **minor** (`x.Y.0`); a breaking change → **major** (`X.0.0`).
- Tags are `vX.Y.Z`. **UAT/pre-release** tags use a suffix (e.g. `vX.Y.Z-rc.1`); **production** uses the final `vX.Y.Z`.

The devops-engineer applies these in the pipeline — see `gcp-devops` → `references/docker-and-cicd.md` for how tags, releases, and the mandatory manual-approval gates work.
