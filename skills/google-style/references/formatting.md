# Formatting and organization

Condensed from the Google developer documentation style guide.
Sources: `/style/headings`, `/style/lists`, `/style/procedures`, `/style/tables`,
`/style/dates-times`, `/style/numbers`, `/style/units-of-measure`, `/style/notices`,
`/style/images`, `/style/paragraph-structure`, `/style/cross-references`
(all under `https://developers.google.com`).

## Headings and titles

- Use sentence case for every heading and title.
- Task headings start with a bare infinitive verb: "Create a VM", not "Creating a VM".
- Conceptual headings are noun phrases: "Migration to Google Cloud", not "Migrating to
  Google Cloud".
- Avoid an *-ing* form as the first word. Gerunds such as "Billing" or "Pricing" are fine when
  there's no alternative.
- Mark an optional section with an "Optional:" prefix: "Optional: Customize your alias".
- Keep punctuation simple. Don't number headings to show sequence.
- Don't put links in headings. Avoid code items in headings; if one is unavoidable, add a
  descriptive noun.
- Use exactly one h1 per page. Don't skip heading levels, and don't leave a heading empty.
- Use an abbreviation in a heading only if it's widely known, then define it in the first
  paragraph below.
- Introduce subsections with the phrase "the following sections".

## Paragraphs

- One idea per paragraph, in the fewest words and sentences possible.
- A paragraph longer than five or six sentences usually carries too much. Break it up.
- A single-sentence paragraph is fine when it holds one complete idea.
- Put the critical information first. Don't bury the key point at the end.
- Left-align text. Never center, right-align, or full-justify. Never force a line break inside
  a sentence.

## Lists

- Use a **numbered list** when sequence matters: ordered steps, phases, priorities.
- Use a **bulleted list** for a set that isn't a sequence.
- Use a **description list** for terms paired with definitions.
- Introduce a list with a complete sentence, not a fragment the items complete.
- Start each item with a capital letter, unless case is significant, as in a code term.
- Omit the end period when an item is a single word, has no verb, is entirely in code font, or
  is entirely link text or a document title. Otherwise punctuate normally.
- Use the same syntax and structure for every item in a list.
- Number nested sequential lists with lowercase letters, then lowercase Roman numerals.
- Run-in headings start with a capital. End them with a period or a colon consistently: after
  a period, capitalize the description; after a colon, use lowercase.

## Procedures

- Introduce a procedure with an imperative statement, and use a colon when it directly
  precedes the steps: "Customize the buttons:". Don't just repeat the heading.
- Format a single-step procedure as a bullet, not a numbered list: "To clear the entire log,
  click **Clear logcat**."
- Label sub-steps with lowercase letters and sub-sub-steps with lowercase Roman numerals.
- State the goal before the action: "To start a new document, click **File > New > Document**".
- State the location before the action: "In Google Docs, click **File > New > Document**".
- Order each step as: action, then commands, then placeholder explanations, then output. Keep
  the result in the same paragraph as the action.
- When several methods exist, document only the shortest and simplest one.
- Mark an optional step with "Optional:" — never "(Optional)".
- Never use directional language ("above", "below", "on the right-hand side"), keyboard
  shortcuts, or "please". Link to a procedure instead of repeating it.

## Tables

- Use a table when each item carries three or more related pieces of data. Use a list for
  single units, and a description list or table for term-definition pairs.
- Don't use tables for page layout, code snippets, or a long one-dimensional list split across
  columns. Avoid single-row tables and convert single-column tables to lists.
- Don't put a table in the middle of a numbered procedure.
- Introduce a table with a complete sentence describing its purpose, using "the following
  table" or "the preceding table". End with a colon if the table follows immediately.
- One table needs no caption. With several, caption each as "**Table NUMBER.** DESCRIPTION" in
  sentence case with no end period.
- Column headers: sentence case, concise, no end punctuation. Use `th` with a `scope`
  attribute on the first row and first column.
- Use `<p>` elements for multi-paragraph cells, not `<br>`. Don't merge cells with `colspan`
  or `rowspan`, and don't style table elements.

