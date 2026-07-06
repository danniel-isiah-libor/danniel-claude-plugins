---
name: project-context
description: Pull the current repo's business rules and domain context from the Obsidian vault while coding — and write discoveries back. Use in any coding session in a work repo BEFORE implementing or changing domain/business logic (validations, calculations, state transitions, workflows, integrations), when asking "why does this app do X", or when a business rule is discovered, changed, or contradicted by code. Context is EMPLOYER-SCOPED — locates the repo's matching vault project note via the CLAUDE.md pointer or the note's repo frontmatter key, derives the employer folder from it, and stays inside that employment - the project note's Business Rules, sibling project notes, the employer's 3 Resources, and daily/meeting captures related to that employer. If no matching note exists, suggests /vault-wire.
---

# Project context — the repo ↔ vault bridge (employer-scoped)

The vault at `/Users/dannielibor/Documents/Obsidian Vault` is the source of truth
for the *why* behind work repos: business rules, domain decisions, and per-employer
reference. Code says what the app does; the vault says why.

**The scope rule:** a repo belongs to one employment. Once the project note is
located, its employer folder (`Work/<Employer>/` or
`Work/_Past Employers/<Employer>/`) is the **context boundary** — everything the
session pulls from the vault lives inside it, plus the capture streams filtered to
that employer. Never roam other employers' folders or `Personal/`.

## Locate the project note → derive the employer root

Try in this order; stop at the first hit:

1. **CLAUDE.md pointer** — a `## Knowledge sources` section in the repo's
   `CLAUDE.md` naming the vault note path. Trust it.
2. **`repo:` frontmatter match** — take `git remote get-url origin`, normalize
   (`https`/`ssh` forms, trailing `.git`), and search `Work/*/1 Projects/` and
   `Work/*/4 Archive/` (including `_Past Employers/`) for a matching `repo:` key.
3. **Name match** — repo folder name against project note titles/folders.
   Weakest signal; confirm with the user before relying on it.

The **employer root** is the ancestor folder directly under `Work/` (or under
`Work/_Past Employers/`). Everything below is read relative to it.

**No match →** say so once, suggest running `/vault-wire` to scaffold and wire
the note, and continue without vault context rather than guessing.

## Read protocol — what's in scope

- **Before changing domain logic**, Read the project note's `## Business Rules`
  section. Pull on demand; never bulk-load the employer folder.
- **Before designing something that feels general** (an integration shape, queue
  design, auth flow, deployment step), check — inside the employer root only:
  - `3 Resources/` — the employer's reusable reference (patterns, stack
    conventions, playbooks, with `used_in:` links to the projects that prove them);
  - sibling notes under `1 Projects/` (and `4 Archive/`) — how the employer's
    other projects solved it.
- **Captures related to this employment**: when recent context matters (a
  decision from this week, a meeting outcome), search `Daily Notes/` and
  `Meetings/` for entries matching the employer — `company:` frontmatter on
  meeting notes, or text mentions of the employer/project name. Captures are
  logs, not reference: quote them for recency, trust project notes for truth.
- Treat the project note as authoritative for intent. When **code contradicts
  the note**, surface the conflict to the user — do not silently pick a side.

## Write-back protocol

- **Discovered a rule** the note doesn't have (unearthed from legacy code,
  stated by the user, decided during the session)? Add it to the note's
  `## Business Rules` in the same session — short, declarative, hindsight voice.
- **Changed a rule** in code? Update the note in the same change. The note and
  the code must not drift.
- A technique that now applies to **more than one of this employer's projects**
  gets promoted: write it once in the employer's `3 Resources/` with `used_in:`
  links to the projects that prove it — don't copy it between project notes.
  Do it in the same session; if there's no time, leave a one-line stub in the
  destination note so it isn't lost.

## Precedence

- `vault-conventions` owns *where* notes live and their frontmatter — defer to
  it for any filing or formatting decision.
- This skill owns *when* a coding session reads from and writes to the vault,
  and the employer-scope boundary.
- Authoring syntax (wikilinks, callouts, properties) → the official
  `obsidian:*` skills.
