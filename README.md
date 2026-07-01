# danniel-claude-plugins

Danniel Libor's collection of [Claude Code](https://claude.com/claude-code) plugins.

## Plugins

| Plugin | What it is |
|--------|-----------|
| [`claude-dream-team`](./plugins/claude-dream-team) | A summonable roster of senior expert agents (DevOps, fullstack, QA, technical writer) + skills + the `/dream-team-review` loop |
| [`claude-sdlc-team`](./plugins/claude-sdlc-team) | A gated, end-to-end agentic SDLC pipeline (requirements → … → release → docs) with optional Notion Scrum sync |
| [`obsidian-vault-keeper`](./plugins/obsidian-vault-keeper) | An active Obsidian vault steward — the `vault-keeper` agent maintains a vault to best practices via the Obsidian MCP (filesystem fallback): PARA filing, MOC build/refresh, broken-link and orphan fixes, frontmatter normalization, safe dedupe/rename — plus the `obsidian-vault` skill and a `/vault-checkup` health-sweep command |

### claude-dream-team

A summonable **dream team** of senior expert agents. They're stack-agnostic and built to **compose with each project** — they read your `CLAUDE.md`, prefer your project-local skills and agents, and follow your conventions. (Their own skills are coming later and will layer on top, never override, your project setup.)

| Agent | Role | Owns |
|-------|------|------|
| `devops-engineer` | Senior DevOps Engineer | Docker (cross-platform local + staging/prod), industry-standard CI/CD, and GCP infrastructure (Cloud Run, Cloud SQL, Cloud Storage, Artifact Registry, IAM/Workload Identity, networking) — always optimizing for speed, lightweight footprint, scalability, cost-efficiency, and security |
| `fullstack-developer` | Senior Fullstack Developer | End-to-end implementation with SOLID/DRY/KISS/YAGNI, security-first & no deprecated APIs, docs-first reuse, cross-platform UI/UX with a uniform design system, and database schema design |
| `qa-engineer` | Senior QA Engineer | Unit tests (all scenarios), Playwright E2E, VAPT/security testing (XSS, SQLi, …), and comprehensive code review — routing fixes back to the dev/devops agents |
| `technical-writer` | Senior Technical Writer | Audience-facing documentation for clients/users/stakeholders — user guides, how-to/getting-started guides, feature docs, FAQs, and release notes |

### Skills

Skills are token-optimized via *progressive disclosure*: only their short descriptions sit in context until a skill is invoked; deeper material lives in `references/` that loads on demand.

| Skill | Used by | Covers |
|-------|---------|--------|
| `project-adaptation` | **all 4** | Detect the stack, honor `CLAUDE.md`/conventions, reuse the project's skills & agents; adapt to existing repos, not just fresh ones (the project wins on conflict) |
| `gcp-devops` | devops-engineer | Docker + cross-platform local dev, industry-standard CI/CD (**mandatory manual-approval gate + git tags/releases for UAT & prod**), GCP services — judged on speed/lightweight/scalability/cost/security |
| `senior-development` | fullstack-developer | SOLID/DRY/KISS/YAGNI, security-first, robust error handling (DB transactions/rollback), idempotency where needed, no deprecated APIs, docs-first reuse, cross-platform UI/UX + design system, database design |
| `qa-testing` | qa-engineer | Unit coverage, Playwright E2E, VAPT/security testing, code review + fix routing |
| `git-conventions` | dev & devops | Conventional Commits 1.0.0 + Conventional Branch 1.0.0, and semver derivation for tags & releases |
| `documentation` | technical-writer | Audience-first docs — user guides, how-to/getting-started, feature docs, FAQs, release notes (Diátaxis types, with outlines) |
| `obsidian-conventions` | technical-writer | A writer's primer for docs that live in an Obsidian vault — Obsidian-flavored Markdown (wikilinks/embeds/callouts/properties), the official Obsidian style guide, and link-safe editing (vault organization and stewardship now live in the `obsidian-vault-keeper` plugin) |

### Commands

| Command | Does |
|---------|------|
| `/dream-team-review [uncommitted \| <PR/MR> \| <path>]` | Runs the QA review/test pass, routes findings to the `fullstack-developer` / `devops-engineer` agents to fix, and re-verifies — looping until clean (working-tree changes only; never commits/pushes) |

### claude-sdlc-team

A gated, end-to-end **agentic SDLC pipeline** — requirements → design → implementation → parallel QA / code-review / security / pipeline-audit → release → docs — driven by a pure-router orchestrator with stack-agnostic agents and an opinionated skill library. Per-feature auto-merge to `development`, sprint close → `staging` for UAT, a separate production release to `main` with semver tagging, `/sdlc-fix-ci` pipeline repair, a Playwright E2E review-video gate, and optional per-project **Notion** Scrum boards (backlog + sprints). 11 agents · 14 commands · 26 skills. See [`plugins/claude-sdlc-team/README.md`](./plugins/claude-sdlc-team/README.md).

### obsidian-vault-keeper

An active Obsidian **vault steward** — the `vault-keeper` agent maintains a vault to best practices via the Obsidian MCP (filesystem fallback): PARA filing, MOC build/refresh, broken-link and orphan fixes, frontmatter normalization, and safe dedupe/rename. Includes the `obsidian-vault` skill and a `/vault-checkup` health-sweep command that reports findings and offers to fix. See [`plugins/obsidian-vault-keeper/README.md`](./plugins/obsidian-vault-keeper/README.md).

## Install

Add the marketplace, then install whichever plugin(s) you want:

```
/plugin marketplace add danniel-isiah-libor/danniel-claude-plugins
/plugin install claude-dream-team@danniel-claude-plugins
/plugin install claude-sdlc-team@danniel-claude-plugins
/plugin install obsidian-vault-keeper@danniel-claude-plugins
```

> Replace the marketplace source with your Git remote (or a local path while developing, e.g. `/plugin marketplace add /path/to/danniel-claude-plugins`).

Once installed, the dream-team's four agents are available to summon — Claude routes to the right one automatically, or you can call one by name (e.g. "use the devops-engineer agent to …"). The claude-sdlc-team is driven through its slash commands (start with `/sdlc`). The obsidian-vault-keeper's `vault-keeper` agent can be summoned directly, or triggered via `/vault-checkup`.

## Roadmap

- Expand the `references/` playbooks (more GCP services, framework-specific UI/UX, language-specific security testing).
- Optional per-project agent memory (with a session-start load hook).

## License

[MIT](./LICENSE) © 2026 Danniel Libor
