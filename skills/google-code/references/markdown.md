# Markdown

Condensed from the Google Markdown style guide,
`https://google.github.io/styleguide/docguide/style.md`. For the wording inside the document,
use the `google-style` skill; this file covers the syntax and layout.

## Philosophy

- Minimum viable documentation. A short, current document beats a long, stale one.
- Better is better than perfect. Ship an improvement rather than waiting on a rewrite.
- Strongly prefer Markdown to HTML. Drop to HTML only for something Markdown can't express.

## Document layout

Order a document as:

1. `# Document title` — exactly one H1, and the first line of the file.
2. A short introduction: one or two paragraphs saying what the document covers and who it's for.
3. `[TOC]`, if the renderer supports it.
4. `## Topic` sections.
5. `## See also`, linking to related documents.

## Headings

- Use ATX headings — `## Heading` — never the underline (setext) style.
- Put a space after the `#` characters, one blank line before every heading, and one after.
- Use sentence case, as the prose style guide requires.
- Keep every heading in a document unique, so a link to its anchor stays unambiguous.
- Don't skip a level. An `###` belongs under an `##`.

## Line length and whitespace

- Follow the project's character limit. Where none exists, wrap at 80 characters.
- A long URL and a wide table are the usual exceptions. Don't break either to hit the limit.
- Don't use trailing whitespace to force a line break. Use a trailing backslash where you need
  a hard break.
- Don't leave trailing whitespace anywhere else.

## Lists

- Use lazy numbering for a long or frequently-edited ordered list: write `1.` on every item and
  let the renderer number them, so inserting an item doesn't renumber the file.
- Number a short, stable ordered list explicitly.
- Use a consistent bullet character throughout a document.
- Indent a nested list, and any wrapped text under an item, by four spaces.
- Put a blank line before a list that follows a paragraph.

## Code

- Use a fenced code block, and declare the language on the opening fence so it highlights.
- Indent a code block inside a list item to match the item's content.
- Use backticks for inline code: a filename, a flag, a command, a symbol name, or console
  output.
- Escape a long command's line breaks with a trailing backslash, matching what the reader will
  actually type.
- Don't put a shell prompt in a block the reader is meant to copy.

## Links, images, and tables

- Write informative link text that describes the destination. Never write "here", "this link",
  or a bare URL.
- Use a reference link — `[text][ref]` with the target defined at the bottom — when an inline
  URL would wreck the line.
- Prefer a relative link between documents in the same repository, so the link survives a move
  or a fork.
- Use images sparingly, and prefer a simple screenshot to a diagram that goes stale. Give every
  image alt text.
- Use a table for tabular data only, never for layout. When the content is really a list, use a
  list — it reads better and wraps better.
- Keep a table narrow enough to read as source text. If it can't be, that's a sign the content
  wants a different shape.

## Naming and capitalization

- Name a Markdown file in lowercase with hyphens: `deployment-runbook.md`.
- Write a product or tool name exactly as its owner writes it. Use sentence case for everything
  else.
