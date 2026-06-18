---
name: notion-sync
description: Mirror the SDLC pipeline to a Notion workspace as a Jira-Scrum board — a shared Projects registry plus, per project, a hub page holding its own Tickets and Sprints databases with backlog and active-sprint views, plus sprint-planning Ready sign-off. Use when syncing artifacts/status to Notion (the /sdlc-sync, /sdlc-sprint, /sdlc-plan, /sdlc-backlog commands and the orchestrator's gate hooks). Optional and non-blocking — no-ops if disabled or the Notion MCP is unavailable.
---

# Notion Sync (Scrum model)

Enabled per project via `.sdlc/notion.json` (`enabled: true|false` plus DB/page IDs). If disabled, or the Notion MCP is not connected, **no-op with a notice** — never block the pipeline. The repo's `docs/sdlc/` tree is the canonical source of truth; Notion only mirrors it.

## Workspace structure
One shared **Projects DB** registers every project. Each project then gets its **own hub page** (a Notion page created by `/sdlc-init`, under a parent location the user picks — a teamspace or a page), and that hub page holds the project's **own** Tickets DB (its board) and a small Sprints DB.

```
Workspace (parent location the user picks — a teamspace or page → parentPageId)
├─ Projects DB        (ONE shared registry)
└─ «Project Hub» page (ONE per project, created by /sdlc-init)
   ├─ Tickets DB      (per project — the board lives here)
   └─ Sprints DB      (per project — sprint metadata)
```

- **Projects DB** (one, shared) — one row per repo/project: `Name`, `Repo URL`, `Stack`, `Status`, `Description`, `Project Page ID` (text), `Tickets DB ID` (text), `Sprints DB ID` (text).
- **Tickets DB** (one per project — the board lives here) — one card per work item:
  - `Title` (title); `Type` (select: Feature / Fix / Chore)
  - `Status` (select — the **board column**): options in this exact order — `To Do`, `In Progress`, `In Review`, `Done`, `Blocked`.
  - `SDLC Phase` (select — pipeline detail, not a column): options in order — `Backlog`, `Requirements`, `Design`, `Implementation`, `Inspection`, `Release`, `Docs`, `Done`.
  - `Sprint` (relation → this project's Sprints DB; empty ⇒ **Backlog**)
  - `Sprint State` (rollup of the related sprint's `State`)
  - `Priority` (select: Low / Medium / High / Urgent); `Branch` (text); `PR` (url); `Docs synced` (checkbox); `Acceptance summary` (text)
  - `Ready` (checkbox — **planning sign-off**; set during `/sdlc-plan`; gates `/sdlc-sprint start`)
  - `Estimate` (select: S / M / L / XL — lightweight size agreed during planning; no velocity/burndown)
- **Sprints DB** (one per project) — one row per sprint: `Name` (title); `State` (select: Planned / Active / Completed); `Start` (date); `End` (date); `Goal` (text).

## Views on the Tickets DB
- **Backlog** (table/list): filter `Sprint is empty` AND `Status ≠ Done`; sort by `Priority` (desc).
- **Active Sprint** (board — the Kanban): filter `Sprint State is Active`; **group by `Status`**; columns left→right `To Do → In Progress → In Review → Done`; set the board's column/group sort to **manual** (never alphabetical). Because the filter reads the `Sprint State` rollup, the board auto-follows whichever sprint is Active — no view edits when a sprint starts or closes.
- **Roadmap / All** (table, optional): no filter.

## SDLC Phase → board Status mapping
The orchestrator sets BOTH properties as a ticket advances:

| Pipeline event | `SDLC Phase` | `Status` |
|---|---|---|
| Captured to backlog | Backlog | To Do |
| In active sprint, Phases 1–3 running | Requirements / Design / Implementation | In Progress |
| Phase 4 inspection | Inspection | In Review |
| Gate ③ passed → auto-merged to `development` | Done (or Docs, if documented) | Done |
| Sprint closed → promoted to `staging` for UAT | Done | (sprint-level event) |
| Production release → `staging → main` + tag | Release | (sprint-level event) |
| Loop-guard escalation | (unchanged) | Blocked |

"Done" means **dev-complete and integrated into `development`** — not released. Release is the sprint-level event below.

## Sprint lifecycle
- **new** — create a Sprints DB row, `State = Planned`.
- **add / move** — set ticket(s)' `Sprint` relation to a Planned/Active sprint (pull from Backlog).
- **plan** (`/sdlc-plan`) — refine each Planned-sprint ticket to the Definition of Ready (apply `scrum-master`); write the agreed Title/description/`Acceptance summary`/`Type`/`Priority`/`Estimate` to the ticket and set `Ready = true`; record the sprint `Goal`. Pre-pipeline grooming, written to Notion; non-blocking.
- **start** — set `State = Active`. **Invariant: exactly one Active sprint** — refuse if another is Active (close it first). **Planning gate:** refuse to start unless every ticket in the sprint has `Ready = true` (run `/sdlc-plan` first); override with `--skip-planning`. Starting an already-Active sprint is a no-op (idempotent). Once Active, its tickets are the Active Sprint board.
- **close** — set the Active sprint `State = Completed`; `Done` tickets stay linked (history); unfinished tickets (`Status ≠ Done`) get `Sprint` cleared → back to Backlog. Write a short **review + retrospective** note on the sprint row (apply `scrum-master`: shipped vs. carried over; went well / improve / one action). **Closing promotes the sprint's Done features to `staging` for UAT** (orchestrator Phase 5 staging promotion + `git-conventions`) — no version bump, no tag, no `main`.

## Backlog intake
New requirements are captured as Backlog tickets (`Sprint` empty, `SDLC Phase = Backlog`, `Status = To Do`) without running the pipeline. A ticket advances through the pipeline only after it is pulled into a **started** sprint.

## Release gating
There is no mid-sprint release. Per-feature integration to `development` happens automatically at Gate ③ (see `git-conventions`). At sprint close the batch is promoted to **`staging` for UAT** (no tag); the **production release** to `main` (with versioning/tagging) is a **separate step** (`/sdlc-release`, after UAT passes).

## DB setup (best-effort)
On first use, try to auto-create the shared Projects DB, then **create this project's hub page** under a parent the user picks (a teamspace or page), and create this project's Tickets DB + Sprints DB **under the hub page** (with the `Sprint` relation, `Sprint State` rollup, and the Backlog / Active Sprint / Roadmap views). Register the project's `Project Page ID` + DB IDs in the Projects DB. If the MCP can't create the page/databases/relations/rollups/views, fall back to a guided "create these, paste their IDs" flow; adopt existing pages/DBs if already configured. Store all IDs in `.sdlc/notion.json`.

## Config (`.sdlc/notion.json`)
```json
{
  "enabled": true,
  "parentPageId": "<page>",
  "projectsDbId": "<db>",
  "projectRowId": "<row>",
  "projectPageId": "<this project's hub page>",
  "ticketsDbId": "<db>",
  "sprintsDbId": "<db>",
  "activeSprintId": "<row-or-null>"
}
```
`activeSprintId` is a convenience cache; the Notion row with `State = Active` is the source of truth.

## Idempotency & safety
Upsert by stored IDs (fallback: find-by-name); re-runs update rather than duplicate. The one-Active-sprint invariant is enforced on `start`; if Notion shows two Active sprints (from manual edits), warn and ask which to keep. Every Notion write is **non-blocking**: on any failure, warn and continue on local artifacts.
