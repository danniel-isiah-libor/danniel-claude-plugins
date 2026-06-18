# claude-sdlc-team

An agentic software-development team for Claude Code: a gated SDLC pipeline
(requirements → design → implementation → testing → review → security → release → docs)
driven by a pure-router orchestrator, stack-agnostic agents, and an opinionated skill library —
with an optional, Jira-style Notion board (backlog + sprints) mirroring the whole flow.

> **Status:** v1.7.2 — full pipeline + Jira-Scrum Notion sync. Phases 0–6 (requirements → design →
> implementation → parallel QA/code-review/security/pipeline-audit → release → docs), per-feature
> auto-merge to `development` after review, sprint close → `staging` for UAT with a separate
> production release to `main`, git tagging + semver on production deploys, `/sdlc-fix-ci` runtime
> pipeline repair, the `/sdlc-init` branch bootstrap, per-phase commands, opt-in parallel tickets
> via git worktrees, and optional per-project Notion Scrum boards (backlog + sprints).

## Install

```
/plugin marketplace add danniel-isiah-libor/danniel-claude-plugins
/plugin install claude-sdlc-team@danniel-claude-plugins
```

## Commands

Fourteen slash commands. The full pipeline (`/sdlc`) is the front door; everything else lets you
drive one phase, plan and manage Scrum sprints, run E2E recordings, or check status. Notion-related commands no-op gracefully
when Notion is disabled.

### Setup & full pipeline

