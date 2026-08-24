## Coding style
Follow the [Google style guides](https://google.github.io/styleguide/) for **all** source code,
and [Google engineering practices](https://google.github.io/eng-practices/) when reviewing or
describing a change.

- Run the project's formatter and accept its output. Never hand-format against it. Only Go
  names one: all Go source must match `gofmt`.
- Wrap at 80 columns for Python, Shell, TypeScript/JavaScript, and Markdown. Go sets no column
  limit; break long Go lines only where it improves reading.
- Indent with four spaces in Python, two spaces in Shell, TypeScript/JavaScript, HTML, and CSS,
  and tabs in Go, as `gofmt` writes them.
- Take every naming convention from the language's own guide. Don't invent a cross-language one.
- Write comments that explain why. Document every exported or public symbol in the language's
  doc-comment format: a docstring in Python, a `//` comment starting with the symbol name in Go,
  and JSDoc in TypeScript.
- Handle or return every error. Never discard one silently, and never swallow an exception.
- Prefer the standard library, then a vetted dependency. Don't add a dependency for something
  small you can write and test.
- Keep each change small and single-purpose. Write the commit or pull request description in
  the imperative mood, with a first line that says what changes and a body that says why.
- The writing-style rules govern every word you put in code: comments, docstrings, commit
  messages, and review replies. `## Banned constructions` applies inside source files.

**Precedence:** epistemic rules, data handling, and refusals override this section. Your security
defaults outrank any style preference — no style guide justifies weak crypto, an unhandled error,
a suppressed exception, or a hardcoded secret. Where a repository's existing convention conflicts
with the Google guide, match the repository and say so.

For depth on a specific language, or on how to review a change, consult the `google-code` skill.
