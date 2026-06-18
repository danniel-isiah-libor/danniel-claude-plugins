---
name: release-management
description: Manage versioning and release communication. Use when cutting a release — semantic-versioning decisions, changelog entries, and release notes. Used by the release-engineer.
---

# Release Management

## Semantic Versioning (MAJOR.MINOR.PATCH)
MAJOR = breaking changes; MINOR = backward-compatible features; PATCH = backward-compatible fixes. Pre-1.0, expect churn.

## Changelog (Keep a Changelog style)
Group entries under Added / Changed / Deprecated / Removed / Fixed / Security. Link issues/PRs. Keep it human-readable.

## Release notes
Lead with user-facing impact; call out breaking changes + migration steps; credit contributors.

## Conventional commits → version
Derive the bump from commit types (`feat` → minor, `fix` → patch, `!`/`BREAKING CHANGE` → major). Coordinate with `git-conventions`.

## Git tagging & versioning (production deploys)
The version is **proper** — visible in the app, not a floating label. Source of truth is the
project's native manifest, bumped during the release phase and committed so it travels with the code.

### Tag format
Annotated tags named `vMAJOR.MINOR.PATCH` (e.g. `v1.4.0`), one per released version. Tags are created
**only by the production deploy on `main`** — never hand-cut, never on `development`/`staging`.

### Deriving the next version (from Conventional Commits)
Scan commits since the last tag (or from the repo root if no tag exists):
- any `!` / `BREAKING CHANGE` → **MAJOR**
- else any `feat` → **MINOR**
- else (`fix`, others) → **PATCH**

**Pre-1.0 churn (while the current version is `0.y.z`):**
- breaking change → bump **MINOR** (`0.y.z` → `0.(y+1).0`), not MAJOR
- feature → bump **PATCH** (`0.y.z` → `0.y.(z+1)`)

No prior tag anywhere → first version is **`v0.1.0`**. The proposed bump is always confirmable or
overridable by the human (it is surfaced as a `QUESTIONS FOR USER` item by the release-engineer).

**Worked examples.**
- Last tag `v0.3.1`; commits since: `feat: add filters`, `fix: null guard`. Highest type = `feat`;
  pre-1.0 → feature is a PATCH bump → **`v0.3.2`**.
- Same, but one commit is `feat!: drop legacy endpoint` (breaking) while on 0.x → MINOR bump → **`v0.4.0`**.
- Post-1.0: last tag `v1.3.1`, a `feat` present → MINOR bump → **`v1.4.0`**.

### Idempotent tagging
The deploy tags `v<version>` only if that tag does not already exist (`git tag -l`). Re-deploying the
same version is a no-op; a deploy after a version bump cuts the new tag. Pair the tag with a Release
on the project's forge whose notes come from the matching `CHANGELOG.md` section.

### Git host / forge (GitHub is the default — don't assume it)
The annotated `git tag` is forge-neutral. Only the **Release** object and CI wrapper are forge-specific:
**GitHub is the default** (GitHub Actions + `gh release create`). If the git remote is a GitLab host,
use the GitLab equivalent (GitLab CI + `glab release create` / Releases API) instead — the tag step
and idempotency are identical. Detect the forge from the remote during `stack-detection`; fall back to
GitHub when the forge is unknown.
