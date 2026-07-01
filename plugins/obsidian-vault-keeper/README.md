# obsidian-vault-keeper

An active Obsidian **vault steward** for Claude Code. Summon it whenever you work
in your Obsidian vault and it does the maintenance — it reads and edits the
vault, it doesn't just advise.

## What's inside

- **`vault-keeper` agent** — a senior Obsidian librarian. Surveys the vault,
  applies best-practice conventions (or the vault's own), and performs the work:
  capture and file into PARA, build/refresh MOCs, fix broken links, find orphans,
  normalize frontmatter, safely dedupe/rename, run the archive lifecycle.
- **`obsidian-vault` skill** — the knowledge base: Obsidian-flavored Markdown, the
  official Obsidian style guide, PARA vault organization, and MCP-aware
  maintenance workflows. This is the marketplace's single source of truth for
  Obsidian conventions.
- **`/vault-checkup` command** — a read-only health sweep (orphans, broken links,
  frontmatter drift, misfiled/duplicate notes, stale MOCs) that reports findings
  and offers to fix.

## Obsidian access

The agent prefers the **Obsidian MCP** (`mcp__obsidian__*`, via the Local REST API
plugin) when it's connected, and falls back to direct filesystem editing of the
vault folder when it isn't. The MCP has no move/rename tool and does not
auto-update `[[links]]`, so the steward treats every move as create-new →
fix backlinks → delete-old.

## Install

Add via the `danniel-claude-plugins` marketplace, then invoke the `vault-keeper`
agent or run `/vault-checkup`.
