# Python

Condensed from the Google Python style guide,
`https://google.github.io/styleguide/pyguide.html`. Lint with `pylint` against the guide's
`pylintrc`.

## Layout

- Indent four spaces. Never use tabs, and never mix them with spaces.
- Cap lines at 80 characters. The guide's exceptions: long import statements; URLs, pathnames,
  and long flags in comments; long module-level string constants without whitespace; and
  `pylint: disable` comments.
- Break long lines with implicit continuation inside parentheses, brackets, or braces. Use a
  backslash only for a `with` statement that needs three or more context managers and can't use
  `contextlib.ExitStack`.
- Put two blank lines between top-level definitions, and one between method definitions.
- Add a trailing comma in a sequence only when the closing bracket sits on its own line.
- Put no whitespace inside brackets, none before a comma, semicolon, or colon, and one space
  around every binary operator. Don't align assignments with extra spaces.
- Write one statement per line. Don't terminate a line with a semicolon, and don't put two
  statements on one line.
- Give an executable a shebang of `#!/usr/bin/env python3` (which respects a virtualenv) or
  `#!/usr/bin/python3`, per PEP 394. A module that's only imported needs none.
- Use parentheses sparingly. Don't wrap a `return` value or a condition in them out of habit.

## Imports

- Import packages and modules only, never individual classes or functions. The exceptions the
  guide names are the `typing`, `collections.abc`, and `typing_extensions` modules, plus
  redirects from `six.moves`.
- Import each module by its full package path: `from doctor.who import jodie`, not a relative
  import. Relative imports are prohibited even within the same package.
- Use `import x` for packages and modules, `from x import y` when `y` is a module in package
  `x`, and `from x import y as z` when two modules named `y` collide or `y` is unwieldy.
- Put every import on its own line at the top of the file, after the module docstring.
- Group imports as `__future__`, standard library, third party, then same-repository packages.
  Separate the groups with a blank line and sort each group lexicographically by full path,
  ignoring case.

## Naming

| Kind | Form |
|---|---|
| Module, package | `module_name`, `package_name` |
| Class, exception | `ClassName`, `ExceptionName` |
| Function, method, parameter, local | `function_name`, `parameter_name`, `local_var_name` |
| Module constant | `GLOBAL_CONSTANT_NAME` |
| Instance variable | `instance_var_name` |

- Prefix a non-public module-level symbol, class attribute, or method with a single underscore.
  A leading double underscore triggers name mangling; the guide discourages it.
- Avoid single-character names. The guide's exceptions: `i`, `j`, `k` and similar for counters
  and iterators, `e` for an exception in an `except` clause, `f` for a file or path in a `with`
  statement, and `_` for a value you deliberately discard.
- Never put a dash in a module or package name.
- Don't invent `__double_leading_and_trailing_underscore__` names.
- Name a file with a `.py` extension and no dashes.

## Docstrings and comments

- Use `"""` triple double quotes for every docstring.
- The summary may be descriptive-style ("Fetches rows from a Bigtable.") or imperative-style
  ("Fetch rows from a Bigtable."). The guide requires only that the style stay consistent within
  a file. A `@property` docstring uses the same style as an attribute docstring ("The Bigtable
  path."), not "Returns the Bigtable path."
- Give every module a docstring. Give every public function, method, and class one, unless it's
  short, obvious, and not exported.
- Use the section headers `Args:`, `Returns:` (or `Yields:` for a generator), and `Raises:`.
  Indent each entry, and describe the type in the annotation rather than repeating it in prose.
- Document a class's public attributes under an `Attributes:` header.
- Start an inline comment at least two spaces from the code, with `# ` and a space.
- Comment tricky code before it runs, and never restate what the line already says.
- Format a work item as `# TODO: <link or context> - <what needs doing>`, for example
  `# TODO: b/192795 - Replace this with the batched API.` A bug reference is preferred over
  any other context. The old `# TODO(username):` form is discouraged in new code, and the guide
  says not to use an individual or a team as the context at all. The Shell guide still asks for
  the person's name, so the two guides genuinely differ — follow whichever language you're in.

## Language features

- Never use a mutable object as a default argument value. Build it inside the function instead.
- Use a comprehension for a simple case only: each of the mapping expression, the `for` clause,
  and the filter fits on one line. Multiple `for` clauses or filter expressions are prohibited;
  write a loop.
- Use default iterators and operators — `for key in adict`, `if key in adict` — over methods
  that build an intermediate list.
- Use a lambda only for a one-liner. If it runs past roughly 60–80 characters, write a nested
  function.
- Use a conditional expression only when each of the three parts fits on one line.
- Prefer implicit false: write `if not users:`, not `if len(users) == 0:`. Always compare to
  `None` with `is` or `is not`. Never compare a boolean with `==`. Be careful where `0` is a
  valid value distinct from empty.
- Build a string with an f-string, `%`, or `.format()`. Never accumulate with `+=` in a loop;
  append to a list and `''.join()` it.
- Be consistent with your quote character within a file. Use `"""` for a multi-line string.
- Open a file or socket with `with`, so it closes on every path.
- Avoid mutable global state. A module-level constant is fine; a module-level mutable is not.
- Avoid power features: metaclasses, bytecode access, dynamic import tricks, reflective
  reassignment, and custom `__del__`. They make code hard to read and hard to trust.
- Don't rely on the atomicity of built-in types for thread safety. Use `queue.Queue`, or an
  explicit lock or condition variable from `threading`.
- Nested and local classes and functions are fine, and are the right tool for closing over a
  local. Prefer a module-level private function when the nesting exists only to hide a name.
- Use a decorator when it's clearly justified. A decorator runs at import time, so a failure
  inside one is hard to recover from and hard to test.
- Lexical scoping is fine to use. Be aware that assigning to a name anywhere in a function makes
  it local throughout, which is a common source of `UnboundLocalError`.
- Use `from __future__ import …` to reach a newer language feature on an older interpreter, and
  drop the import once the minimum version no longer needs it.
- Use a generator where it fits, and document what it produces with `Yields:` rather than
  `Returns:`.
- Use a property for a simple computed attribute. Anything expensive or surprising should be an
  ordinary method, so the cost is visible at the call site.

## Exceptions

- Raise a built-in exception class where one fits the failure. Derive a custom exception from
  `Exception`, and name it ending in `Error`.
- Never write a bare `except:`, and never catch `Exception` broadly, except when you re-raise
  or when you're at the outermost block of a program that must log and exit.
- Keep the `try` body as small as the failure requires. Code that can't raise belongs outside
  it.
- Don't use `assert` to validate the arguments of a public API. `assert` states an internal
  invariant and disappears under `-O`. Raise instead.
- Use `finally` or `with` for cleanup that must run.

## Types and structure

- Annotate function signatures per PEP 484. Don't annotate `self` or `cls`.
- Write an optional type as `X | None`. Never let a default of `None` imply optionality without
  the annotation.
- Keep functions short and focused. Once one passes roughly 40 lines, ask whether it wants to
  be two.
- Write a getter or setter only when it does real work. A plain attribute needs neither; use a
  property if behavior arrives later.
- Call the logging functions with a literal format string and separate arguments:
  `logging.info("processed %s rows", count)`. Never pre-format with an f-string, so the logger
  can defer the work and group by message.
- Give a program an explicit `def main():` and guard it with
  `if __name__ == '__main__': main()`, so importing the module runs nothing.
