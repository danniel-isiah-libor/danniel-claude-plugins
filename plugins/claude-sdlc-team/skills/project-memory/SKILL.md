---
name: project-memory
description: "Conventions for the repo-local, committed agent-memory store at .claude/agent-memory/. Use whenever reading project memory at the start of an SDLC run, forwarding it to subagents, or persisting a durable project fact. Defines the MEMORY.md index + per-fact file layout, what is worth remembering, and the orchestrator-owned write protocol. Complements (does not replace) Claude Code's built-in `memory: project`."
---

# Project Memory — repo-local, team-shared

The SDLC pipeline keeps durable project knowledge in **`.claude/agent-memory/`**, committed to the repo so it travels with the code and is shared with the team. `/sdlc-init` scaffolds it; a `SessionStart` hook loads it into the orchestrator each session.

This is **separate** from Claude Code's built-in `memory: project` (machine-local under `~/.claude/`, not committed). When they disagree, the in-repo store is the source of truth.

## Layout

```
.claude/agent-memory/
  MEMORY.md          # the index — one line per fact: - [Title](file.md) — hook
  README.md          # explains the folder (scaffolded by /sdlc-init)
  <slug>.md          # one file per durable fact
```

Each fact file:

```markdown
---
name: <short-kebab-case-slug>
description: <one-line summary — used to judge relevance on recall>
type: decision | convention | gotcha | context
---

<the durable fact; the "why" behind a non-obvious choice. Link related facts with [[their-slug]].>
```

## What to store (and what NOT to)

Store **durable, cross-run** facts: architectural decisions and their rationale, project conventions, recurring gotchas/pitfalls, stack quirks, hard-won "why" knowledge.

Do **not** store: anything already in `docs/sdlc/<slug>/` artifacts, git history, or `CLAUDE.md`; per-feature task detail; or session-only chatter. If it would not help a *future, fresh* run, it does not belong here.

## Read protocol (orchestrator)

1. At the start of a run, read `MEMORY.md`; open the per-fact files whose descriptions look relevant to the current request.
2. **Forward to subagents.** Subagents start fresh and there is no subagent-start hook — so, per the orchestrator's "pass context forward" rule, embed the relevant memory entries (or quote them) into each agent's dispatch prompt. A subagent never reads memory on its own.

## Write protocol (orchestrator-owned)

A single writer keeps the shared store curated and avoids diff noise.

1. Subagents may end their report with an optional `MEMORY CANDIDATES:` line proposing durable facts. They do **not** write memory themselves.
2. At **completion** (and at notable gate boundaries) the orchestrator decides what is durable, then for each kept fact:
   - **Dedup first:** if an existing fact file already covers it, update that file instead of creating a near-duplicate.
   - Otherwise write `.claude/agent-memory/<slug>.md` (frontmatter + body) and add a one-line pointer to `MEMORY.md`.
3. Memory is committed as part of the normal flow (no separate approval gate), but only the orchestrator writes it.

## Recall caveat

A memory reflects what was true when written. If a fact names a file, flag, or function, verify it still exists before relying on it.
