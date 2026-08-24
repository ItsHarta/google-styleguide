---
name: google-code
description: Apply the Google style guides when writing or reviewing source code in Python, Go, Shell, TypeScript/JavaScript, HTML/CSS, JSON, or Markdown, and Google engineering practices when reviewing a change or writing a commit or pull request description. Use for naming, layout, imports, error handling, doc comments, and language-specific conventions.
---

# Google style guides for source code

Condensed from `https://google.github.io/styleguide/` and
`https://google.github.io/eng-practices/`. Your always-on instructions carry the rules that apply
to every language; this skill carries the depth. Those instructions live in `~/.claude/CLAUDE.md`
for Claude Code, and in `~/.agents/AGENTS.md` for Codex and Antigravity.

For prose — documentation, READMEs, runbooks, release notes, and the wording inside comments —
use the `google-style` skill instead. This skill covers the code itself.

## Where to look

Open the one file that matches your question. Don't read them all.

| Question | File |
|---|---|
| Python: imports, naming, docstrings, type annotations, comprehensions, exceptions | `references/python.md` |
| Go: naming, error handling, receivers, interfaces, package layout, concurrency | `references/go.md` |
| Shell: quoting, tests, functions, `set` options, error handling, when to stop using Bash | `references/shell.md` |
| TypeScript and JavaScript: types, `const`, modules, classes, equality, formatting | `references/typescript.md` |
| HTML and CSS: document structure, quoting, shorthand, declaration order, class naming | `references/html-css.md` |
| JSON: property naming, structure, reserved property names, date and time format | `references/json.md` |
| Markdown: headings, lists, code blocks, line length, links, tables | `references/markdown.md` |
| Reviewing a change, or writing a commit or pull request description | `references/reviews.md` |

## Highlights

**Formatting**

- Run the canonical formatter and take its output. `gofmt` is normative for Go — the guide says
  all Go source must match it. Python and TypeScript have no formatter named in their guides, so
  use whatever your project runs and follow the guide's own rules.
- Wrap at 80 columns everywhere except Go, which sets no column limit.
- Indent four spaces in Python, two in Shell, TypeScript, HTML, and CSS, and tabs in Go.

**Naming**

- Take the convention from the language guide, never from another language.
- Name for the reader: a name's length should track its scope. Avoid abbreviations outside a
  well-known set.

**Structure**

- Keep functions short and single-purpose. A function that needs a section comment usually
  wants to be two functions.
- Document every exported symbol. Say what it does and what the caller must know, not how it
  works.
- Handle every error at the point you can act on it. Never discard one silently.

**Review**

- The reviewer's standard: approve once the change definitely improves overall code health,
  even when it isn't perfect. Don't block on personal preference.
- Prefer a small, single-purpose change over a large one.

## Languages with no Google guide

Google publishes no style guide for Rust or for Terraform/HCL, so this skill carries no
reference for either. That's an absence in the upstream corpus, not an omission here. For those
languages, follow the ecosystem's own tooling — `rustfmt` and `clippy`, `terraform fmt` and
`tflint` — and the repository's existing convention.

Google does publish guides for Java, C++, Objective-C, Swift, R, Vimscript, and AngularJS that
this skill doesn't condense. Read them upstream when you need them.

## What these references are

Each file is a condensation, not a reproduction. The upstream guides run to thousands of lines;
these run to roughly 100 each and carry the rules you hit most often. Coverage against the
upstream section lists is roughly:

| Reference | Upstream sections | Covered |
|---|---|---|
| `python.md` | 42 | most; skips lint configuration detail and some 2.x rationale |
| `shell.md` | 44 | most |
| `typescript.md` | 58 (plus the JavaScript guide's 64) | the commonly-hit subset |
| `html-css.md` | 41 rules | nearly all |
| `go.md` | 70 in decisions, plus guide and best-practices | the commonly-hit subset |
| `json.md`, `markdown.md`, `reviews.md` | — | substantially complete |

Notable areas deliberately left upstream: the TypeScript guide's mapped and conditional types,
index signatures, return-type-only generics, and compiler conformance flags; the Go guide's
generics, type aliases, and common-library sections; the JavaScript guide's full syntax
chapter. Open the source guide when your question isn't answered here.

## Precedence

Your always-on instructions set the order: epistemic rules, data handling, and refusals beat
this guide, and your security defaults beat it too. A style guide never justifies weak crypto, an
unhandled error, a suppressed exception, or a hardcoded secret.

Where a repository's existing convention conflicts with a Google guide, match the repository and
say so in your response. Consistency within a file outranks consistency with this skill.
