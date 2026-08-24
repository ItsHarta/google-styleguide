# Punctuation

Condensed from the Google developer documentation style guide.
Sources: `/style/commas`, `/style/colons`, `/style/semicolons`, `/style/dashes`,
`/style/hyphens`, `/style/quotation-marks`, `/style/parentheses`, `/style/slashes`
(all under `https://developers.google.com`).

## Commas

- Use the serial comma before the final *and* or *or*: "zones, regions, and multi-regions".
- Put a comma after an introductory word or phrase: "Finally, only groups that contain
  parameters appear."
- Put a comma before a coordinating conjunction (*and*, *but*, *or*, *nor*, *for*, *so*,
  *yet*) joining two independent clauses, unless both are very short: "Type your ID and click
  **OK**."
- Put a comma before *which* at the start of a nonrestrictive clause. Use no comma with a
  restrictive *that* clause.
- Put a semicolon, period, or dash before a conjunctive adverb such as *however*, *otherwise*,
  or *therefore*, and a comma after it: "value; otherwise, the server returns".
- Generally don't put a comma before *because*, unless it starts a nonrestrictive clause.

## Colons

- The text before a colon must stand alone as a complete sentence.
  - Recommended: "The fields are defined as follows:"
  - Not recommended: "The fields are:"
- Start the word after a colon in lowercase, unless it's a proper noun, heading, quotation,
  or a label such as **Note**.
- Use colons to signal that closely related information follows, and with run-in headings in
  description lists.

## Semicolons

Avoid semicolons where you can. Use one only to:

- Join closely related independent clauses where a period or comma reads worse.
- Precede a conjunctive adverb or a joining phrase such as *therefore* or *that is*.
- Separate items in a complex list whose items contain their own punctuation: "Review your
  document, checking for: present tense and active voice; typos, punctuation, and grammar;
  and whether you can shorten anything."

## Dashes

- Use an em dash to mark a break in the flow of a sentence, with no spaces around it. Write
  it as `&mdash;` in HTML.
- Use at most one em dash per paragraph. Your always-on rules cap the frequency; this section
  governs the form. Where a second break needs marking, rewrite with a period, a colon, or a
  comma.
- Never reach for an em dash as the default connector. Try a period first, then a colon when
  the second clause explains the first, then a comma. Choose the em dash only when the break is
  genuinely abrupt.
- Never substitute a hyphen or en dash for an em dash.
- Don't use en dashes at all. Use a hyphen or the word *to*.
- Don't use any dash to separate an item from its description. Use a colon, a period, or an
  HTML description list: "Example: This is an example."

## Hyphens

**Prefixes**

- Generally don't hyphenate between a prefix and the main noun.
- Always hyphenate *self-* and *cross-*: self-managing, cross-region.
- Hyphenate before a capitalized noun or a number: non-Google, post-2000.
- Hyphenate when the closed form is ambiguous or hard to read: de-energize, re-mark.
- Hyphenate when the base already contains a hyphen or space: un-Google-like.

**Compound nouns**

- Write compound nouns closed: webpage, hostname, tradeoff, workaround. The word list holds
  the exceptions, such as *multi-region* and *style sheet*.
- Hyphenate multiplied units of measurement: 5 vCPU-hours.

**Compound modifiers**

- Hyphenate a compound modifier before a noun: well-designed app, Android-specific techniques.
- After *more* or *most*, hyphenate only if it aids clarity.
- Avoid compounds of three or more words; restructure instead.
- Generally don't hyphenate a compound that follows the verb: "the app is well designed".
  Always-hyphenated terms keep their hyphen: on-premises, cloud-based.

**Numbers**

- Hyphenate a number and a spelled-out unit modifying a noun: 64-bit system.
- Don't hyphenate an abbreviated unit; use a nonbreaking space: 200 GB disk.
- Use a hyphen for ranges: 8-20 files. Don't mix a hyphen with words such as *from*.

**Spacing**

- Never put spaces around a hyphen. In a suspended hyphen, a space goes after but not before
  the base term: "one- or two-hour intervals".

## Quotation marks

- Use straight double quotation marks and straight apostrophes, never curly ones. Code needs
  straight marks, so everything stays consistent.
- Put commas and periods inside the quotation marks — except when the marks enclose a literal
  string: "If you enter `escape`, the program crashes."
- Reserve single quotation marks for code examples that require them and for a quotation
  nested inside a quotation: She said, "I heard him shout 'Help,' and saw him floundering."
- Use quotation marks for the titles of shorter works, section titles that you can't link to,
  direct citations, slogans, and metaphorical terms.

## Parentheses

- Don't put important information in parentheses; readers skip it.
- Before using parentheses, check whether a comma, dash, semicolon, or period works better.
- Keep parenthetical asides short. If it runs long, write two sentences.
- If a full standalone sentence sits inside parentheses, the period goes inside too.
- Prefer a dash or a separate sentence for examples.
  - Recommended: "Enter a name for the instance — for example, `my-instance-99`."
  - Not recommended: "Enter a name (for example, `my-instance-99`)."

## Slashes

- Don't use a slash for alternatives. Write "developed or hosted", not "developed/hosted".
- Avoid "and/or". Write "export raw events, processed events, or both".
- Don't use slashes in dates or fractions. Write 0.75 or 75%, not 3/4.
- Don't use slash abbreviations. Write "care of", not "c/o"; "with", not "w/".
- Use forward slashes in file paths and URLs; use backslashes only for Windows paths.
- Break a long URL after a forward slash. Never insert a hyphen to break a URL.
