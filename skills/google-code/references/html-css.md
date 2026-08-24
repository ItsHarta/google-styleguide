# HTML and CSS

Condensed from the Google HTML/CSS style guide,
`https://google.github.io/styleguide/htmlcssguide.html`.

## General

- Indent two spaces. Never use tabs, and never mix them with spaces.
- Write all code in lowercase: element names, attributes, attribute values, selectors,
  properties, and property values. Text content, CDATA, and quoted strings keep their own case.
- Remove trailing whitespace.
- Encode files as UTF-8 without a byte order mark, and declare it with `<meta charset="utf-8">`.
- Use HTTPS for an embedded resource wherever the resource offers it.
- The guide sets no hard column limit; its line-wrapping section is optional. Where you do wrap,
  indent the continuation four spaces.
- Mark a work item with `TODO` and a contact: `<!-- TODO(jane.doe): drop the fallback -->`.
- Comment what isn't self-evident: what a section covers, what a rule works around, and why.

## HTML

- Declare HTML5 with `<!DOCTYPE html>`. Don't write XHTML.
- Use valid HTML wherever practical, and validate it.
- Use each element for its actual purpose. A heading is `<h1>`–`<h6>`, a paragraph is `<p>`, and
  an anchor is `<a>` — not a `<div>` wearing a class.
- Give every non-decorative image `alt` text, and give every other multimedia element fallback
  content. A decorative image takes `alt=""`.
- Separate structure, presentation, and behavior. Keep markup in HTML, styling in stylesheets,
  and behavior in scripts. Don't write inline styles or inline event handlers.
- Don't use an entity reference unless the character has special meaning in HTML — `&amp;`,
  `&lt;` — or is invisible. The file is UTF-8, so write the character itself.
- Omit the `type` attribute on a stylesheet link and on a script tag. Both default correctly.
- Avoid an `id` attribute where a class or a `data-` attribute works. An `id` must be unique
  across the document, which makes it brittle to reuse.
- Consider omitting optional tags for file size and scannability. The HTML5 specification
  defines which ones may be omitted.
- Put every block, list, and table element on its own line, and indent every child element.
- Quote every attribute value with double quotes.

## CSS

- Use valid CSS wherever practical.
- Name a class for what it means, not for how it looks. `.gallery` and `.aux` survive a redesign;
  `.blue-left-column` doesn't.
- Keep a class name as short as it can be while staying clear.
- Separate the words in an ID or class name with a hyphen. Don't concatenate and don't use
  underscores.
- Don't qualify a class selector with a type selector. Write `.example`, not `ul.example` — the
  qualifier costs performance and blocks reuse.
- Prefer a class selector to an ID selector in every situation. An `id` has to stay unique across
  a whole page, which many engineers working on many components can't guarantee.
- Avoid `!important`. It breaks the cascade and makes styles hard to compose. Raise selector
  specificity instead.
- In a large project, or code embedded elsewhere, prefix class names as a namespace: a short
  unique identifier followed by a dash.
- Use shorthand properties wherever the shorthand says what you mean: `padding: 0 1em 2em;`
  rather than four declarations.
- Omit the unit after a `0` value: `margin: 0;`.
- Always include the leading zero in a value between -1 and 1: `font-size: 0.8em;`. (The guide
  reversed this at some point; the current text says to include it.)
- Use three-character hexadecimal notation where it's equivalent: `#ebc`, not `#eebbcc`.
- Avoid CSS hacks and user-agent detection. They break on the next browser release; solve the
  problem differently.
- Sort declarations consistently across a project. Absent tooling that enforces an order, the
  guide suggests alphabetical. Ignore vendor prefixes when sorting, but keep multiple prefixes
  for one property in order (`-moz` before `-webkit`).
- Indent all block content one level.
- End every declaration with a semicolon, including the last one in a block.
- Put a space after the colon in a declaration, and none before it.
- Put a space between the last selector and the opening brace.
- Put each selector and each declaration on its own line.
- Separate rules with a blank line.
- Group sections of a stylesheet with comments, separated by blank lines: `/* Header */`.
- Use single quotes for an attribute selector and for a property value, and don't quote the
  argument to `url()`. The one exception is `@charset`, which requires double quotes.
- In HTML, quote attribute values with double quotes. The two languages differ here.