## Notices

Use notices sparingly; readers skip them, and overuse destroys their effect. Don't stack two
notices together.

- **Note** — useful but not critical information.
- **Caution** — proceed with care.
- **Warning** — stronger than a caution. Use for irreversible actions or serious consequences.
- **Success** — an error-free status. Interactive content only.

Use a note only when all three hold: the information is relevant but not necessary for the
reader to succeed, the interruption doesn't block their progress, and it sits outside the main
flow. Never put a cross-reference, a prerequisite, or a procedural step in a note.

## Numbers

- Spell out zero through nine; use numerals for 10 and above.
- Always use numerals for version numbers, technical quantities, page numbers, and chapter
  numbers, even below 10.
- Spell out a number that starts a sentence. Indefinite quantities such as "millions" stay as
  words.

## Units of measurement

- Put a nonbreaking space between the number and the unit: `64&nbsp;GB`.
- No space for currency, percent, or degrees: $10, 65%, 180°.
- Temperature: `50&nbsp;°&nbsp;C`. Kelvin drops the degree symbol: `300&nbsp;K`.
- Repeat the unit in a range and use *to*: "-40 °C to 85 °C".
- Hyphenate multiplied units: "5 vCPU-hours", "40 person-hours".
- Thousands use a lowercase k with no space, plus a noun: "55k requests".
- Disambiguate currency with an indicator before the amount: US$10.
- Prefer "per" to a slash: "requests per day".
- Don't confuse decimal and binary bytes: MB is 1000², MiB is 1024².

## Dates and times

- Use the 12-hour clock unless 24-hour is required. Capitalize AM and PM with a space before:
  3:45 PM. Drop the minutes on round hours: 3 PM. "noon" and "midnight" are fine.
- Time ranges use a hyphen with no spaces: "5-10 minutes ago".
- Avoid time zones unless necessary. Spell the region out with the offset in parentheses:
  "US and Canadian Pacific Standard Time (UTC-8)". Never abbreviate a time zone name.
- Spell out the full month name and use a four-digit year: January 19, 2017.
- Month and year alone take no comma: "hired in January 2017". A full date mid-sentence takes
  a comma after the year: "The January 19, 2017, release".
- Numeric dates use ISO 8601: 2017-04-15. In examples, pick a day above 12 to avoid ambiguity.
- Date before time: "May 4, 2009, at 6 PM".
- Avoid season names; name the month or quarter instead.

## Figures and images

- Use an image only when it explains something words handle poorly. Never use an image for
  code, text, or terminal output.
- Prefer SVG, fall back to PNG, and avoid transparent backgrounds. Use MP4 rather than an
  animated GIF. Crop screenshots to only what matters.
- Give every informative image concise, descriptive alt text: at most 155 characters, a full
  sentence or noun phrase, punctuated, no all-caps, and no "Image of" or "Photo of" prefix.
  Decorative images take `alt=""`.
- For a complex image, pair brief alt text with a fuller description nearby.
- Captions are optional but recommended: "**Figure NUMBER.** DESCRIPTION", complete sentences,
  with end punctuation. Refer to figures by number, never by position ("above").
- Keep images at most 856px wide, or 1712px for the 2x version supplied through `srcset`.
  Never scale a 1x image up to make a 2x. Don't center images or nest `img` inside `p`.

## Cross-references and linking

- Be selective. Every link adds a decision and cognitive load. Prefer explaining on the page.
- Don't link to the same destination twice unless the page is very long or the entry points
  genuinely differ.
- Write link text as a short, unique, descriptive phrase with the important words first.
- Never use "click here", "this document", "this article", or a bare URL as link text.
- Include the abbreviation in the link: "Google Kubernetes Engine (GKE)".
- Introduce links consistently: "For more information, see …" or "For more information about
  X, see …". Use *see*, not *on*.
- For a same-page link, say so: "the [section title](#anchor) section of this document".
- Don't force links to open in a new tab. If one must, say "(opens in a new tab)".
- Put punctuation outside the link. Don't put quotation marks around link text, and never
  underline anything that isn't a link.
