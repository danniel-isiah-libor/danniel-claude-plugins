---
name: project-context
description: Pull the current repo's business rules and domain context from the Obsidian vault while coding — and write discoveries back. Use in any coding session in a work repo BEFORE implementing or changing domain/business logic (validations, calculations, state transitions, workflows, integrations), when asking "why does this app do X", or when a business rule is discovered, changed, or contradicted by code. Locates the repo's matching vault project note via the CLAUDE.md pointer or the note's repo frontmatter key, reads its Business Rules section on demand, consults Knowledge/ for cross-project patterns, and updates the note when rules change. If no matching note exists, suggests /vault-wire.
---

# Project context — the repo ↔ vault bridge

The vault at `/Users/dannielibor/Documents/Obsidian Vault` is the source of truth
for the *why* behind work repos: business rules, domain decisions, and
cross-project patterns. Code says what the app does; the vault note says why.
This skill is the read/write protocol between a coding session and that note.

## Locate the repo's project note

Try in this order; stop at the first hit:

1. **CLAUDE.md pointer** — a `## Knowledge sources` section in the repo's
   `CLAUDE.md` naming the vault note path. Trust it.
2. **`repo:` frontmatter match** — take `git remote get-url origin`, normalize
   (`https`/`ssh` forms, trailing `.git`), and search
   `Work/*/1 Projects/` and `Work/*/4 Archive/` project notes for a matching
   `repo:` key.
3. **Name match** — repo folder name against project note titles/folders.
   Weakest signal; confirm with the user before relying on it.

**No match →** say so once, suggest running `/vault-wire` to scaffold and wire
the note, and continue without vault context rather than guessing.

## Read protocol

- **Before changing domain logic**, Read the note's `## Business Rules` section.
  Pull on demand — read the note, not the vault; never bulk-load `Work/`.
- **Before designing something that feels general** (an integration shape, queue
  design, auth flow, deployment step), check `Knowledge/Patterns/`,
  `Knowledge/Stacks/`, `Knowledge/Playbooks/` for an existing answer first.
- Treat the note as authoritative for intent. When **code contradicts the
  note**, surface the conflict to the user — do not silently pick a side.

## Write-back protocol

- **Discovered a rule** the note doesn't have (unearthed from legacy code,
  stated by the user, decided during the session)? Add it to the note's
  `## Business Rules` in the same session — short, declarative, hindsight voice.
- **Changed a rule** in code? Update the note in the same change. The note and
  the code must not drift.
- A rule that now applies to **more than one project** is a harvest candidate:
  tag it `#reusable` in place and let `/vault-harvest` promote it to
  `Knowledge/` with `used_in:` links — don't copy it between project notes.

## Precedence

- `vault-conventions` owns *where* notes live and their frontmatter — defer to
  it for any filing or formatting decision.
- This skill owns *when* a coding session reads from and writes to the vault.
- Authoring syntax (wikilinks, callouts, properties) → the official
  `obsidian:*` skills.
