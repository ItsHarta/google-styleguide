# Code and computer interfaces

Condensed from the Google developer documentation style guide.
Sources: `/style/code-in-text`, `/style/code-samples`, `/style/placeholders`,
`/style/code-syntax`, `/style/ui-elements`, `/style/filenames`
(all under `https://developers.google.com`).

## Code in text

Use code font (backticks in Markdown, `<code>` in HTML) for: attribute names and values, class
names, command output, data types, database elements, filenames, folders, HTTP headers, HTTP
status codes and verbs, IAM roles, IP addresses, keywords, method and function names, namespace
aliases, package names, port numbers, query parameters, and placeholder variables.

Don't use code font for domain names, product or service names, organization names, or URLs a
reader types into a browser — unless you're referring to them as literal input, output, or code
entities.

Conditional cases:

- Boolean values take code font for direct references to `true` and `false`, but not for the
  evaluation described in prose.
- Command-line utilities take code font; the product name does not.
- Email addresses take code font as input or output, plain font as contact information.

Grammar:

- Never use a code element as a verb, and never inflect one. Add a noun instead: "send a `POST`
  request", not "`POST` the data".
- Never make a code element plural or possessive.
- Write status codes as "an HTTP `400 Bad Request` status code". Say "status code", not
  "response code". Write ranges as `2xx` or `200`-`299`.
- Omit the class name from a method name unless it's needed for clarity.

## Code samples

- Follow the relevant language style guide for indentation; two spaces per level is the usual
  default.
- Wrap lines at 80 characters.
- Mark blocks as preformatted: `<pre>` in HTML, a fence or four-space indent in Markdown.
- Indicate omitted code with a language-appropriate comment, not an ellipsis. Don't enable
  click-to-copy on a block containing omissions.
- Precede every sample with an introductory sentence. End it with a colon when the sample
  follows immediately, or a period when a note or link comes between.

## Placeholders

- Write placeholders in uppercase with underscore delimiters: `API_NAME`, `METHOD_NAME`.
- Don't use a single `x` or a run of x's as a placeholder, except in standard forms such as an
  HTTP status range.
- Never include a possessive adjective: use `API_NAME`, not `MY_API_NAME` or `YOUR_API_NAME`.
- In HTML, wrap in `<var>`: `<code><var>PLACEHOLDER_NAME</var></code>`. In Markdown inline, use
  `` *`PLACEHOLDER_NAME`* ``.
- Don't put brackets, braces, or ellipses inside a `<var>` element.
- Explain every placeholder on first use. For one, write "Replace PLACEHOLDER with a
  description." For several, write "Replace the following:" and list them. Use lowercase after
  the colon, and introduce examples with "such as". An em dash also works, but it counts
  against the one-per-paragraph cap in `punctuation.md`.

## Command-line syntax

- Square brackets mark an optional argument, each in its own pair:
  `gcloud dns GROUP [GLOBAL_FLAG] [FILENAME]`.
- Curly braces with pipes mark a required, mutually exclusive choice: `{FILE_1|FILE_2}`.
- Three dots with no spaces mark a repeatable value: `[GLOBAL_FLAG ...]`.
- Break long commands before a hyphen, double hyphen, underscore, or quotation mark. Indent
  continuation lines four spaces. End each line but the last with a space and a backslash on
  Linux, or a space and a caret on Windows.
- Start each input line with a `$` prompt. Don't show a directory path before the prompt. Add a
  distinct prompt when the context changes, such as moving to a remote machine.
- Introduce output with "The output is similar to the following:". Mark omitted output with
  three dots on their own line. Show output only when it adds value.
- For click-to-copy commands, drop optional arguments, mutually exclusive arguments, ellipses,
  and any character that would break the command. Link to the full reference instead.

## UI elements and interaction

- Describe what the reader wants to accomplish, not the widgets they operate.
- Put UI element names in **bold**, not code font, and follow the element's real
  capitalization — falling back to sentence case when the label is all caps or inconsistent.
- Don't bold a product or feature name unless you're pointing at an on-page element.
- Remove a trailing ellipsis from a UI name.

Terminology: **window** for a desktop application window; **page** for a web page or console
subpage; **dialog** for a small detached window in front; **pane** or **panel** for a region
within a window; **section** for a labeled group of options; **menu** ("the **File** menu");
**command** for a menu item, never "choice" or "option"; **toolbar**, with **menu button** for
a toolbar button that opens a menu; **tab** ("the **Label** tab").

- Checkboxes: use *select* and *clear*, never *check* or *uncheck*.
- Radio buttons: refer to the label or the group label.
- Don't use *toggle* as a verb. Don't call an expander arrow a "zippy" or "expando".
- Text entry: "the **Name** box" generally, "field" in Google Cloud and Workspace contexts;
  "the **Item** list" for a list box; "type or select" for a combo box; "enter" for a spin box.

Keyboard:

- Use `<kbd>`: `Press <kbd>Control+C</kbd>`.
- Spell out modifier keys — Control, Command, Option, Shift — and never use symbols.
- Capitalize letter keys: `Control+S`, not `Control+s`.
- Cover platforms as "Control+C (or Command+C on macOS)".
- *Press* is a keyboard action; *enter* or *type* is text input.

Prepositions: **in** a dialog, field, list, menu, pane, or window; **on** a page, tab, or
toolbar.

Action verbs: click, choose, drag, enable, enter, type, go to, hold the pointer over, press,
select, tap, turn on, turn off.

Accessibility: never use directional language such as "above", "below", or "on the right".
Give context or a screenshot for a hard-to-find element. Give an `aria-label` to an angle
bracket separator: `<span aria-label="and then">></span>`.

## Filenames

- Make file and directory names lowercase, separated by hyphens rather than underscores:
  `query-data.html`. Use only standard ASCII alphanumerics.
- Avoid generic names such as `document1.html`.
- Match an existing directory's convention when consistency demands it, even if that means
  underscores.
- Reference a filename in code font, followed by the word "file", spelled exactly as it is on
  disk. Name the file in the text introducing a code sample.
- Use the formal file type name, not the extension: "PNG file", not ".png file"; "Bash file",
  not ".sh file".
- Don't use a file type as a verb: "extract a zip file", not "unzip a zip file".
