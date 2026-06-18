---
name: documentation
description: Write clear, audience-facing documentation that ships to clients, users, and stakeholders — user guides, how-to / getting-started guides, feature documentation, FAQs, and release notes. Use when creating or improving end-user or stakeholder documentation. Primary skill of the technical-writer.
---

# Documentation

Run `project-adaptation` first; follow the project's existing docs conventions, format, and location. Document only what's true — verify against the code, the running feature, or existing docs.

## Audience first
Decide who reads this and what they want to do, then write for them:
- **End users / clients** — task-focused, plain language, no internal jargon.
- **Admins / operators** — setup, configuration, troubleshooting.
- **Stakeholders** — what it does and the value, light on mechanics.

## Pick the right type (Diátaxis)
- **Tutorial / getting-started** — learning by doing; a guided first success.
- **How-to guide** — steps to accomplish a specific real task.
- **Feature documentation / reference** — what each feature/option does, accurately and completely.
- **Explanation** — background and the "why".
- Plus **FAQ** and **release notes** as needed.

Outlines for each are in `references/doc-types.md`.

## Write well
- Lead with the goal; use numbered steps for procedures and short sentences.
- Show, don't just tell: concrete examples, real values, and mark where **screenshots/diagrams** belong.
- Call out prerequisites, warnings, and results ("you should now see …").
- Be consistent: one term per concept; match the product's actual UI labels; an obvious heading structure with a table of contents for longer docs.
- Accessible & maintainable: meaningful headings, alt text for images, and a version/date so docs can be kept current.

## Deliverable
Hand off clean, self-contained docs in the project's format (Markdown by default), ready for clients/users/stakeholders. Keep internal-only details out of client-facing docs.
