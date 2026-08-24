# Go

Condensed from the Google Go style guide, `https://google.github.io/styleguide/go/` — its three
parts are the style guide (principles), style decisions, and best practices.

## Principles, in priority order

1. **Clarity.** The reader's understanding beats the writer's convenience.
2. **Simplicity.** Do the simplest thing that works.
3. **Concision.** High signal-to-noise. Delete what carries no meaning.
4. **Maintainability.** Write code that's straightforward to change correctly.
5. **Consistency.** Match the surrounding code, the package, and the wider codebase.

When two conflict, the earlier one wins. Clarity outranks consistency: don't propagate a
confusing local pattern.

## Formatting

- `gofmt` decides formatting. Run it, accept its output, and never argue with it in review.
  `goimports` extends it to import grouping.
- There's no fixed line length for Go. If a line feels too long, prefer refactoring over
  splitting it; if it's already as short as is practical, let it stay long. Don't split a line
  before an indentation change, and don't split a long string such as a URL across lines.
- Indent with tabs, as `gofmt` writes them.
- Group imports as standard library first, then everything else, separated by a blank line.
- Don't rename an import unless you must resolve a collision, and never use a dot import outside
  a narrow test idiom.

## Naming

- Use `MixedCaps` or `mixedCaps`. Never use underscores in a multi-word name.
- Case an initialism consistently: `URL`, `urlPony`, `ID`, `HTTPServer`, `appID`. Don't write
  `Url` or `Id`.
- Make a name's length track its scope. A loop index is `i`; a package-level exported value
  earns a full descriptive name.
- Package names are short, lowercase, single-word, and never plural or underscored. Avoid
  `util`, `common`, `helper`, `misc`, and `base` — they describe nothing.
- Don't stutter. Inside package `http`, the type is `Server`, so callers write `http.Server`,
  not `http.HTTPServer`.
- Keep receiver names short — one or two letters — and identical across every method on a type.
  Never name a receiver `self` or `this`.
- Name a sentinel error `ErrSomething` and an error type `SomethingError`.
- Avoid a name that only repeats the type: `users []User`, not `userSlice`.

## Errors

- Return errors; don't panic. Reserve `panic` for a genuinely impossible state, and reserve a
  `MustXxx` helper for package initialization and tests.
- Write an error string uncapitalized and with no trailing punctuation, so it reads correctly
  inside a caller's context. The exception is a string that opens with an exported name, a
  proper noun, or an acronym. The full displayed message — a log line, a test failure, an API
  response — is typically capitalized.
- Add context as the error travels up, without repeating what the caller already knows. Wrap
  with `%w` when a caller should be able to unwrap; use `%v` when the wrapped type is an
  implementation detail you don't want to commit to.
- Compare with `errors.Is` and convert with `errors.As`. Never compare error strings.
- Handle an error once. Don't both log it and return it.
- Never discard an error with `_` unless you write a comment explaining why the failure can't
  matter.
- Keep the happy path at the leftmost indentation: handle the failure and return early, so the
  `else` disappears.

## Types and interfaces

- Define an interface where it's consumed, not where it's implemented. Return concrete types
  and accept interfaces.
- Keep an interface small. One or two methods covers most real needs.
- Write `any`, not `interface{}`.
- Use field names in a struct literal. A positional literal breaks silently when a field is
  added.
- Prefer a nil slice to an empty one. `var s []T` is idiomatic and appends fine.
- Avoid named result parameters unless they document an otherwise ambiguous return, or you need
  them in a deferred function.
- Avoid mutable package-level state. Where you need it, guard it and document the invariant.
- Use a `switch` where an if-else chain would run past two branches.

## Context and concurrency

- Pass `context.Context` as the first parameter, named `ctx`. Don't put it in a struct field
  except in the narrow cases the guide allows, and document it when you do.
- Never pass a nil context. Use `context.Background()` or `context.TODO()`.
- Don't start a goroutine without knowing how it ends. Every goroutine needs a termination
  condition, whether that's a closed channel, a cancelled context, or a finished loop.
- Prefer synchronous APIs. Let the caller decide to add concurrency.
- Make the zero value of a type useful where you can, so callers skip a constructor.

## Documentation comments

- Every top-level exported name must have a doc comment. So should an unexported type or
  function whose behavior or meaning isn't obvious.
- Write full sentences beginning with the name of the thing described. An article may precede
  it: `// A Request represents a request to run a command.` or `// Encode writes the JSON
  encoding of req to w.`
- Say what it does and what a caller must know — preconditions, ownership, whether it's safe for
  concurrent use — not how it works internally.
- Give every package a package comment on one file, describing what the package is for.
- Put the license or copyright header above the package comment, separated by a blank line.

## Tests

- Write table-driven tests. Name each case, and run subtests with `t.Run(tc.name, …)`.
- Print got before want. The standard format is `YourFunc(%v) = %v, want %v`. Use the words
  "got" and "want", not "actual" and "expected".
- For a **diff**, directionality is less obvious, and `got, want` argument ordering in `cmp.Diff`
  is listed under the guide's *Non-decisions* — no consensus. Whichever order you use, state it
  explicitly in the failure message, because existing code is inconsistent.
- Call `t.Helper()` at the top of a helper that reports failures, so the line number points at
  the caller.
- Compare complex values with `cmp.Diff` and report the diff, not two dumped structs.
- Fail with `t.Error` when the test can keep going, and `t.Fatal` when it can't.
- Don't add an assertion library that hides which value failed.
- Identify the function and the input in the failure message, so a reader doesn't have to open
  the test to know what broke.
- Compare a struct, slice, array, or map as a whole rather than field by field.

## Security-relevant decisions

- Never use `math/rand` to generate a key, even a throwaway one. Unseeded it's fully
  predictable; seeded from the clock it carries a few bits of entropy. Use `crypto/rand`'s
  `Reader`, and render to hex or base64 when you need text.
- Use `%q` to print a string that could be empty or hold control characters — `""` is visible
  where a silent empty string isn't.
- Return an error rather than an in-band sentinel value such as `-1` or `nil` that a caller can
  forget to check.
