# Inclusive, accessible, and global writing

Condensed from the Google developer documentation style guide.
Sources: `/style/inclusive-documentation`, `/style/accessibility`, `/style/translation`,
`/style/jargon`, `/style/excessive-claims`, `/style/future`, `/style/timeless-documentation`
(all under `https://developers.google.com`).

## Inclusive language

**Gendered terms.** Replace *man-hours* with *person-hours*, *mankind* with *humanity*.

**Figurative language.** Avoid idiom and metaphor that translates poorly or distracts — for
example, the "pets versus cattle" comparison for system types.

**Ableist language.** Replace with precise terms:

| Avoid | Use instead |
|---|---|
| sanity-check | final check for completeness and clarity |
| crazy (of data) | baffling outliers |
| cripples (the service) | slows down |
| dummy variable | placeholder |
| hangs (a connection) | doesn't respond |
| hit | click |

**Disability.** Don't call nondisabled people "normal" or "healthy". Use identity-first
language where the community prefers it (autistic, blind, Deaf). Avoid "the disabled",
"victim of", "suffering from", and "wheelchair-bound"; write "people with disabilities",
"uses a wheelchair", "experiencing". Avoid patronizing terms such as "physically challenged"
or "differently abled".

**Established non-inclusive terms.** When the industry-standard term isn't inclusive, note it
once in parentheses, then use the inclusive term throughout: "allowlist (sometimes called a
*whitelist*)". For terms baked into code, use code font for the code item only and inclusive
terminology in the surrounding prose.

## Accessibility

- Avoid camel case and ALL CAPS; some screen readers read capitals letter by letter.
- Drop exclamation marks, question marks, and semicolons where the meaning survives without
  them. Never use `&` for *and* in headings, navigation, or a table of contents.
- Keep sentences under 26 words. Break up walls of text with paragraphs, headings, and lists.
- Define acronyms on first use, and again if the term recurs only rarely.
- Use parallel structure across similar items, and put key information in the opening sentence.
- Left-align text. Don't center or full-justify.
- Write descriptive, unique headings. Don't skip heading levels, don't leave a heading without
  content, and use CSS rather than heading level for visual formatting.
- Write link text that makes sense out of context. Explain unexpected behavior such as a new
  tab or a download. Separate adjacent links with a character.
- Give every image alt text; decorative images take `alt=""`. Never put new information only in
  an image, and never use an image of text, code, or terminal output.
- Provide captions, transcripts, or descriptions for audio and video. Never use flickering or
  flashing elements.
- Every form input needs a `label` element outside the field. Make error messages explicit:
  "Name is a required field."
- Never rely on color, size, or position alone to carry meaning. Refer to elements by their
  label, not their position, and avoid directional language.
- Test that the page still works without sound, images, color, or punctuation.

## Global audience

- Use the simple word: not *commence*, *consequently*, or *utilize*.
- Write shorter sentences.
- Avoid phrasal verbs where you can. *Set up*, *log in*, and *sign in* are fine.
- Use at most two nouns as modifiers: "cloud-native DevSecOps pipeline", not "hybrid
  cloud-native DevSecOps pipeline".
- Put a modifier immediately before what it modifies: "Request only one token", not "Only
  request one token".
- Repeat a word when it aids comprehension: "has started and if you're able", not "has started
  and you're able".
- Keep helper words such as *then*, *that*, and *of*: "If not found, then the default is
  returned."
- Use exactly the same term, with the same capitalization, every time you mean the same thing.
- Omit colloquialisms, idioms, slang, humor, culturally specific references, holidays, sports
  references, and seasons. Write dates unambiguously.
- Use a diverse set of example names.
- Images aren't translated, so never carry new information in one.

## Jargon

- Avoid jargon. Use it only when readers actually search for the term.
- If a specialized term runs through the document, describe it in parentheses on first
  reference or link to a trusted definition.
- If it appears once, describe it in plain language and put the jargon in parentheses.
- If it's a code item, use the term only in direct reference to the code, formatted as code.

Before using a jargon term, ask: can you write around it, can you replace it with a more
specific term, does it appear once or throughout, and is it in a command or code sample?

Replacements: *affected area* or *spatial impact* for "blast radius"; *import* or *load* for
"ingest"; *ready-made* or *pre-built* for "off-the-shelf". Reconsider: swim lane, break-glass
procedure, solution, workload, post-mortem, back-of-the-envelope design.

## Excessive claims

An excessive claim asserts something about performance, cost, or security that isn't easily
verifiable, could be invalidated later, or is subjective or disparaging.

- Avoid superlatives about products: *best*, *simplest*, *fastest*, *never*, *always*.
- Use *ensure* and *guarantee* only for something genuinely guaranteed. Prefer "helps with" or
  "designed for".
- Cite the source behind any specific performance number.
- Never claim something *prevents* an attack — one breach falsifies it. Write "part of a
  strategy that helps prevent" instead.
- Recommended: "Helps prevent account takeovers from phishing attacks."
  Not recommended: "Prevents account takeovers from phishing."
- Avoid direct competitive comparisons. Explain the architecture and link to a comparison
  instead of writing "Our product is faster than ExampleCorp's".

## Future features

- Don't document future features or products, even in innocuous ways.
- Don't pre-announce anything in documentation without approval from legal counsel.

## Timeless documentation

- Document how the product works now, not how it changed or will change.
- Remove: *currently*, *now*, *new*, *soon*, *latest*, *existing*, *eventually*, *presently*,
  *as of this writing*. The documentation's existence already implies "currently".
- Recommended: "The following options aren't supported."
  Not recommended: "The following options aren't currently supported."
- If you must say *new*, anchor it: "The January 14, 2021 release includes a new resource
  panel."
- Time-based language is fine in blog posts, press releases, and release notes.
