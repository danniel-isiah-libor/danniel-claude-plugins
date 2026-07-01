# Maintenance workflows

How the vault-keeper actually does the work. Each workflow is MCP-aware: it names
the Obsidian tools to use and how to stay link-safe. Always run the survey
(workflow 1) first, and follow the vault's own conventions over these defaults.

## Access model — MCP first, filesystem fallback

- **Preferred:** the Obsidian MCP (`mcp__obsidian__*`, Local REST API plugin).
- **Fallback:** if the MCP is not connected, operate on the vault folder directly
  with Read/Edit/Write/Glob/Grep.
- **The hard truth about moves:** the MCP has **no move/rename tool**, and the
  REST API does **not** auto-update `[[links]]`. Renaming or moving a note by any
  route outside the Obsidian app breaks every link to it. So a "move" is always:
  1. Create the note at the new path (`obsidian_append_content` to the new path,
     or Write).
  2. Find every note that links to the old name and repair those links
     (workflow 4).
  3. Delete the old note (`obsidian_delete_file` with `confirm: true`), only after
     reading it and confirming.
  When many moves are needed, prefer doing them inside the Obsidian app (which
  auto-updates links) and tell the user so.

## 1. Vault health snapshot

Goal: an accurate picture before changing anything.

- Enumerate notes: `obsidian_complex_search` with `{"glob": ["*.md", {"var": "path"}]}`
  for a full list; `obsidian_list_files_in_vault` (root) and
  `obsidian_list_files_in_dir` for folder-by-folder structure.
- Read in bulk with `obsidian_batch_get_file_contents` to inspect frontmatter and
  link density.
- Tally: total notes, notes per PARA bucket, `_inbox` backlog, notes missing
  frontmatter, orphans (workflow 5), broken links (workflow 4), stale MOCs
  (workflow 3).
- Output a short report with counts. Change nothing in this workflow.

## 2. Capture & filing (process `_inbox` into PARA)

- List `_inbox` (`obsidian_list_files_in_dir` on `_inbox`).
- When capturing from a **web page**, clip it to clean Markdown first with the
  official `obsidian:defuddle` skill, then file the result.
- For each note, read it and decide the PARA bucket by **actionability**:
  `1 Projects` (has an end), `2 Areas` (ongoing standard), `3 Resources`
  (reference), `4 Archive` (inactive). When unsure, ask.
- Apply the matching template from `_templates` if the note type has one.
- File it (a move — follow the Access model above), then add it to the relevant
  MOC (workflow 3) or rely on the MOC's Dataview query to pick it up.

## 3. MOC build & refresh

- Ensure each PARA bucket has an index note. Create a missing one with a Dataview
  auto-list (see `vault-organization.md` → "MOCs with Dataview"):
  a `tags` frontmatter of `[moc, para/<bucket>]`, a one-line description, and a
  ```dataview LIST FROM "<bucket>" WHERE file.name != this.file.name SORT
  file.mtime DESC``` block.
- Refresh a stale MOC by re-checking its `FROM` path still matches the folder and
  the `WHERE file.name != this.file.name` self-exclusion is present.
- A folder with no note in it does not exist in Obsidian — create the folder by
  writing its MOC note into it.

## 4. Link hygiene (broken links & unlinked mentions)

- **Find broken links:** collect all `[[targets]]` (search body text with
  `obsidian_simple_search` or `obsidian_complex_search` `regexp` on
  `\[\[([^\]]+)\]\]`), then check each target resolves to an existing note name or
  alias. Unresolved targets are broken.
- **Repair:** if the target was renamed/moved, update the link text to the new
  name (`obsidian_patch_content` with `operation: replace` on the containing
  block, or Edit). If the target is genuinely gone, ask whether to recreate it or
  remove the link.
- **Unlinked mentions:** where a note's title appears as plain text in other
  notes, offer to convert to `[[links]]` — but don't over-link (avoid linking the
  same term repeatedly on one page; see the style guide).

## 5. Orphan detection

- An orphan has no inbound links (no backlinks) and often no outbound links.
- Find candidates: for each note, check whether any other note links to its name
  or aliases (reuse the link index from workflow 4).
- For each orphan, propose one of: link it from a relevant MOC or note, or move it
  to `4 Archive` if it's inactive. Never delete an orphan without confirmation —
  low connectivity is not the same as low value.

## 6. Frontmatter normalization

- Define/confirm the property schema from the vault (or default to: `tags` (list),
  `aliases` (list), `created` (date), `status` (text)). Follow the vault's
  existing keys if it has them.
- Find drift: notes missing frontmatter entirely, or with inconsistent key
  names/types. `obsidian_patch_content` with `target_type: frontmatter` adds or
  updates a field without touching the body.
- Normalize conservatively: add missing standard keys; don't invent values —
  ask or leave blank. Keep `#` out of YAML tag values.

## 7. Dedup & rename

- **Detect near-duplicates:** notes with very similar names or near-identical
  content (compare titles and, for suspects, bodies via
  `obsidian_batch_get_file_contents`).
- **Merge safely:** pick the canonical note, append the unique content from the
  duplicate into it (`obsidian_append_content`), add the duplicate's name as an
  `alias` so old links still resolve, repair inbound links (workflow 4), then
  delete the duplicate (read + confirm first).
- **Rename:** follow the Access model — create at new name, fix backlinks, delete
  old — or do it in-app. Keep naming consistent: `Title Case` for concept notes,
  `YYYY-MM-DD` for dailies; avoid `# | ^ [ ]` in names.

## 8. Archive lifecycle

- **Project done/dropped:** move it from `1 Projects` to `4 Archive` (a move —
  Access model applies).
- **Employer lifecycle:** a current job is an Area; when it ends, move the whole
  employer folder to the archive location the vault uses (e.g. `_Past Employers`).
  This is one bulk move — prefer doing it in-app so links update automatically.
- Nothing is deleted in archiving; it's parked for reference.

## 9. Link-safe editing checklist (run before any destructive change)

- Read the note before deleting or overwriting it; confirm with the user for any
  delete, merge, or bulk move.
- After a move/rename, verify no `[[links]]` to the old name remain (re-run
  workflow 4 scoped to the old name).
- Prefer `obsidian_patch_content` (targeted, heading/block/frontmatter-scoped)
  over rewriting a whole note, to avoid clobbering content.
- Keep the vault on one sync method; don't introduce a plugin dependency for core
  content.
