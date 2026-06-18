---
description: Sync the current feature's artifacts and status to Notion (Projects registry + the project's own Tickets/Sprints DBs + doc pages). Idempotent and non-blocking; no-ops if Notion is disabled for the project.
argument-hint: "[feature slug]"
---

# /sdlc-sync

1. Read `.sdlc/notion.json`. If it is missing or `enabled: false`, print a notice and stop (suggest running /sdlc-init to enable Notion).
2. If the Notion MCP isn't connected, warn and stop (non-blocking).
3. Apply the `notion-sync` skill: ensure the Projects DB + this project's hub page + its Tickets DB + Sprints DB exist (best-effort auto-create / adopt), upsert this project's registry row, and upsert the feature's ticket in the project's **Tickets DB**. Derive BOTH `SDLC Phase` and `Status` from the manifest's current phase using the mapping in `notion-sync`; preserve the ticket's existing `Sprint` relation, `Ready`, and `Estimate` (sync never overwrites planning fields). Upload/update the doc pages (`01`–`06` that exist) under the ticket and tick `Docs synced` when `06` exists. Idempotent.
4. Report what synced + the ticket/board link; write any new IDs back to `.sdlc/notion.json` and the manifest.
