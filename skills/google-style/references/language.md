# Language and grammar

Condensed from the Google developer documentation style guide.
Sources: `/style/tone`, `/style/person`, `/style/active-voice`, `/style/tense`,
`/style/pronouns`, `/style/capitalization`, `/style/contractions`, `/style/anthropomorphism`,
`/style/sentence-structure`, `/style/articles`, `/style/possessives`, `/style/prepositions`,
`/style/abbreviations`, `/style/pluralization` (all under `https://developers.google.com`).

## Voice and tone

- Write in a conversational, friendly, and respectful tone. Sound like a knowledgeable friend
  who understands what the developer wants to do.
- Be casual, natural, and approachable — not pedantic, pushy, or overly formal.
- Keep it concise and direct. The primary purpose of the document is to provide information.
- Avoid: buzzwords, jargon, clichés, figurative language, metaphors, ableist language,
  culturally specific references, and internet slang such as "tl;dr" or "ymmv".
- Avoid placeholder phrases such as "please note" and "at this time".
- Don't use exclamation marks.
- Don't call a task "simple" or "easy". Don't frame instructions with "let's".
- Don't write "please" in instructions. Write "Click **View**", not "Please click **View**".

## Second person

- Address the reader as *you* and *your*, never *we*, *our*, or *us*.
- Treat the reader as the person performing the task or making the decision.
- Use imperative mood for instructions; the *you* is implied: "Click **Submit**."
- Use third person for what the software or an end user does, not for what the reader does.
- First-person plural is acceptable only when it clearly means your organization: "Example
  Organization provides A and B, but we don't provide C and D." Name the organization first.
- Establish who *you* refers to (developer, sysadmin, and so on) and stay consistent.
- Reserve *user* for the people who use the software your reader builds. Never call the
  reader "the user".

## Active voice

- Use active voice: make clear who or what performs the action.
- Passive voice makes it easy to omit the actor, leaving the reader unsure who acts.

| Recommended | Not recommended |
|---|---|
| Send a query to the service. The server sends an acknowledgment. | The service is queried, and an acknowledgment is sent. |

Passive voice is acceptable when you need to emphasize the object ("The file is saved"),
de-emphasize the subject ("Over 50 conflicts were found in the file"), or when the actor's
identity doesn't matter to the reader ("The database was purged in January").

## Present tense

- Use present tense for behavior that isn't tied to a particular time.
- Recommended: "Send a query to the service. The server sends an acknowledgment."
- Not recommended: "The server will send an acknowledgment."
- Not recommended: hypothetical "would" — "The server would then remove you from the list."
- Use *will* only to distinguish an action at a genuinely future time, or for asynchronous
  behavior: "A message is sent that will notify any Pub/Sub subscribers."
- Don't use future tense to describe changes that arrive after release.

## Pronouns

- Give every pronoun a clear, unambiguous antecedent. Replace a vague *it* or *this* with the
  specific noun.
- Follow demonstratives with a noun: "this value", not bare "this".
- Use singular *they* as the gender-neutral pronoun. Never use *he*, *she*, *him*, or *her*
  unless referring to someone of that gender. Never write "he/she" or "(s)he".
- Limit first person (I, we, us, our) to FAQs, author commentary, and organizational statements.
- *That* introduces a restrictive clause and takes no comma. *Which* introduces a
  nonrestrictive clause and takes a comma.
- Use *who* for people. *Whose* works for people, animals, and things.

## Sentence structure

Lead with the context, condition, or goal so readers can skip what doesn't apply.

| Recommended | Not recommended |
|---|---|
| For more information, see [link]. | See [link] for more information. |
| To delete the entire document, click **Delete**. | Click **Delete** if you want to delete the entire document. |
| If your app is in these regions, custom domains may add latency: | Custom domains might add latency if your app is in these regions: |

## Capitalization

- Follow standard American English capitalization. Avoid unnecessary capitals.
- Never rely on a capitalization difference alone to convey meaning.
- No all-caps except in official names, standard abbreviations, or code. No camel case except
  in official names or code.
- Use sentence case for titles, headings, captions, image labels and callouts, list items,
  and every part of a table. No period at the end of a title or heading.
- After a colon, start lowercase unless a proper noun, heading, quotation, or label such as
  **Caution** or **Note** follows.
- Glossary and index terms are lowercase unless they're proper nouns; definitions are
  sentence case.
- For a hyphenated word at the start of a sentence, capitalize only the first element.
- Don't name a convention "camel case" or "snake case". Show it: "the first letter of each
  word capitalized — for example, `AssertionAccount`".

## Contractions

- Use common two-word contractions: *you're*, *don't*, *there's*.
- Prefer negation contractions such as *isn't*, *don't*, and *can't*, because a standalone
  *not* is easy to miss when scanning. If you need the emphasis instead, format it: is *not*.
- Never invent nonstandard contractions ("guides're") or use three-word forms ("mightn't've").

## Anthropomorphism

Don't attribute human qualities to software or hardware. It reduces precision and complicates
translation.

| Recommended | Not recommended |
|---|---|
| A Delimiter object specifies where to split a string. | A Delimiter object tells the splitter where a string should be broken. |
| The PC detects a new device. | The PC sees a new device. |

## Articles

- Include *a*, *an*, and *the*. Don't drop them for brevity, including in headings and titles.
- Recommended: "Create a VM instance". Not recommended: "Create VM instance".

## Possessives

- Singular noun, including one ending in *s*: add *'s* — "each vector's record".
- Plural noun ending in *s*: add an apostrophe only — "the models' capabilities".
- Plural noun not ending in *s*: add *'s*.
- Rewrite awkward possessives: "Analyze the business data", not "the businesses' data".
- Don't form a possessive from a product, feature, or company name when describing function.
  Write "Monitor Google Search performance", not "Google Search's performance".
- Don't form a possessive from a code item. Write "the `wordCount` method's return value",
  not "`wordCount`'s return value".

## Prepositions

- There's no rule against ending a sentence with a preposition. Put prepositions where they
  read most clearly.
- Recommended: "see the client library documentation for the language you're interacting with".
- Not recommended: "for the language with which you're interacting".

## Abbreviations

- Spell out an abbreviation on first reference, then use the abbreviation alone. Italicize both
  the spelled-out term and the abbreviation at first use.
- If the first mention is in a heading, you can use the abbreviation there and spell it out in
  the first paragraph that follows.
- Never write *i.e.* or *e.g.* Write *that is* or *for example*.
- *etc.* is acceptable only in narrow cases; prefer rewriting the list.

## Pluralization

- Follow standard US English pluralization. Never use *'s* to form a plural.
- Match the verb to the subject. After "one or more", use the plural; after "more than one",
  use the singular.
- Pluralize acronyms like ordinary words: APIs, IDEs — never API's. Add *es* to acronyms
  ending in s, sh, ch, or x: OSes.
- Match the spelled-out term to its abbreviation: "virtual machines (VMs)", not
  "virtual machines (VM)".
- With units, use the singular only for 1. Use the plural for 0, decimals, and anything above
  1: "1 degree", "15 degrees". Don't pluralize an abbreviated unit: "64 GB", not "64 GBs".
- Use singular class names with a plural noun after: "Intent objects", not "Intents".
- Never write an optional plural in parentheses, such as "file(s)". Pick one form.
