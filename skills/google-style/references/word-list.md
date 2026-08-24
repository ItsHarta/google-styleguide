# Word list

Condensed from `https://developers.google.com/style/word-list`, plus `/style/product-names`,
`/style/trademarks`, and `/style/examples`.

**This is a filtered subset, not the whole list.** It keeps entries with a distinctive ruling
(don't use X, use Y; one word not two; specific capitalization). For any term not listed here,
consult the canonical page — don't guess.

## Don't use — replacements

| Avoid | Use instead |
|---|---|
| abort | stop, exit, cancel, end (exception: the Linux signal) |
| account name | username |
| agnostic | platform-independent |
| aka | also known as |
| allowlist (as a verb) | allow (noun form `allowlist` is fine) |
| allows you to | lets you |
| and/or | and, or, or "X, Y, or both" |
| and so on | rewrite the list |
| anti-pattern | the specific problem, such as "SQL errors" |
| as (meaning "because") | because |
| as of this writing | nothing — delete it |
| blacklist | denylist, blocklist, excludelist |
| cell phone | mobile phone, mobile device |
| cellular data | mobile data |
| click here | descriptive link text |
| click on | click |
| Cloud (for Google Cloud) | Google Cloud |
| Cloud console | Google Cloud console |
| could | can, might |
| deselect (a checkbox) | clear |
| e.g. | for example |
| easy, easily | delete, or say what's involved |
| fat | high-capacity, full-featured |
| female adapter | socket |
| first-class | higher-order, anonymous, nested |
| foo, bar, baz | a meaningful placeholder name |
| ghetto | clumsy, workaround, inelegant |
| grandfather clause | legacy, exempt |
| graylist | see blacklist |
| hamburger menu | the element's aria-label |
| hang (of a system) | stop responding |
| hover | hold the pointer over |
| i.e. | that is |
| in order to | to |
| just | delete, or name the specific thing |
| k8s | Kubernetes |
| kebab case | dash-case |
| lame | a precise, non-figurative term |
| latest | the version number or release date |
| learnings | knowledge, things you learned |
| leverage (meaning "use") | use |
| lower (for versions) | earlier |
| higher (for versions) | later |
| male adapter | plug |
| man-hours | person-hours |
| mankind | humanity |
| master/slave | primary/replica, or a specific term |
| may (for possibility) | can |
| MIME type | media type |
| network IP address | internal IP address |
| ninja, rockstar | expert |
| NoOps | fully managed |
| nuke | remove |
| off-the-shelf | ready-made, prebuilt, standard, default |
| old, older | earlier |
| omnibox | address bar |
| once (meaning "after") | after |
| performant | the specific characteristic |
| please (in instructions) | delete |
| pop-up | dialog, menu |
| portal (for the console) | Google Cloud console |
| preferred pronouns | pronouns |
| presently, currently, now, soon | delete |
| sanity check | final check for completeness and clarity |
| simple, simply | delete |
| since (meaning "because") | because |
| spit out | generate, produce |
| tombstoning | describe what happens to the state |
| topic (for a document) | document, guide, tutorial |
| uncheck | clear |
| unmanned | automated, uncrewed |
| via | through |
| whitelist | allowlist, safelist |

## Spelling and form

**One word:** codebase, codelab, data center (two words — see below), ecommerce, email,
filename, frontend, healthcare, hostname, namespace, prebuilt, precapture, preemptible,
prerecorded, screenshot, secondhand, socioeconomic, standalone, straightforward, subclass,
superclass, troubleshoot, webhook, website, workstation.

**Two words:** data center, data flow (but *dataflow* for stream processing), data source,
data type, name server, source code, split view, time zone, use case.

**Hyphenated:** big-endian, distributed denial-of-service (DDoS), multi-cluster,
multi-region, on-premises, parent-child, pre-existing, pre-shared key, split-tunnel,
three-dimensional (3D), trade-off, well-known, x-axis, y-axis.

**Verb versus noun:** *fail over* (verb) / *failover* (noun, adjective); *log in* (verb) /
*login* (noun, adjective); *set up* (verb) / *setup* (noun); *start up* (verb) / *startup*
(noun); *plug in* (verb) / *plug-in* (adjective) / *plugin* (noun).

**Capitalization:** AM and PM in caps with a space before, no periods. `ID`, not `Id` or `id`,
except in code. `OAuth 2.0`, not OAuth2. `NoSQL`. `Google Cloud`, never GCP or Cloud Platform.
*alpha* and *beta* lowercase except in product names. *Android* capitalized for the OS.

**Plurals:** appendixes, not appendices. indexes, not indices, unless the domain demands it.
*emoji* is both singular and plural. *data* takes a singular verb.

## Specific rulings

- **a/an** — choose by sound, not letter.
- **about versus on** — use *about* in cross-references.
- **above/below** — never for document position or UI direction. Acceptable for hierarchies.
- **access (verb)** — prefer view, edit, or find.
- **admin** — write *administrator*, except as a UI label or in Android docs.
- **app** — use for end-user programs, not *application*.
- **authentication and authorization** — users authenticate; requests are authorized.
- **between versus among** — *between* for distinct things, *among* for groups.
- **button** — not for links.
- **can / might / must / should** — *can* for ability or permission, *might* for possibility,
  *must* for a requirement, *should* for a recommendation. Reserve *may* for policy and legal.
- **checkbox** — one word. Use *select* and *clear*, never check or uncheck.
- **deprecate** — means recommended against, not removed or deleted.
- **directory versus folder** — *directory* on the command line, *folder* in a GUI.
- **drag** — not "click and drag" or "drag and drop".
- **enable** — for turning a feature on. Use *lets you* for making something feasible.
- **neither** — "neither A nor B".
- **N/A** — spell out as *not available* or *not applicable* on first reference.
- **nonce** — define on first use.
- **per** — for rates, instead of a slash.
- **plain text versus plaintext** — *plaintext* only in cryptography.
- **sign in / sign out** — preferred over log in and log out.
- **tap** — for touchscreens, instead of click.
- **that versus which** — *that* is restrictive and takes no comma; *which* is nonrestrictive
  and takes one.
- **then versus than** — *than* compares.
- **third party** — no hyphen as a noun; hyphenate as a modifier.
- **through** — preferred over *via*.
- **toward** — not *towards*.
- **update versus upgrade** — *upgrade* for a major version change.
- **whether versus if** — *whether* for alternatives.

## Abbreviations to spell out on first mention

advertising technology (ad tech), financial technology (fintech), Google Cloud CLI (then
*gcloud CLI*), Identity and Access Management (IAM), platform as a service (PaaS), personally
identifiable information (PII), software as a service (SaaS), search engine optimization (SEO),
service level agreement (SLA), service level indicator (SLI), service level objective (SLO),
site reliability engineering (SRE), user experience (UX), virtual machine (VM).

No need to expand: AI, API, CPU, DevOps, OS, SQL, UI, XML, YAML.

## Product names

- Capitalize Google product names in title case, unless the official name starts lowercase —
  then keep it lowercase even at the start of a sentence.
- Feature names are generally lowercase unless officially capitalized or matching a UI label.
- Use the full trademarked name. Don't abbreviate, except to match a UI label.
- Use *the* before tool and API names ("the Transcoder API", "the gcloud CLI"), but not before
  a product name: "Using Cloud Datastore with Cloud Dataproc".
- Say "the X service" when referring to several products, to avoid ambiguity.
- Never use a product or feature name as a verb.

## Trademarks

- Follow the trademark owner's usage guidelines.
- Always use a trademark as a modifier of a noun, never as a noun alone: "a Chromebook notebook
  computer", not "a Chromebook".
- Never use a trademark as a verb, and never form a possessive or plural from one.

## Example values

- **Domains:** `example.com`, `example.org`, `example.net`.
- **Email:** an example person name at an example domain, such as `dana@example.com`, or a
  generic address such as `support@example.net`. Never a real person's name.
- **Person names:** gender-neutral given names with an initial for the surname — "Quinn N.",
  "Dana A." Use *they*, *their*, *theirs*. Represent diverse backgrounds and roles without
  reinforcing stereotypes. Alice and Bob belong only in security documentation that references
  the technical specifications using them.
- **Companies:** "Example Organization"; differentiate several descriptively.
- **Phone numbers:** 800-555-0100 through 800-555-0199. Never a real number.
- **IP addresses:** IPv4 from RFC 5737 — `192.0.2.0/24`, `198.51.100.0/24`, `203.0.113.0/24`.
  IPv6 from RFC 3849 — `2001:db8::/32`.
- **Project names:** meaningful and descriptive. Never foo, bar, or baz.
