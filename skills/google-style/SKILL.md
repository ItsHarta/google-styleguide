---
name: google-style
description: Apply the Google developer documentation style guide when drafting or editing documentation, READMEs, runbooks, release notes, PR bodies, code comments, or any long-form prose. Use when writing or reviewing written material for voice, grammar, punctuation, formatting, code notation, inclusive language, or word choice.
---

# Google developer documentation style guide

Condensed from `https://developers.google.com/style`. Your always-on instructions carry the
rules that apply to every turn; this skill carries the depth. Those instructions live in
`~/.claude/CLAUDE.md` for Claude Code, and in `~/.agents/AGENTS.md` for Codex and
Antigravity.

## Where to look

Open the one file that matches your question. Don't read them all.

| Question | File |
|---|---|
| Is this the right word? What's the preferred spelling or product name? | `references/word-list.md` |
| Voice, tone, tense, pronouns, capitalization, abbreviations, contractions | `references/language.md` |
| Commas, colons, semicolons, dashes, hyphens, quotes, parentheses, slashes | `references/punctuation.md` |
| Headings, lists, procedures, tables, numbers, units, dates, notices, images, links | `references/formatting.md` |
| Code font, code samples, placeholders, CLI syntax, UI elements, filenames | `references/code.md` |
| Inclusive terms, accessibility, global audience, jargon, claims, timeless writing | `references/inclusive.md` |
| Source code itself — Python, Go, Shell, TypeScript, HTML/CSS, JSON, Markdown syntax, or reviewing a change | the `google-code` skill |

## Highlights

**Tone and content**

- Be conversational and friendly, but not frivolous.
- Don't pre-announce anything.
- Use descriptive link text.
- Write accessibly, and write for a global audience.

**Language and grammar**

- Use second person: *you*, not *we*.
- Use active voice — make clear who performs the action.
- Use standard American spelling and punctuation.
- Put conditions before instructions.

**Formatting, punctuation, and organization**

- Use sentence case for document titles and section headings.
- Use numbered lists for sequences, bulleted lists for everything else, and description lists
  for pairs of related data.
- Use serial commas.
- Put code-related text in code font and UI elements in bold.
- Format dates unambiguously.

**Images**

- Provide alt text.
- Deliver high-resolution or vector images where practical.

## Text-formatting summary

| Item | Format |
|---|---|
| Code, filenames, class and method names, HTTP status codes, console output | `code font` |
| UI elements, run-in headings | **bold** |
| Placeholders | `UPPERCASE_WITH_UNDERSCORES`, in `<var>` in HTML |
| Mathematical variables | *italic* (operators stay upright) |
| Full-length works — books, films | *italic*, except inside a link |
| Shorter works — articles, section titles | "quotation marks" |
| Links | underline only; never underline anything else |

Never override font styles inline, and never use an ampersand as a conjunction.

## Precedence

Your always-on instructions set the order: epistemic rules, data handling, and refusals beat
this guide. A friendly tone never softens a `don't know`, and never turns an
unverified claim into a confident one. Domain identifiers — CWE, CVE, ATT&CK, OWASP, RFC —
stay exact regardless of the guide's advice on jargon.
