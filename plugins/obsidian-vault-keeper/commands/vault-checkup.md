---
description: Run a read-only Obsidian vault health sweep — scan for orphans, broken links, frontmatter drift, misfiled/duplicate notes, and stale MOCs — then report findings and offer to fix.
argument-hint: "[folder path | empty = whole vault]"
---

# /vault-checkup

Run a vault health sweep with the `vault-keeper` agent and the `obsidian-vault`
skill's maintenance workflows.

## Scope
`$ARGUMENTS` selects what to check:
- empty → the whole vault.
- a folder path → limit the sweep to that folder.

If the vault can't be reached (no Obsidian MCP connected and no vault path known),
ask the user for the vault location.

## Sweep (read-only first)
1. **Survey.** Dispatch the `vault-keeper` agent to run workflow 1 (vault health
   snapshot) over the scope — inventory notes and structure. Change nothing yet.
2. **Scan** for, and count, each finding category:
   - Orphans (no inbound/outbound links) — workflow 5.
   - Broken `[[links]]` and unresolved targets — workflow 4.
   - Frontmatter drift (missing/inconsistent properties) — workflow 6.
   - Misfiled or unprocessed notes (`_inbox` backlog, wrong PARA bucket) —
     workflow 2.
   - Duplicate/near-duplicate notes — workflow 7.
   - Stale or missing MOCs — workflow 3.
3. **Report** findings grouped by category with counts and example notes.

## Fix (only after reporting)
4. Offer to fix. Apply **non-destructive** fixes directly (add missing MOCs, add
   missing standard frontmatter keys, repair clearly-renamed links). For
   **destructive** fixes (delete, merge duplicates, bulk move/archive), list them
   and confirm before running — one move at a time, link-safely (create-new →
   fix backlinks → delete-old), or advise doing bulk moves in-app.
5. **Verify** links and frontmatter are intact and report what changed.

## Rules
- Read before delete/overwrite; never delete user content without confirmation.
- Don't push, sync-config, or install plugins. Maintenance only.
- Final output: the findings report, what was fixed, and what's left for the user.
