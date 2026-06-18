---
description: Manage Notion sprints like Jira Scrum — create a sprint, move backlog tickets into it, plan it (refine to Ready via /sdlc-plan), start it (commence → active Kanban board; gated on planning), or close it (review/retro + promote the sprint's Done features to staging for UAT). Non-blocking; no-ops if Notion is disabled.
argument-hint: "<new|add|move|start|close|list> [args]"
---

# /sdlc-sprint

Manage sprints in the current project's Notion Sprints DB + Tickets DB. Apply the `notion-sync` skill for the structure and invariants, and the `scrum-master` skill for the methodology (Definition of Ready gate, review/retro). Read `.sdlc/notion.json`; if it is missing / `enabled: false`, or the Notion MCP isn't connected, print a notice and stop (non-blocking).

`$ARGUMENTS` selects the action:

- **`new "<name>" [--goal "..."] [--start YYYY-MM-DD] [--end YYYY-MM-DD]`** — create a Sprints DB row with `State = Planned`.
- **`add <ticket> [<ticket> …]`** / **`move <ticket> --to "<sprint>"`** — set the ticket(s)' `Sprint` relation (pull from Backlog into a Planned/Active sprint). Tickets may be given by title or page ID. After adding, refine the tickets with **`/sdlc-plan`** before `start`.
- **`start ["<name>"] [--skip-planning]`** — set the named sprint (or the only Planned one) to `State = Active`. **Single-active-sprint `PRECONDITION`** (`sdlc-gates`): refuse if another sprint is already Active — tell the user to `close` it first. **Ready-to-start `PRECONDITION`**: refuse to start unless every ticket in the sprint has `Ready = true` (run `/sdlc-plan` first); override with `--skip-planning`. Starting the already-Active sprint is a no-op. Once Active, its tickets become the Active Sprint board.
- **`close`** — set the Active sprint to `State = Completed`. Leave `Done` tickets linked (history); clear `Sprint` on every unfinished ticket (`Status ≠ Done`) so they return to the Backlog. Write a short **review + retrospective** note on the sprint row (apply `scrum-master`: shipped vs. carried over; went well / improve / one action). **Then promote to staging for UAT:** apply `git-conventions` staging promotion — open + auto-merge a PR `development → staging` and trigger the staging deploy for UAT. **No version bump, no tag, no `main`.** Production release is a **separate step** (`/sdlc-release`, after UAT passes).
- **`list`** / **`status`** — list sprints with their `State` and a per-`Status` ticket count; mark which is Active.

After any write, cache `activeSprintId` in `.sdlc/notion.json` and report the board link. All writes are non-blocking — warn and continue on failure.
