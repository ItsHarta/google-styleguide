# Shell

Condensed from the Google Shell style guide,
`https://google.github.io/styleguide/shellguide.html`.

## When to use shell at all

- Bash is the only shell scripting language the guide permits for an executable.
- Use shell for a small utility or a simple wrapper. Once a script runs past roughly 100 lines,
  or its control flow stops being straightforward, rewrite it in a structured language — the
  guide says to do that now, not later, because the rewrite only gets more expensive.
- Start an executable with `#!/bin/bash` and minimal flags. Use `set` for shell options, so
  running the file as `bash script_name` still behaves.
- Give an executable no extension, or `.sh`. Give a library a `.sh` extension and don't make it
  executable.
- SUID and SGID are forbidden on a shell script. Use `sudo` for elevation.

### `set -e` and friends

The guide takes no general position on `set -e`. It says to use `set` for shell options so the
script survives being run as `bash script_name`, and it mentions `set -e` exactly once — as a
caution that `set -e; i=0; (( i++ ))` exits the shell, because `(( … ))` returns non-zero when
the expression evaluates to zero.

What the guide does require is a **Checking Return Values** section: check return values, and
give informative ones. Test the command directly in an `if`, or read `$?` immediately after.

So there's no upstream answer here. Two defensible positions:

- **Explicit checks only.** What the guide actually prescribes. Portable and obvious, but it
  catches only the failures you remembered to test.
- **`set -euo pipefail` plus explicit checks where they matter.** Fails closed on the paths you
  forgot, which suits a security context. `~/google-styleguide/setup.sh` takes this position.

Pick one per script and state it in the file header comment. Either way, don't rely on `set -e`
alone to catch a failure you can name — check that one explicitly.

## Formatting

- Indent two spaces. Never use tabs.
- Cap lines at 80 characters. For a longer literal, use a here-document or embedded newlines.
- Put `; do` and `; then` on the same line as the `while`, `for`, or `if`.
- Split a pipeline that doesn't fit one line so each segment sits on its own line, with the `|`
  leading and indented two spaces.
- Indent case alternatives two spaces. A one-line alternative takes a space after the closing
  parenthesis and before `;;`.
- Put every function together near the top of the file. Only includes, `set` statements, and
  constants come before them.

## Naming and variables

- Name a function in lowercase with underscores, and use `::` to separate a package scope:
  `mypackage::my_function`. Parentheses follow the name. The `function` keyword is optional —
  be consistent within a file.
- Name a variable in lowercase with underscores. Name a constant or an exported environment
  variable in `ALL_CAPS`, declared at the top and marked `readonly` or `export`.
- Declare a function-local variable with `local`, always.
- Declare and assign on separate lines when the value comes from a command substitution.
  `local var="$(cmd)"` throws away the command's exit status, because `local` supplies its own.
- Name a source file in lowercase with underscores.

## Quoting and expansion

- Quote every string that contains a variable, a command substitution, a space, or a shell
  metacharacter. When in doubt, quote it.
- Prefer `"${var}"` to `"$var"`, and stay consistent within a file.
- Use `"$@"` to forward arguments. Use `$*` only when you deliberately want one joined string.
- Use `$(command)`, never backticks. Backticks nest badly and escape inconsistently.
- Expand a wildcard against an explicit path: `./*`, not `*`, so a file named `-rf` can't become
  a flag.
- Don't use `eval`. It turns data into code, which is both a readability problem and an
  injection vector.

## Tests and control flow

- Use `[[ … ]]` rather than `[`, `test`, or `/usr/bin/[`. It doesn't word-split or glob its
  operands, so it fails less surprisingly.
- Test a string with `-z` and `-n` rather than comparing against a filler character.
- Use `(( … ))` or `$(( … ))` for arithmetic. Never use `let` or `expr`.
- Don't pipe into `while`: the loop runs in a subshell, so its variable assignments vanish. Use
  process substitution — `while read … ; do … done < <(cmd)` — or `readarray`.
- Use an array for a list of elements, especially command-line arguments. Don't build a complex
  data structure out of one; that's the signal to change languages.
- Prefer a shell builtin to an external process. Parameter expansion beats a `sed` call.
- Don't use an alias in a script. The guide points at the Bash manual: shell functions are
  preferred for almost every purpose, and aliases need fragile quoting and escaping.
- Run **ShellCheck**. The guide recommends it for all scripts, large or small — it catches
  quoting, expansion, and portability bugs that review misses.

## Errors and output

- Send every error message to `stderr`. A conventional helper:

  ```bash
  err() {
    echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
  }
  ```

- Check return values and give informative ones. Test the command directly in an `if`, or
  capture `$?` immediately. For a pipeline, read `PIPESTATUS` — and read it into a variable
  before running anything else, because the next command overwrites it.
- Return a distinct non-zero status for a distinct failure, and say what failed on `stderr`.

## Comments

- Give every file a top-level comment describing what it does. Copyright and author lines are
  optional.
- Comment any function that isn't both short and obvious. The guide's headers are `Globals`,
  `Arguments`, `Outputs`, and `Returns`, above the function.
- Comment the tricky and non-obvious parts of an implementation, not the parts that read
  themselves.
- Format a work item as `# TODO(<name>): <what needs doing>` — for example,
  `# TODO(mrmonkey): Handle the unlikely edge cases (bug ####)`. The Shell guide wants the name,
  email, or identifier of the person with the best context, and says it's almost always your own
  name. This contradicts the current Python guide, which discourages naming a person at all and
  wants a bug link instead. Follow whichever language you're writing.
