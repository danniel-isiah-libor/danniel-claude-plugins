---
name: obsidian-vault
description: Maintain and organize an Obsidian vault to best practices, and apply the official Obsidian writing style guide (voice, terminology, headings, callouts) when editing notes. Use when organizing or maintaining an Obsidian vault — capturing/filing into PARA, building/refreshing MOCs, fixing broken links, finding orphans, normalizing frontmatter, deduping/renaming, or the archive lifecycle. Covers PARA organization, MCP-aware maintenance workflows, and Dataview/Templates. Not for Obsidian authoring syntax — route Obsidian Flavored Markdown, .base, and .canvas files to the official obsidian plugin's skills (obsidian:obsidian-markdown, obsidian:obsidian-bases, obsidian:json-canvas).
---

# Obsidian Vault

The knowledge base for maintaining and organizing an Obsidian vault — and for
writing its notes to the official style guide (syntax itself is deferred; see
below). **Survey the vault first** — if it already defines conventions (structure,
naming, templates, a home/README note, a `.obsidian` config), follow those; the
rules below are the defaults otherwise.

Obsidian notes are plain Markdown files in a folder. Keep them future-proof, link
liberally, and follow the official style guide when writing. Three things make
Obsidian different from plain Markdown editing: its Markdown dialect, its vault
organization, and its link-update behavior — and one thing makes *maintenance*
different: the tools you use can silently break links.

## Access model (for the steward)

Three channels, preferred in this order:

1. **Obsidian MCP** (`mcp__obsidian__*`) — when connected.
2. **`obsidian` CLI** — when Obsidian is open; it drives the *running* app
   (read/create/append/search, tasks, properties, backlinks). Defer to
   `obsidian:obsidian-cli` for the commands.
3. **Filesystem** Read/Edit/Write on the vault path — the always-available fallback.

Neither the MCP nor the filesystem has a link-safe move/rename, and neither
auto-updates `[[links]]` — treat every move as create-new → fix backlinks →
delete-old, or do the move **inside the Obsidian app**, which updates links
automatically. Full detail in `references/maintenance-workflows.md`.

## Writing notes — follow the Obsidian style guide

Full guide in `references/style-guide.md`. The high-value rules:

- **Global English**, active voice, simple words, American spelling.
- **Sentence case** headings; **imperative mood** for guide names and steps
  ("Set up", not "Setting up").
- **Preferred terms:** heading (not header), folder (not directory), select (not
  click/tap), note name (not note title), active note (not current note), sync
  (not synchronise), keyboard shortcut (not hotkey).
- **Bold** for UI/button labels; `→` for navigation; keyboard shortcuts as
  `Ctrl+Z` (no spaces).
- **Callouts** for tips/info/warnings; **lists** for discrete items, **prose** for
  how/why.

## Authoring syntax → use the official `obsidian` skills

Obsidian's file syntax is owned by the official `obsidian` plugin (Steph Ango /
kepano) and kept current there — don't restate or copy it. Reach for the skill
that fits the file:

- `obsidian:obsidian-markdown` — Obsidian Flavored Markdown: wikilinks, embeds,
  callouts, properties, tags, comments, highlights, math, Mermaid, footnotes.
- `obsidian:obsidian-bases` — `.base` files (database-style views/filters/formulas);
  the modern core way to build a queryable MOC or dashboard.
- `obsidian:json-canvas` — `.canvas` files (visual MOCs, mind maps, flowcharts).
- `obsidian:defuddle` — clip a web page to clean Markdown when capturing into the vault.

Your job is *stewardship* — where a note goes, how it's linked and named, and
that it stays healthy. For **Dataview** and **Templates** (which those skills
don't cover) see `references/queries-and-templates.md`.

## Organizing a vault

Full method in `references/vault-organization.md`. The defaults:

- **Links over deep folders.** Keep structure flat-ish; use **MOC index notes** as
  hubs.
- **PARA — organize by actionability, not topic:** `1 Projects` (active, has an
  end) · `2 Areas` (ongoing standard) · `3 Resources` (reference) · `4 Archive`
  (inactive). A current job is an Area; a past job is Archive.
- **Utility folders:** `_inbox`, `_templates`, `_attachments`, `Daily Notes`.
- **Atomic notes**, consistent names (`Title Case` concepts, `YYYY-MM-DD`
  dailies), avoid `# | ^ [ ]`.
- **MOCs auto-fill with Dataview** (`LIST FROM "folder"`).

## Maintaining a vault

Full how-to in `references/maintenance-workflows.md`. The workflows:

1. Vault health snapshot · 2. Capture & filing · 3. MOC build & refresh ·
4. Link hygiene · 5. Orphan detection · 6. Frontmatter normalization ·
7. Dedup & rename · 8. Archive lifecycle · 9. Link-safe editing checklist.

## Safety — don't break links or lose content

- Moving/renaming **inside Obsidian** auto-updates `[[links]]`; moving via the
  filesystem or REST API does **not** — those links break. Prefer in-app moves;
  otherwise fix references afterward.
- Before deleting or overwriting a note, **read it first**; never delete user
  content without confirming.
- Empty folders aren't represented — create a folder by writing a note into it.
- Keep the vault on **one** sync method.

## References

- **`references/style-guide.md`** — the full official Obsidian style guide.
- **`references/queries-and-templates.md`** — Dataview and Templates (the tooling
  the official skills don't cover), plus when to prefer Bases.
- **`references/vault-organization.md`** — PARA in depth, the employer lifecycle,
  utility folders, MOCs, naming, sync, auditing an existing vault.
- **`references/maintenance-workflows.md`** — the nine MCP-aware maintenance
  workflows.

For authoring syntax (Markdown, `.base`, `.canvas`, web-clipping), defer to the
official `obsidian` plugin's skills — see "Authoring syntax" above.
