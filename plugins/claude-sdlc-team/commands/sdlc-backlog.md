---
description: Capture a new requirement into the project's Notion Backlog as a ticket (no sprint, no pipeline run). Non-blocking; no-ops if Notion is disabled.
argument-hint: "<requirement> [--type feature|fix|chore] [--priority low|medium|high|urgent]"
---

# /sdlc-backlog

Capture a requirement into the current project's Notion Backlog. Apply the `notion-sync` skill. Read `.sdlc/notion.json`; if it is missing / `enabled: false`, or the Notion MCP isn't connected, print a notice and stop (non-blocking).

1. Parse `$ARGUMENTS`: the requirement text (required), optional `--type` (default Feature) and `--priority` (default Medium). Derive a one-line `Title` from the text.
2. Create a ticket in the project's **Tickets DB** with: `Title`, `Type`, `Priority`, `Status = To Do`, `SDLC Phase = Backlog`, `Sprint` empty, `Ready = false` (unrefined), and the requirement text in `Acceptance summary` and the page body.
3. Do **not** run the pipeline and do **not** create a git branch. Report the new backlog ticket link and remind the user of the next steps: schedule it with `/sdlc-sprint add`, then refine it with `/sdlc-plan` before the sprint starts.
