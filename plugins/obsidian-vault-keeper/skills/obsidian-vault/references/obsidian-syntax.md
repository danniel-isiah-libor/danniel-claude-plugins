# Obsidian Markdown dialect & features

Obsidian reads standard Markdown plus extensions. Use the standard syntax for portability; reach for extensions where they add real value. Keep notes future-proof — avoid plugin-only syntax for anything you'd hate to lose if the plugin disappeared.

## Internal links (wikilinks)

- Basic: `[[Note name]]` — links by note name (Obsidian resolves the path).
- Display text / alias: `[[Note name|what the reader sees]]`.
- Heading: `[[Note name#Heading]]`, or with alias `[[Note name#Heading|see the setup]]`.
- Block reference: append `^blockid` to a line, then link `[[Note name#^blockid]]`.
- Standard Markdown links also work: `[text](Note%20name.md)` or `[text](https://…)` for external URLs.

Prefer wikilinks for internal navigation — they survive note moves (Obsidian updates them) and power backlinks.

## Embeds / transclusion

- Embed a whole note: `![[Note name]]`.
- Embed a section: `![[Note name#Heading]]`; a block: `![[Note name#^blockid]]`.
- Embed an image/PDF/audio: `![[diagram.png]]`, `![[spec.pdf]]`. Size an image: `![[diagram.png|400]]`.

## Callouts

```markdown
> [!tip] Optional custom title
> Body text of the callout.
```

- Types: `note`, `tip`, `info`, `todo`, `warning`, `danger`/`error`, `success`/`check`, `question`/`faq`, `example`, `quote`, `abstract`/`summary`, `failure`, `bug`.
- Foldable: `> [!tip]-` starts **collapsed**, `> [!tip]+` starts **open**.
- Nest callouts by adding extra `>`.

## Properties (YAML frontmatter)

Frontmatter at the very top of a note, between `---` fences, gives typed metadata that Dataview, Bases, and search can query.

```yaml
---
tags: [project, active]
aliases: [Alt name, Acronym]
created: 2026-06-30
status: in-progress
cssclasses:
  - wide-page
---
```

- Property types: text, list, number, checkbox, date, datetime.
- Common keys: `tags`, `aliases` (alternate names that resolve in links/search), `cssclasses` (apply CSS to the note).
- Use frontmatter for structured/queryable metadata; use inline `key:: value` (Dataview inline fields) only when a value belongs in the body.

## Tags

- `#topic`, nested `#area/finance`, in body text or in the `tags` property (omit the `#` in YAML).
- Use **tags for status/type** (`#project`, `#idea`, `#draft`) and **links for relationships** between concepts. Don't mirror your folder tree as tags.

## Comments

- `%% hidden comment %%` — not rendered in Reading view. Use for editorial notes.

## Tables, math, diagrams

- Tables: standard GitHub-flavored Markdown pipes.
- Math: `$inline$` and `$$block$$` (KaTeX).
- Diagrams: fenced ` ```mermaid ` blocks render natively.

## Dataview (community plugin)

The plugin powering dynamic indexes/MOCs. Two flavors:

````markdown
```dataview
LIST
FROM "1 Projects"
WHERE file.name != this.file.name
SORT file.mtime DESC
```
````

- Query types: `LIST`, `TABLE col1, col2`, `TASK`, `CALENDAR`.
- `FROM "folder"` (quote paths with spaces) or `FROM #tag`; `WHERE`, `SORT`, `LIMIT`, `GROUP BY`.
- `dataviewjs` blocks run JavaScript for fully custom rendering (`dv.pages(...)`, `dv.container.innerHTML = …`). Heavier; use for dashboards.

Dataview must be installed and queries require the plugin to render — without it the block shows as code. Bases (core, newer) covers many table use cases without a plugin.

## Templates

Two options — pick one and keep template syntax consistent:

- **Core Templates plugin:** placeholders `{{title}}`, `{{date}}`, `{{time}}`, and formatted `{{date:YYYY-MM-DD}}`. Enable in **Settings → Core plugins → Templates**, set the template folder, insert with "Insert template". The core **Daily notes** plugin also expands `{{date}}` / `{{title}}` in its template.
- **Templater (community):** dynamic `<% tp.date.now("YYYY-MM-DD") %>`, `<% tp.file.title %>`, prompts, and scripting. More powerful; only use if installed.

A note created in a folder is what creates that folder — there are no standalone empty folders in a vault.
