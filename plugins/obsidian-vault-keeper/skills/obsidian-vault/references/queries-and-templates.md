# Dataview & Templates

Obsidian's **authoring syntax** — wikilinks, embeds, callouts, properties, tags,
comments, highlights, math, Mermaid, footnotes — is owned by the official
`obsidian` plugin and must not be restated here (it auto-updates; a local copy
would drift). When you need it, use those skills:

- `obsidian:obsidian-markdown` — Obsidian Flavored Markdown.
- `obsidian:obsidian-bases` — `.base` files (database-style views).
- `obsidian:json-canvas` — `.canvas` files.

This reference covers only the two things those skills **don't**: **Dataview**
and **Templates** — the community/core tooling a steward leans on to build
dynamic MOCs and templated capture.

## Dataview (community plugin)

The plugin powering dynamic indexes/MOCs from a query. Two flavors:

````markdown
```dataview
LIST
FROM "1 Projects"
WHERE file.name != this.file.name
SORT file.mtime DESC
```
````

- Query types: `LIST`, `TABLE col1, col2`, `TASK`, `CALENDAR`.
- `FROM "folder"` (quote paths with spaces) or `FROM #tag`; `WHERE`, `SORT`,
  `LIMIT`, `GROUP BY`.
- `dataviewjs` blocks run JavaScript for fully custom rendering (`dv.pages(...)`,
  `dv.container.innerHTML = …`). Heavier; use for dashboards.

Dataview must be installed and queries only render with the plugin present —
without it the block shows as code. Keep core content plain so a note is still
readable if the plugin is removed.

## Bases vs Dataview (which to reach for)

**Bases** is Obsidian **core** (no plugin needed) and is where Obsidian is
heading for table/database views. For **new** MOCs and dashboards, prefer Bases
and author the `.base` file with `obsidian:obsidian-bases`. Keep **Dataview**
where a vault already uses it, or when you need `dataviewjs`/query types Bases
doesn't cover yet. Don't migrate a vault's existing Dataview MOCs unless asked.

## Templates

Two options — pick one and keep template syntax consistent across the vault:

- **Core Templates plugin:** placeholders `{{title}}`, `{{date}}`, `{{time}}`,
  and formatted `{{date:YYYY-MM-DD}}`. Enable in **Settings → Core plugins →
  Templates**, set the template folder, insert with **Insert template**. The core
  **Daily notes** plugin also expands `{{date}}` / `{{title}}` in its template.
- **Templater (community):** dynamic `<% tp.date.now("YYYY-MM-DD") %>`,
  `<% tp.file.title %>`, prompts, and scripting. More powerful; only use if
  installed.

A note created in a folder is what creates that folder — there are no standalone
empty folders in a vault.
