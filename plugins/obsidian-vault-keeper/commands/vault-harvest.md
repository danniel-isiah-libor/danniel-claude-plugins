---
description: Run the weekly harvest — sweep everything tagged #reusable in the Daily Notes/ and Meetings/ capture streams, and promote the durable keepers into Knowledge/ or the right project note. Capture becomes reference.
argument-hint: "[since date YYYY-MM-DD | empty = last 7 days]"
---

# /vault-harvest

Turn captured insights into reusable reference. Runs the harvest ritual from the
`vault-conventions` skill: capture streams hold raw logs; this promotes the
keepers into curated knowledge. Use the `vault-keeper` agent throughout, and the
`vault-conventions` skill for *where* things go (it takes precedence on filing).

## Scope
`$ARGUMENTS` sets the lookback window:
- empty → notes created or modified in the **last 7 days**.
- a date `YYYY-MM-DD` → everything since that date.

If the vault can't be reached (no Obsidian MCP connected and no vault path known),
ask the user for the vault location.

## Harvest (propose before promoting)
1. **Sweep.** Find every note *and* section tagged `#reusable` within the window,
   across `Daily Notes/` and `Meetings/` (the capture streams). Also flag meeting
   notes with a `## Decisions` heading whose decisions aren't yet reflected in a
   project note.
2. **Classify each candidate** by destination, per `vault-conventions`:
   - Reusable across projects (pattern / stack convention / playbook) →
     `Knowledge/{Patterns|Stacks|Playbooks}/`.
   - Specific to one project (a decision, a project-local gotcha) → that
     employer's `1 Projects/<Project>/` note.
   - Neither / not actually durable → leave in place, suggest removing the tag.
3. **Report** the candidates grouped by proposed destination, each with a
   one-line summary and where it came from. Change nothing yet.

## Promote (only after the user approves)
4. For approved **Knowledge/** items: create or expand the destination note from
   `_templates/Knowledge Note.md`; write the pattern/insight in reference voice
   (hindsight, reusable), set `used_in:` to the projects that prove it, keep the
   `#reusable` tag.
5. For approved **project** items: merge the decision/insight into the project
   note; link back to the source capture note.
6. **Leave the capture note in place** as the timestamped record — never delete
   it. The insight graduates; the log stays.
7. If any note content changed meaningfully, remind the user to run
   `/graphify --update` on the vault so the graph's reference layer catches up
   (do not run it automatically).

## Rules
- Promotion is human-judged — propose, don't auto-promote. The value of
  `Knowledge/` is that only validated keepers land there.
- Read before overwriting; never delete user content.
- Move link-safely (create-new → fix backlinks), or advise in-app moves.
- Final output: what was promoted and where, what was left in place, and the
  `/graphify --update` reminder if notes changed.
