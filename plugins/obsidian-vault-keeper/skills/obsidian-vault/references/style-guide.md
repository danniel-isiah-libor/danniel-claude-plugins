# Obsidian style guide

Conventions for writing Obsidian documentation and notes, from the official Obsidian style guide (<https://obsidian.md/help/style-guide>). Apply these when authoring or editing notes in a vault.

## Terminology and grammar

- Use **Global English** to serve a worldwide audience and assist translation — avoid idioms and culturally-specific expressions.
- Use **active voice** and direct sentence construction.
- Prefer **simple, common words** over complex terminology; be explicit rather than implied.
- Use **American English** spelling ("organize", not "organise").

### Preferred terms

| Avoid | Prefer |
|-------|--------|
| hotkey | keyboard shortcut |
| tap / click | select (on mobile, "tap" is acceptable) |
| synchronise / synchronising | sync / syncing |
| search query | search term |
| header | heading |
| max / min | maximum / minimum |
| side bar | sidebar |
| invoke / execute | perform |
| note title | note name |
| current note | active note |
| directory | folder |
| file format | file type |
| top-left / top-right | upper-left / upper-right |

- "**note**" = a Markdown file in the vault; "**file**" = a non-Markdown file. Use "file type" unless specifically referencing a data format.
- **Product names** begin with "Obsidian" (Obsidian Publish, Obsidian Sync). Use the short form in later references if the paragraph gets repetitive.
- For moving between notes: use "open" if the destination is hidden, "switch" if both are visible in splits.

## Instructions and headings

- **Imperative mood** for guide names, section headings, and step-by-step instructions: "Set up" (not "Setting up"), "Move a file" (not "Moving a file").
- **Sentence case** for headings, buttons, and titles: "How Obsidian stores data" (not "How Obsidian Stores Data"). Match the exact case of UI elements when referencing them.

## Directional terms

- **Hyphenate when used as an adjective:** "bottom-left corner". **No hyphen when the direction is a noun:** "bottom left".
  - Recommended: "Select **Settings** in the bottom-left corner" or "…in the bottom left".
  - Not recommended: "…in the bottom left corner".
- Use "**above**" and "**below**" for vertical relationships (not "up"/"down").
- Avoid directional language for settings — their location varies by device. Prefer "The search box appears above the file list."

## Key names and keyboard shortcuts

- Individual keys: **Key name (character)** — "Press the hyphen (-) key", "Use the question mark (?)".
- Shortcuts: no spaces around the plus sign — `Ctrl+Z`. Specify both when they differ by OS: "`Ctrl+Z` (Windows) or `Command+Z` (macOS)". Windows and Linux usually share shortcuts; omit the OS when identical cross-platform.
- Avoid: `Cmd+Z`, `Ctrl + Z` (spaces), `Ctrl/Cmd+Z`.

## Markdown formatting

- Use **newlines between Markdown blocks** (headings, paragraphs, lists).
- Use **em dashes (—)** to separate bolded terms from their descriptions in bullet lists: "**View menu** — create, edit, and switch views". Do not use em dashes in simple nested bullet lists with links.
- Prefer **realistic examples** over nonsense terms: `task:(call OR schedule)`, not `task:(foo OR bar)`.

## Callouts

| Type | Syntax | Use case | Recommended state |
|------|--------|----------|-------------------|
| Tip | `> [!tip]-` | Practical advice, shortcuts, non-essential helpful info | Collapsed |
| Info | `> [!info]+` | Background, clarifications, context | Open |
| Warning | `> [!warning]+` | Cautions preventing data loss or errors | Never collapse |
| Example | `> [!example]-` | Tangential / supplementary detail | Collapsed |

These are authoring recommendations, not built-in behavior: a bare `> [!tip]` is open by default — the fold state comes from the `-` (collapsed) / `+` (open) suffix. Full callout syntax is authoritative in `obsidian-syntax.md`.

## Lists, prose, and tables

- **Use lists for:** unrelated features, installation requirements, configuration options, troubleshooting steps.
- **Use prose for:** how-something-works explanations, workflows with dependencies, conceptual overviews, guidance that needs context.
- **Use tables** to compare features, versions, or related data points — not for simple lists or single-column data.

## Cross-references

- Use internal wiki links `[[Note name]]` liberally.
- Avoid linking the same term multiple times on one page.
- Link only when the referenced page adds significant context.
- Use descriptive link text: `[[Note name#Section|descriptive text]]`.

## Platform-specific content

- Organize with section headings; use "Desktop" and "Mobile" as subsection headings.
- Only create separate sections when content significantly differs; use inline notes for minor variations.
- When a feature differs by platform, document steps for both mobile and desktop.

## Icons and images

- Include images only when they clarify hard-to-describe concepts. Use `.png` or `.svg`.
- Store images in an `Attachments` folder; store icons in `Attachments/icons`.
- Icons: source from Lucide or custom Obsidian icons; prefix `lucide-` or `obsidian-icon-`; 18×18 px; stroke width 1.5; use SVG; wrap in parentheses with the `#icon` anchor — `(![icon.svg#icon])`.

### Image anchor tags

| Anchor | Syntax | Effect |
|--------|--------|--------|
| icon | `![image.svg#icon]` | Correct vertical alignment for UI indicators |
| interface | `![image.png#interface]` | Adds a decorative box shadow |
| outline | `![image.png#outline]` | Adds a subtle border |

Anchor tags don't render in Live Preview — confirm in Reading view.

- **Optimize** images (recommended 65–75%) to reduce load time and storage while keeping visual integrity (FileOptimizer / ImageOptim / Trimage).
- State dimensions as "**width** x **height** pixels" — e.g. "Recommended image dimensions: 1920 x 1080 pixels".
- Show the full Obsidian window for pop-up/modal screenshots.

## Page metadata and layout

- Provide a **description** page property if missing: objective summary, **maximum 150 characters**, used for social cards and SEO.
- Check for **broken links** before submitting changes.

## Documenting settings

- Document settings inside Obsidian when possible. Use the Obsidian Help docs only when a setting needs in-depth knowledge, is commonly misused or asked about, or drastically changes the experience. Use a tip callout to draw attention to a specific setting.

## Translations

- Translate the **entirety** of content — including note names, folder names, aliases, attachment names, and alt link text.
