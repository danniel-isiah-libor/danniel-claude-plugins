---
description: Sprint planning — collaboratively refine each candidate ticket in a Planned sprint to the Definition of Ready (scope, acceptance, type, priority, estimate), write the agreed details to Notion, and mark each Ready. Gates /sdlc-sprint start. Non-blocking; no-ops if Notion is disabled.
argument-hint: "[\"<sprint>\"] [--revisit] [--ticket \"<title-or-id>\"]"
---

# /sdlc-plan

Run **sprint planning** on a Planned sprint before it commences. Apply the `scrum-master` skill for the methodology (Definition of Ready, refinement, sizing, splitting) and the `notion-sync` skill for reads/writes. Read `.sdlc/notion.json`; if it is missing / `enabled: false`, or the Notion MCP isn't connected, print a notice and stop (non-blocking) — though you may still refine interactively and report which Notion writes were skipped.

1. **Resolve the sprint** from `$ARGUMENTS` (a name), or the single `State = Planned` sprint if unambiguous. **Refuse** if the resolved sprint is `Active` or `Completed` (planning is pre-start); tell the user planning happens before `start`.
2. **List candidate tickets** (`Sprint` = this sprint). If none, tell the user to add some with `/sdlc-sprint add` first, then stop.
3. **Refine each ticket with `Ready = false`, one at a time** (or only the `--ticket` one). With `--revisit`, also re-open already-Ready tickets. For each, applying `scrum-master`:
   - Propose a refined `Title`, scope/description, `Acceptance summary`, `Type`, `Priority`, and `Estimate` (S/M/L/XL). If the ticket is too large or vague (an `XL`, or it hides multiple acceptance criteria), recommend splitting it and, on the user's OK, create the split tickets in the same sprint.
   - Ask the user (AskUserQuestion) to confirm or adjust.
   - On confirm: via `notion-sync`, write the agreed fields to the ticket and set `Ready = true`.
4. **Confirm/record the sprint goal** on the Sprints DB `Goal` (propose one from the refined tickets; let the user edit).
5. **Report planning status:** how many tickets are Ready vs. remaining. When all are Ready, tell the user the sprint is startable (`/sdlc-sprint start`).

Idempotent: already-Ready tickets are skipped unless `--revisit`. All Notion writes are non-blocking — warn and continue on failure.
