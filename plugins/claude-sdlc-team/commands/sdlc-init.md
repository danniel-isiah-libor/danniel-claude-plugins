---
description: Bootstrap a project — set up the three-tier git branch model (main/staging/development) and optionally enable Notion sync (register the project + ensure the Kanban board).
---

# /sdlc-init

Set up the three-tier git branch model for this repo, idempotently. Apply the `git-conventions` skill for the branch model.

Steps:
1. Verify we're inside a git repo; if not, offer to run `git init`.
2. Ensure at least one commit exists on `main` (create an initial commit if empty; if the default branch has another name, offer to rename it to `main` — only with confirmation).
3. Create `staging` and `development` from `main` if missing. Idempotent: if a branch exists, skip and report it — never clobber.
4. If a remote exists, CONFIRM with the user before pushing (outward-facing), then push all three and set upstreams.
5. Leave the user on `development`.
6. **Agent memory (apply `project-memory`):** if `.claude/agent-memory/` does not exist, create it with a seed `MEMORY.md` (a titled, near-empty index) and a short `README.md` explaining the folder, then `git add .claude/agent-memory/` (that subdirectory only — never `settings.local.json`) and commit on `development`. Idempotent: if the folder already exists, skip and report it. Seed `MEMORY.md`:

   ```markdown
   # Project Agent Memory

   Durable, team-shared project context for the SDLC pipeline. One line per fact below, each linking to a file with the detail. Maintained by the orchestrator (see the `project-memory` skill); loaded each session by the plugin's SessionStart hook.

   <!-- Entries appear below. Format: - [Title](file.md) — one-line hook -->
   ```

   Seed `README.md`:

   ```markdown
   # Agent Memory

   Committed, team-shared project memory for the SDLC pipeline: durable decisions, conventions, gotchas, and the "why" behind non-obvious choices.

   - `MEMORY.md` — the index (one line per fact); loaded into every session by the plugin's SessionStart hook.
   - `*.md` — one file per fact (frontmatter + body).

   Conventions live in the plugin's `project-memory` skill. Versioned on purpose so knowledge travels with the code — distinct from Claude Code's machine-local built-in `memory: project`.
   ```

7. **Notion (optional — ask first):** ask whether to enable Notion sync for this project, then apply the `notion-sync` skill.
   - If **no**: write `{ "enabled": false }` to `.sdlc/notion.json` and skip Notion setup — the project stays purely local.
   - If **yes**: best-effort ensure the shared **Projects DB** exists; ask the user for the parent location (a teamspace or page — list teamspaces via `notion-get-teams`) and store it as `parentPageId`; **create this project's hub page** under that parent; then create **this project's own Tickets DB + Sprints DB under the hub page** (with the `Sprint` relation, the `Sprint State` rollup, and the Backlog / Active Sprint / Roadmap views). Register/locate this project's row in the Projects DB (storing its `Project Page ID`, `Tickets DB ID`, `Sprints DB ID`), set `"enabled": true`, and store every ID — including `projectPageId` — in `.sdlc/notion.json`. Fall back to the guided "create these, paste their IDs" flow if the MCP can't create the page/databases/relations/rollups/views; adopt existing pages/DBs if already configured. Skip gracefully if the Notion MCP isn't connected.
8. Print the resulting topology + any Notion links, and suggested follow-ups (set the GitHub default branch; add branch protection for `main`/`staging`).

Do not force-push or delete branches.
