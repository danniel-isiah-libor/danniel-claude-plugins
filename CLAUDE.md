# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A **Claude Code plugin marketplace** (a monorepo of plugins) — not an application. There is no build system, no test runner, and no package manager. The deliverables are Markdown, JSON, and bash: agents, skills, commands, and hooks that Claude Code loads. "Correctness" means valid manifests, well-formed component frontmatter, and skill descriptions that trigger reliably — not passing tests.

The marketplace root manifest is `.claude-plugin/marketplace.json`; each plugin lives under `plugins/<name>/` with its own `.claude-plugin/plugin.json` and `README.md`.

## Plugins

| Plugin | Version | Shape | What it is |
|--------|---------|-------|-----------|
| `claude-sdlc-team` | 1.9.0 | 11 agents · 14 commands · 26 skills | A gated, end-to-end agentic SDLC pipeline driven by a pure-router orchestrator, with optional Notion Scrum sync |
| `claude-dream-team` | 0.5.0 | 4 agents · 1 command · 6 skills | A summonable roster of senior expert agents (devops, fullstack, qa, technical-writer) + the `/dream-team-review` loop |
| `obsidian-vault-keeper` | 0.2.0 | 1 agent · 1 command · 1 skill | An active Obsidian vault steward (PARA filing, MOCs, link/orphan repair) via the Obsidian MCP; defers authoring syntax to the required official `obsidian` plugin |

## Editing / release workflow (there is no "build")

- **Iterate by editing files directly.** Components are discovered by directory convention — dropping a file in `agents/`, `commands/`, `skills/<name>/`, or wiring a hook in `hooks/hooks.json` is all that "registers" it.
- **Validate before shipping.** Use the `plugin-dev:plugin-validator` agent to check plugin/manifest structure and the `plugin-dev:skill-reviewer` agent to check skill quality and description triggering. JSON manifests must be valid JSON.
- **Version lives in two places per plugin** — the plugin's own `plugin.json` *and* its entry in `.claude-plugin/marketplace.json`. Bump both together; they must match. (Prose version mentions in READMEs, e.g. a "Status:" line, are cosmetic and drift — trust the manifests.)
- **Releasing = `gh release create`.** Cutting a GitHub release is what triggers the GitLab mirror (below). Commit and push only when asked.

## GitHub → GitLab mirror (critical, non-obvious)

`.claude/settings.json` registers a repo-level **PostToolUse (Bash) hook**, `.claude/hooks/sync-release-to-gitlab.sh`, that fires whenever a Bash command containing `gh release create` runs.

- **GitHub (`danniel-claude-plugins`) is the source of truth; GitLab (`snap-claude-plugins`) is a downstream mirror.** On release, the hook clones GitLab, rsyncs this repo over it, re-applies GitLab branding (marketplace name + install URLs are rewritten), pushes `main`, mirrors the tag, and cuts the matching GitLab release with rebranded notes.
- **The `.claude/` tooling itself IS mirrored**, except this hook script — which is never copied, and whose own registration is stripped from the mirrored `settings.json` so no sync loop can form.
- It is **idempotent** (skips if GitLab already has the tag) and **non-destructive to GitHub** (a sync failure only logs to stderr). Set `DRY_RUN=1` to do everything except push/tag/release; override targets via `GITLAB_GIT_REMOTE` / `GITLAB_PROJECT`.
- Releases made in the GitHub web UI or a plain terminal do **not** fire this — only a `gh release create` run through Claude Code does.

## Plugin component architecture

Every plugin follows the same layout under `plugins/<name>/`:

- **`agents/*.md`** — subagents. Frontmatter: `name`, `description` (with embedded `<example>…<commentary>` blocks that teach when to route to the agent), often `color` and `memory: project`. The body is the system prompt.
- **`skills/<name>/SKILL.md`** — skills use **progressive disclosure**: only the short `description` sits in context; deeper material lives in sibling `references/*.md` loaded on demand. Keep `SKILL.md` lean and push detail into `references/`.
- **`commands/*.md`** — slash commands (`/<filename>`). Frontmatter carries the `description`; the body is the instruction the command runs.
- **`hooks/hooks.json`** + scripts — plugin-scoped hooks. Reference scripts via `$CLAUDE_PLUGIN_ROOT`.

### claude-sdlc-team: router + gates

The `sdlc` skill is a **pure-router orchestrator** — it sequences phases and dispatches to agents via the Agent tool but **never does phase work inline** and never passes a `model` override (agents inherit the session model). Key supporting skills that encode the architecture:

- `capability-discovery` (Phase 0) — inventories project-local agents/skills, other plugins, and MCP servers. The team is **additive**: prefer the plugin's own components, but reuse a project's when they fit. Delegation is always announced, never silent.
- `sdlc-gates` — the `GATE` / `LOOP-GUARD` / `PRECONDITION` primitives every approval gate and fix-loop invokes.
- `sdlc-artifacts` — artifact layout under `docs/sdlc/<slug>/`, manifest schema, and the clarify-don't-guess protocol.
- `project-memory` — the committed `.claude/agent-memory/` store (loaded at session start by `hooks/load-agent-memory.sh`, persisted across sessions).

The pipeline is Phases 0–6 (requirements → design → implementation → parallel QA/review/security/pipeline/E2E → release → docs) over a three-tier branch model (`development` → `staging` → `main`).

## Cross-plugin ownership (avoid duplication)

Some knowledge is deliberately single-sourced. Respect these boundaries when editing:

- **All Obsidian knowledge** → `obsidian-vault-keeper` is the sole Obsidian owner among these plugins; no other plugin should reference Obsidian (the dream-team's former `obsidian-conventions` skill was removed for this reason). Its `obsidian-vault` skill owns *stewardship* — PARA, MOCs, link hygiene, maintenance workflows, the style guide, and Dataview/Templates — and **defers authoring syntax** (Obsidian Flavored Markdown, `.base`, `.canvas`, the `obsidian` CLI, and web-clipping) to the **required official `obsidian` plugin** (Steph Ango / kepano). Reference those skills by name only — never copy their content: the official plugin auto-updates, so a local copy would silently drift.
- **Git conventions** (Conventional Commits, Conventional Branch, three-tier model, PR-based promotion + branch cleanup, semver) → the `git-conventions` skill. This governs commits in this repo too.

## Design docs

Larger features are specced before implementation under `docs/superpowers/specs/` (design) and `docs/superpowers/plans/` (implementation plans), dated `YYYY-MM-DD-<slug>.md`. Check there for the rationale behind a plugin's structure.

## Conventions for this repo

- **Commits** follow Conventional Commits with a plugin scope, e.g. `feat(obsidian-vault-keeper): add /vault-checkup command`. See recent `git log` for the house style.
- `.superpowers/` (a subagent-driven-development scratch ledger) is gitignored — don't commit it.
