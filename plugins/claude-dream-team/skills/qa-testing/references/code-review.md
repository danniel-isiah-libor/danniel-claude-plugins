# Code Review + Fix Routing

Review **uncommitted changes** (`git diff` + untracked) or a **PR/MR** (fetch its diff). Be comprehensive, but report only what matters.

## Checklist
- **Correctness & resilience:** logic, edge cases, error handling (no swallowed errors, resources cleaned up), **transaction boundaries** (atomic multi-step writes, rollback on failure), race conditions, and **idempotency** where retries or duplicate delivery are possible; does it meet the intent / acceptance criteria?
- **Conflicts/integration:** merge conflicts, breaking changes to callers/contracts/APIs, migration safety.
- **Standards:** SOLID/DRY/KISS/YAGNI, project conventions & `CLAUDE.md`, naming/structure; **no deprecated APIs**; no dead or duplicated code.
- **Security:** input validation, authorization, secrets, injection/XSS surfaces (cross-reference `security-testing.md`).
- **Performance:** obvious hotspots, N+1 queries, unnecessary work, missing indexes.
- **Tests:** present, meaningful, and covering the new scenarios.
- **UX (if UI):** matches the design system (palette/icons/tokens), responsive/cross-platform, accessible.

## Severity
`blocker` (must fix before merge) · `major` (should fix) · `minor` · `nit`. Only blockers and majors gate the verdict.

## Routing protocol
Tag every finding with its owner:
- **`[fullstack-developer]`** — application code, logic, API contracts, database schema, UI/UX, merge conflicts, tests.
- **`[devops-engineer]`** — Dockerfiles/compose, CI/CD config, GCP infra/IaC, IAM, deploy/release, image/build issues.

Output a **routed action list**: for each owner, the findings to fix (severity, location, repro, recommended fix). The main session dispatches each owner agent; after fixes, QA re-verifies. Loop until no blockers or majors remain.

> `/dream-team-review` runs this loop automatically.
