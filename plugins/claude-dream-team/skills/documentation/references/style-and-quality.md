# Style guide & quality checklist

## Voice and style
- Plain language, active voice, present tense, second person ("you"). One idea per sentence; aim for short paragraphs.
- Use the product's real UI labels in **bold** exactly as shown; use `code` formatting for commands, paths, and values.
- One term per concept — define it on first use; avoid internal jargon and unexplained acronyms in client-facing docs.
- Numbered steps for procedures (one action per step, result stated), bullets for unordered facts, tables for comparisons/options.
- Warnings before the risky step, not after; label them (**Note**, **Important**, **Warning**).
- Don't promise future behavior or document unreleased/aspirational features.

## Screenshots & visuals
- Mark placeholders as `[Screenshot: <what it must show>]` when you cannot capture one; never invent UI.
- Crop to the relevant area, annotate sparingly, use alt text, and keep files in the project's docs assets folder.
- Never include real user data, tokens, internal hostnames, or secrets in images or examples — use obvious placeholders.

## Accuracy checklist (before handing off)
- [ ] Every step was verified against the running feature, the code, or authoritative docs (or marked "unverified" in the hand-off note).
- [ ] Commands, paths, and option names match the current version; version/date stated.
- [ ] Prerequisites, permissions, and roles are listed.
- [ ] Each procedure ends with an observable result ("you should see …").
- [ ] Internal-only details (infra, secrets, internal URLs) are excluded.

## Link & format check
- [ ] Internal links and anchors resolve; external links reachable (use the project's link checker, or spot-check).
- [ ] Heading hierarchy is sequential; a table of contents exists for long docs.
- [ ] Spelling/grammar pass done; terminology consistent across the doc set.
- [ ] Format and location follow the project's docs conventions.

## First-time-reader test
Re-read as someone who has never seen the product: can they finish each task using only this page? Note any gaps as questions for the team.
