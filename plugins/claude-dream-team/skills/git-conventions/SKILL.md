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

Never commit straight to protected branches (`main`, `development`/`staging`) — branch, then open a PR/MR.

## Semantic versioning (for tags & releases)
Derive the next version from the commits since the last tag:
- `fix:` → **patch** (`x.y.Z`); `feat:` → **minor** (`x.Y.0`); a breaking change → **major** (`X.0.0`).
- Tags are `vX.Y.Z`. **UAT/pre-release** tags use a suffix (e.g. `vX.Y.Z-rc.1`); **production** uses the final `vX.Y.Z`.

The devops-engineer applies these in the pipeline — see `gcp-devops` → `references/docker-and-cicd.md` for how tags, releases, and the mandatory manual-approval gates work.
