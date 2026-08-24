# google-styleguide

One place to keep the [Google developer documentation style
guide](https://developers.google.com/style) and the [Google style
guides](https://google.github.io/styleguide/) for Claude Code, the OpenAI
Codex CLI, and Google Antigravity.

`setup.sh` installs two sets of rules, one for writing and one for code, into
every supported CLI on your machine. Each CLI gets an always-on block and two
skills you can call on demand. All of them are symlinks back to this checkout,
so you edit one file, re-run the script, and every CLI is up to date.

On Windows, run `setup.ps1` instead. It sets up the same CLIs the same way, in
PowerShell, with one difference described in [Windows](#windows): it copies
files instead of linking them.

## Requirements

To clone the repo, you need `git`.

### Linux and macOS

To run `setup.sh`, you need `bash` and these commands on your PATH: `python3`,
`grep`, `ln`, `rm`, `mkdir`, `cp`, `touch`, and `date`.

Everything except `python3` comes with a standard Linux or macOS install.
`setup.sh` checks for all of them before it writes anything, and stops with a
`missing required command` error that names the first one it can't find.

`python3` does all the file edits: adding the managed blocks, updating
`~/.claude/settings.json`, and reading the output-style frontmatter. Using
Python instead of `sed` and `awk` keeps the script working the same way on
BSD and GNU systems.

macOS doesn't come with a `python3` you can use. To install one, run:

```bash
xcode-select --install
```

### Windows

To run `setup.ps1`, you need Windows PowerShell 5.1, which comes with Windows
10 and 11, or PowerShell 7 or later. That's all: no Python, no Git Bash, no
WSL.

## Installation

### Install

```bash
git clone https://github.com/ItsHarta/google-styleguide ~/google-styleguide
~/google-styleguide/setup.sh
```

You can clone it anywhere. `setup.sh` works out every path from where it sits,
and you can run it as many times as you like, so re-run it after you edit any
source file.

Don't move the checkout afterward: everything it installs is a symlink back
into it.

### Windows

```powershell
git clone https://github.com/ItsHarta/google-styleguide $HOME\google-styleguide
& $HOME\google-styleguide\setup.ps1
```

If your execution policy blocks local scripts, run it with the policy switch
instead:

```powershell
powershell -ExecutionPolicy Bypass -File $HOME\google-styleguide\setup.ps1
```

`setup.ps1` copies files instead of linking them, because a Windows symlink
needs Developer Mode or an elevated shell. That means two things:

- **Re-run `setup.ps1` after you edit anything under `rules/` or `skills/`.** A
  copy doesn't follow its source, so until you re-run it, each CLI still uses
  the text from your last run. Every successful run prints this reminder, and
  the check at the end fails with `is a stale copy` when it finds one.
- You can move the checkout, unlike on Linux and macOS. Run `setup.ps1` again
  from the new location.

You can run both scripts against the same home directory, such as a WSL install
next to a Windows one. They write the same managed blocks byte for byte, and
each one replaces what the other left behind, links included.

### CLI detection

By default, both scripts set up only the CLIs you actually have. They look for
each CLI's own command on your PATH. `setup.ps1` also accepts the `.exe`,
`.cmd`, and `.ps1` shims a CLI installs on Windows:

| CLI | Commands checked |
| --- | --- |
| Claude Code | `claude` |
| Codex CLI | `codex` |
| `~/.agents/` readers | `agy`, `antigravity`, `gemini`, or Codex |

The scripts don't check config directories. Both scripts create several of
them, so a directory check would report a CLI as installed from the second run
onward, and an uninstalled CLI leaves its config behind anyway.

To set up every CLI whether or not it's installed, pass `--all`, or `-All` on
Windows:

```bash
~/google-styleguide/setup.sh --all
```

```powershell
& $HOME\google-styleguide\setup.ps1 -All
```

### What it sets up

- **Claude Code:** links `build/google-style.md` into
  `~/.claude/output-styles/`, sets `outputStyle` in `~/.claude/settings.json`,
  removes any old managed block from `~/.claude/CLAUDE.md`, and links both
  skills. The output style is the only place Claude Code loads the rules from,
  so the text reaches a turn once instead of twice.
- **Codex CLI:** points `model_instructions_file` at `~/.agents/AGENTS.md` and
  links both skills.
- **`~/.agents/`:** writes both rules blocks into `AGENTS.md`, links
  `GEMINI.md` to it, and links both skills. Codex and Antigravity have no
  output style, so this file is how they load the rules on every turn.

`setup.ps1` sets up the same three targets under `%USERPROFILE%`, copying each
file and skill directory where `setup.sh` links it.

### Check the install

Every run ends with a check. A healthy run reports `[PASS]` for each item and
exits 0 with `All detected CLIs configured.` Any `[FAIL]` sets the exit code to
1 and prints `Setup incomplete.`

If no CLI is found, the run still succeeds and reports `No CLI detected on
PATH. Nothing to configure.`

## Layout

| Path | Role |
| --- | --- |
| `rules/google-style-rules.md` | Writing rules, loaded on every turn. |
| `rules/google-code-rules.md` | Code rules, loaded on every turn. |
| `skills/google-style/` | Writing reference, symlinked into skills dirs. |
| `skills/google-code/` | Code reference, symlinked into skills dirs. |
| `output-styles/google-style.md` | Output-style template. Never written to. |
| `build/google-style.md` | Template plus both blocks. Gitignored. |
| `setup.sh` | Installer for Linux and macOS. |
| `setup.ps1` | Installer for Windows. Same setup, copies not links. |

## Editing the guides

Edit the files under `rules/`, `skills/`, and `output-styles/`, then re-run
`setup.sh`, or `setup.ps1` on Windows. Don't edit a managed block in an
installed file: the next run overwrites it.

An HTML comment pair marks each managed block and names its marker id, for
example `<!-- BEGIN google-style: ... -->` and `<!-- END google-style -->`.
Both scripts own everything between those markers and change nothing outside
them, so anything you wrote yourself in the same file survives a run.

## Troubleshooting

**`missing required command: python3`**
Install `python3`, then re-run. See [Requirements](#requirements). `setup.ps1`
doesn't need Python.

**`[WARN] ... pins outputStyle 'X', not 'google-style'. Left it alone.`**
Another output style is already set. `setup.sh` won't overwrite a choice you
made, and the `[FAIL]` that follows means the rules can't reach a turn. Either
change `outputStyle` in `~/.claude/settings.json` yourself, or keep your style
and accept that Claude Code won't load these rules.

**`[FAIL] ... isn't valid JSON`**
`~/.claude/settings.json` is broken. Fix the JSON, then re-run.

**`[FAIL] ... contains unmarked text from google-style-rules.md`**
Someone pasted the rules into `~/.claude/CLAUDE.md` without markers, so they'd
load twice per turn. `setup.sh` deletes only what its own markers own, so
remove the pasted copy yourself.

**`[SKIP] ... exists and isn't a managed skill directory. Remove it yourself.`**
A real directory sits where `setup.sh` wants to make a symlink. Back it up and
remove it, then re-run.

**`[SKIP] <CLI> not detected: no <command> on PATH.`**
That CLI isn't installed, or your shell can't see it. Check with
`type -P <command>`. To set it up anyway, pass `--all`.

**Broken symlinks after you move the checkout**
Everything installed points back into the checkout by full path. Re-run
`setup.sh` from the new location.

**Windows: `... cannot be loaded because running scripts is disabled`**
Your execution policy blocks local scripts. Run
`powershell -ExecutionPolicy Bypass -File .\setup.ps1`, or unblock the file
with `Unblock-File .\setup.ps1` after you set a policy that allows local
scripts.

**Windows: `[FAIL] ... is a stale copy; re-run this script`**
An installed skill no longer matches the checkout, because `setup.ps1` copies
instead of links. Re-run `setup.ps1`.

**Windows: `[SKIP] ... isn't a managed skill directory`**
Same cause as on Linux and macOS: a real directory sits in the target path.
`setup.ps1` also refuses to go into a symlink or junction left by a WSL run of
`setup.sh`; it removes the link and copies the files in its place.

## Contributing

Edit the sources under `rules/`, `skills/`, and `output-styles/` and open a
pull request. Don't commit generated output: `build/` is gitignored, and every
run rebuilds the managed blocks in installed files.

Keep the guides true to the upstream sources. When a rule here disagrees with
the Google page it came from, the Google page wins.

## License

This repository has two licenses, split by what the file is.

| Path | License |
| --- | --- |
| `setup.sh`, `setup.ps1` | [MIT](LICENSE) |
| `rules/`, `skills/`, `output-styles/`, `README.md` | [CC BY 4.0](LICENSE-DOCS) |

## Legal notice

Google doesn't own, endorse, or sponsor this project. The name refers to the
source material it packages, not to any Google product.

The files under `rules/`, `skills/`, and `output-styles/` are shortened and
reorganized from three upstream sources. None is copied in full, and each file
names the upstream pages it draws from. Read those pages for the official
wording.

| Source | License |
| --- | --- |
| [Google developer documentation style guide](https://developers.google.com/style) | [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) |
| [Google style guides](https://github.com/google/styleguide) | [CC BY 3.0](https://creativecommons.org/licenses/by/3.0/) |
| [Google engineering practices](https://github.com/google/eng-practices) | [CC BY 3.0](https://creativecommons.org/licenses/by/3.0/) |

Parts of this project are copied from work created and shared by Google and
used according to the terms in the Creative Commons 4.0 Attribution License.

Changes were made: the upstream material has been shortened, reorganized, and
rewritten for use as always-on instructions and on-demand references for
command-line coding agents. See [`NOTICE`](NOTICE) for the full statement.
