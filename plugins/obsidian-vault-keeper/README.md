# obsidian-vault-keeper

An active Obsidian **vault steward** for Claude Code. Summon it whenever you work
in your Obsidian vault and it does the maintenance — it reads and edits the
vault, it doesn't just advise.

## What's inside

- **`vault-keeper` agent** — a senior Obsidian librarian. Surveys the vault,
  applies best-practice conventions (or the vault's own), and performs the work:
  capture and file into PARA, build/refresh MOCs, fix broken links, find orphans,
  normalize frontmatter, safely dedupe/rename, run the archive lifecycle.
- **`obsidian-vault` skill** — the stewardship knowledge base: the official
  Obsidian style guide, PARA vault organization, MCP-aware maintenance workflows,
  and Dataview/Templates. Authoring syntax (Obsidian Flavored Markdown, `.base`,
  `.canvas`) defers to the required official `obsidian` plugin (below).
- **`/vault-checkup` command** — a read-only health sweep (orphans, broken links,
  frontmatter drift, misfiled/duplicate notes, stale MOCs) that reports findings
  and offers to fix.

## Requires the official `obsidian` plugin

This plugin **complements** — it doesn't duplicate — the official
[`obsidian`](https://github.com/kepano/obsidian-skills) plugin by Steph Ango /
kepano (Obsidian's creator). Install that alongside this one: `vault-keeper` owns
*stewardship* (organizing and maintaining the vault) and defers all Obsidian
**authoring syntax** to the official skills — `obsidian-markdown` (Markdown),
`obsidian-bases` (`.base`), `json-canvas` (`.canvas`), `obsidian-cli` (shell), and
`defuddle` (web-clipping). Because those skills update on their own, this plugin
references them by name rather than copying them, so they never drift.

## Obsidian access

The agent prefers the **Obsidian MCP** (`mcp__obsidian__*`, via the Local REST API
plugin) when connected, the **`obsidian` CLI** (`obsidian:obsidian-cli`) when
Obsidian is open, and falls back to direct filesystem editing of the vault folder
otherwise. Neither the MCP nor the filesystem has a link-safe move/rename or
auto-updates `[[links]]`, so the steward treats every move as create-new →
fix backlinks → delete-old (or does it in-app).

## Install

Add via the `danniel-claude-plugins` marketplace, then invoke the `vault-keeper`
agent or run `/vault-checkup`.