| Command | Arguments | What it does |
|---|---|---|
| `/sdlc-init` | — | Bootstrap the three-tier branch model (`main`/`staging`/`development`) and, optionally, enable Notion sync (Projects registry + this project's own hub page holding its Tickets board + Sprints table). |
| `/sdlc <request>` | feature/fix request | Run the **full gated pipeline** end-to-end (Phases 0–6): requirements → design → implementation → parallel inspection → release → docs, pausing at each approval gate. |

### Per-phase — run or re-run a single phase

| Command | Arguments | What it does |
|---|---|---|
| `/sdlc-requirements` | request or slug | **Phase 1** — `requirements-analyst` produces `01-requirements.md` (user stories + Given/When/Then acceptance criteria). |
| `/sdlc-design` | feature slug | **Phase 2** — `solution-architect` produces `02-design.md` (components, data model, interfaces, test strategy). |
| `/sdlc-implement` | feature slug | **Phase 3** — `implementer` builds the approved design with tests and writes `03-implementation.md`. |
| `/sdlc-inspect` | feature slug | **Phase 4** — runs the QA + code-review + security + CI/CD-pipeline + E2E quintet in parallel and merges findings into one severity-sorted list. |
| `/sdlc-e2e` | feature slug | **Phase 4 (E2E)** — `e2e-tester` drives the running app via Playwright and records a review video (with a visible mouse cursor, not screenshots) to `docs/sdlc/<slug>/e2e-recordings/` (no-ops without a web UI). |
| `/sdlc-release` | feature slug | **Phase 5** — post-UAT production release: promote `staging → main`, version + changelog + `vX.Y.Z` tag + deploy (Gate ④). Refuses while a sprint is Active. |
| `/sdlc-docs` | feature slug | **Phase 6** — `tech-writer` updates README/API docs/changelog and writes `06-docs.md`. |

### Scrum & Notion (optional)

| Command | Arguments | What it does |
|---|---|---|
| `/sdlc-backlog` | `"<requirement>" [--type feature\|fix\|chore] [--priority low\|medium\|high\|urgent]` | Capture a new requirement into the project's Notion **Backlog** (no sprint, no pipeline run). |
| `/sdlc-plan` | `["<sprint>"] [--revisit] [--ticket "<title-or-id>"]` | **Sprint planning** — collaboratively refine each candidate ticket in a Planned sprint to the Definition of Ready (scope, acceptance, type, priority, estimate), write it to Notion, and mark it `Ready`. Gates `/sdlc-sprint start`. |
| `/sdlc-sprint` | `<new\|add\|move\|start\|close\|list> [args]` | Manage sprints Jira-style: create one, pull backlog tickets in, `start` it (gated on planning; its tickets become the active board), `close` it (review/retro + promotes Done features to `staging` for UAT). |
| `/sdlc-sync` | `[feature slug]` | Mirror the current feature's artifacts + board status to the project's Notion board. Idempotent and non-blocking. |

### Status & ops

| Command | Arguments | What it does |
|---|---|---|
| `/sdlc-status` | `[feature slug]` | Show progress for one feature, or a one-line summary of every feature under `docs/sdlc/`. Read-only. |
| `/sdlc-fix-ci` | `<run-url-or-id \| "latest">` | Diagnose a failing CI/CD run and, if the cause is pipeline config, patch + re-run until green (gated). Routes code/test failures to `/sdlc-implement`. |

## Usage

### 1. Bootstrap a repo
```
/sdlc-init
```
Sets up the `main` / `staging` / `development` branch model and (optionally) wires up Notion: a shared **Projects** registry plus this project's own **hub page** (a Notion page under a parent you pick) holding its **Tickets** board and **Sprints** table.

### 2. Build a feature (local-only, no Notion)
```
/sdlc Add password reset via email
```
Runs the full gated pipeline — requirements → design → implementation → parallel inspection (QA + code review + security + CI/CD) → optional release → optional docs. You approve at each gate; agents ask questions instead of guessing. Artifacts land under `docs/sdlc/<slug>/`. On inspection sign-off (Gate ③) the feature auto-merges into `development` (disable with `.sdlc/config.json` `{"autoIntegrate": false}`).

### 3. Work in Scrum mode (with Notion)
With Notion enabled, the plugin behaves like Jira Scrum:
```
# Capture requirements as they arrive — they go to the Backlog
/sdlc-backlog "Add CSV export to the reports page"
/sdlc-backlog "Fix flaky checkout test" --type fix --priority high

# Plan a sprint and pull backlog items into it
/sdlc-sprint new "Sprint 1" --goal "Reporting + checkout fixes"
/sdlc-sprint add "Add CSV export to the reports page"
/sdlc-sprint add "Fix flaky checkout test"

# Sprint planning — refine each ticket with you until it's Ready
/sdlc-plan "Sprint 1"

# Commence the sprint — gated on planning; its tickets become the active Kanban board
/sdlc-sprint start "Sprint 1"

# Build a ticket in the active sprint — on Gate ③ it auto-merges to development
/sdlc Add CSV export to the reports page

# Close the sprint — promotes the sprint's Done features to staging for UAT
/sdlc-sprint close

# After UAT passes, ship to production (staging → main, version + tag, Gate ④)
/sdlc-release add-csv-export
```
Before a sprint starts, **`/sdlc-plan`** walks each ticket with you — refining scope, acceptance criteria, type, priority, and a lightweight `S/M/L/XL` estimate — and marks it `Ready`; `/sdlc-sprint start` won't commence until every ticket is `Ready` (override with `--skip-planning`). Board columns are **To Do → In Progress → In Review → Done** (workflow order, never alphabetical). When a feature passes the inspection gate, the plugin **auto-opens a PR and merges it into `development`** and marks the ticket Done. When you **close the sprint**, the scrum master writes a short review/retro and the batch is promoted to **staging for UAT** (`development → staging`, no tag). After UAT passes, **`/sdlc-release`** ships to production: `staging → main`, a version bump + `vX.Y.Z` tag, and the production deploy — all behind Gate ④.

### 4. Run or re-run a single phase
```
/sdlc-requirements   /sdlc-design   /sdlc-implement
/sdlc-inspect        /sdlc-release  /sdlc-docs
```
Useful to re-run a phase after changes, or drive the pipeline one step at a time. (`/sdlc-release` is the post-UAT production step: it promotes `staging → main` and refuses while a sprint is Active.)

### 5. Check status, sync, and fix CI
```
/sdlc-status      # phases, gates, open questions for every feature
/sdlc-sync        # mirror artifacts + board status to Notion
/sdlc-fix-ci      # diagnose a red CI run and repair pipeline config (gated)
```

### 6. Work tickets in parallel (git worktrees)
One feature = one branch = one working tree — so running several `/sdlc` sessions in a single checkout would make them fight over the checked-out branch. To work tickets **concurrently**, give each its own [git worktree](https://git-scm.com/docs/git-worktree) (a separate directory sharing the one `.git`) and run a `/sdlc` session in each. Keep your main checkout parked on `development`:

```
git fetch origin
git worktree add -b feature/csv-export    ../claude-sdlc-team-csv-export     origin/development
git worktree add -b fix/flaky-checkout    ../claude-sdlc-team-flaky-checkout origin/development
# then run `/sdlc <ticket>` inside each worktree directory, as separate sessions
```

The orchestrator **auto-detects** that it's running in a worktree and adapts Phase 0 (it branches from `origin/development` via `fetch` instead of `git checkout development`, which git would refuse while `development` is checked out elsewhere) and Gate ③ — no flag needed. PR-based promotion is unchanged. When a ticket's branch has merged and been deleted, remove its worktree:

```
git worktree remove ../claude-sdlc-team-csv-export && git worktree prune
```

> **Worktrees isolate files, not runtime.** Each one starts empty of `node_modules`/venv and shares nothing at runtime — give every session its own dependency install, dev/test **port**, and test DB/schema, and copy any git-ignored `.env`. Real throughput is bounded by how many approval gates you can clear and how many full stacks your machine can host at once — not by git. The full workflow lives in the `git-conventions` skill.

> **Notion is optional and non-blocking.** Without it, everything works locally against `docs/sdlc/`; `/sdlc-backlog` and `/sdlc-sprint` simply report that Notion is disabled, and release stays per-feature optional.

## Approval gates

The pipeline stops for you at up to four gates — nothing consequential happens unattended. In sprint mode the requirements gate **auto-passes** (sprint planning already approved it via `/sdlc-plan`), so a sprint run stops at three:

- **Gate ①** approve requirements *(auto-passes after sprint planning)* → **Gate ②** approve design → **Gate ③** review sign-off — including watching + approving the E2E screen recording when one was produced — (then the feature auto-merges to `development`) → **Gate ④** confirm before any outward-facing release/deploy.

## The team

Eleven stateless agents, each dispatched by the orchestrator for one job. They never guess — they ask clarifying questions and the orchestrator relays them.

| Agent | Phase | Role |
|---|---|---|
| `requirements-analyst` | 1 | Turn a raw request into testable requirements. |
| `solution-architect` | 2 | Turn approved requirements into a technical design. |
| `implementer` | 3 | Build the design with tests; fix review findings. |
| `qa-tester` | 4 | Verify behaviour against acceptance criteria. |
| `code-reviewer` | 4 | Review code quality, conventions, SOLID. |
| `security-reviewer` | 4 | Threat-model + scan for vulnerabilities. |
| `pipeline-reviewer` | 4 | Audit CI/CD config (no-ops if none exists). |
| `e2e-tester` | 4 | Drive the running app as a user via Playwright; record a review video with a visible cursor (no-ops without a web UI). |
| `release-engineer` | 5 | Author Docker/CI-CD + versioning for a manual-trigger deploy. |
| `tech-writer` | 6 | Update README/API docs/changelog. |
| `ci-doctor` | — | Diagnose a single failing CI run (used by `/sdlc-fix-ci`). |

## Configuration

Per-project state lives under `.sdlc/`:

- **`.sdlc/notion.json`** — `enabled: true|false` plus the Notion page/DB IDs (`parentPageId`, `projectPageId`, `projectsDbId`, `ticketsDbId`, `sprintsDbId`, …). Written by `/sdlc-init`.
- **`.sdlc/config.json`** — `{ "autoIntegrate": true }` by default. Set `false` to disable the Gate-③ auto-merge to `development` and revert to "don't merge unless asked."
- **`.claude/agent-memory/`** — committed, team-shared project memory (durable decisions, conventions, gotchas). Scaffolded by `/sdlc-init`, loaded into each session by the plugin's `SessionStart` hook, and maintained by the orchestrator per the `project-memory` skill. Distinct from Claude Code's machine-local built-in `memory: project` (under `~/.claude/`). The hook activates only after Claude Code is **restarted** following install.

## How it works

Sprint methodology is owned by the **`scrum-master`** skill (Definition of Ready/Done, refinement, planning facilitation, scope discipline, review/retro); Notion persistence is owned by **`notion-sync`**; the `/sdlc-plan` and `/sdlc-sprint` commands are the triggers. Each phase writes a numbered artifact under `docs/sdlc/<slug>/` (the canonical source of truth).
Agents are stateless and **ask clarifying questions rather than guessing**; the orchestrator
enforces approval gates, relays questions, and cuts a per-task branch from an up-to-date
`development` — or, when run inside a git worktree, branches from `origin/development` so parallel
tickets never collide (see Usage §6). Every component inherits your default model — nothing is pinned.

See `docs/superpowers/specs/` for the full design and `docs/superpowers/plans/` for the build plan.

## Principles

- **Pure-router orchestrator** — the `sdlc` skill delegates; it never does the work itself.
- **Stack-agnostic agents, opinionated skills** — adapt to any repo, lean on house standards when choices are open.
- **Reuse over reinvent** — discovers and collaborates with a project's existing agents/skills.
- **Local-first** — artifacts live in the repo; optional Notion mirror is non-blocking.

## License

MIT
