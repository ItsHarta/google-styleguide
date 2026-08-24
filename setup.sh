#!/bin/bash
#
# Cross-CLI setup for the Google developer style guides. Wires Claude Code,
# OpenAI Codex CLI, and Google Antigravity (AGY) to one source of truth. Clone
# this repo anywhere, run ./setup.sh, and re-run it after editing any source.
#
# Each rules file owns its own marker pair, so both blocks coexist in one
# target file. Claude Code carries them in the output style rather than in
# ~/.claude/CLAUDE.md, so the text loads once per turn instead of twice; that
# makes the output style load-bearing, so this script pins outputStyle globally
# and strips any stale block from CLAUDE.md. Codex and AGY have no output-style
# mechanism, so ~/.agents/AGENTS.md carries both blocks.
#
# The output style is assembled into the gitignored build/, leaving the tracked
# template clean so a run never dirties the working tree.
#
# Fails closed on error, because a partial run leaves a CLI half-wired.

set -euo pipefail

# Derived without `dirname`: a failure there would silently resolve SRC to the
# caller's cwd.
script_path="${BASH_SOURCE[0]}"
[[ "${script_path}" == */* ]] || script_path="./${script_path}"
SRC="$(cd -- "${script_path%/*}" && pwd -P)"
readonly SRC
unset script_path
readonly BUILD="${SRC}/build"
readonly RULES="${SRC}/rules/google-style-rules.md"
readonly SKILL="${SRC}/skills/google-style"
readonly CODE_RULES="${SRC}/rules/google-code-rules.md"
readonly CODE_SKILL="${SRC}/skills/google-code"
readonly STYLE_TEMPLATE="${SRC}/output-styles/google-style.md"
readonly STYLE="${BUILD}/google-style.md"
# Must equal the frontmatter name: field in ${STYLE_TEMPLATE}.
readonly STYLE_NAME="google-style"

# Set by main: which targets this run wired, so verification checks only those.
wired_claude=0
wired_codex=0
wired_agents=0
force_all=0

#######################################
# Writes an error message to stderr with a UTC timestamp.
#######################################
err() {
  echo "[$(date -u +'%Y-%m-%dT%H:%M:%SZ')]: $*" >&2
}

#######################################
# Writes the usage message to stdout.
#######################################
usage() {
  cat <<'EOF'
Usage: ./setup.sh [--all]

  --all   Wire every CLI, including ones this machine doesn't have installed.
  -h      Show this message.

With no flags, each CLI is wired only when its command resolves to an
executable on PATH. Config directories are not consulted.
EOF
}

#######################################
# Verifies the external commands this script calls are available. Fails closed,
# because a missing command makes a partial run look like a clean one.
#######################################
check_deps() {
  local cmd
  for cmd in python3 grep ln rm mkdir cp touch date; do
    if ! command -v "${cmd}" > /dev/null 2>&1; then
      err "missing required command: ${cmd}"
      return 1
    fi
  done
}

#######################################
# Verifies every source file this script distributes exists.
#######################################
check_sources() {
  local path
  for path in "${RULES}" "${SKILL}/SKILL.md" "${CODE_RULES}" \
      "${CODE_SKILL}/SKILL.md" "${STYLE_TEMPLATE}"; do
    if [[ ! -f "${path}" ]]; then
      err "missing: ${path}"
      return 1
    fi
  done
}

#######################################
# Reports whether any of the named commands resolves to an executable file on
# PATH. Config directories are deliberately not consulted: this script creates
# several of them, so a directory test reports a CLI as present from the second
# run onward. Requiring a regular file also rejects a shell function, alias, or
# builtin sharing the name.
#######################################
cli_installed() {
  local name path
  for name in "$@"; do
    path="$(command -v "${name}" 2>/dev/null)" || continue
    if [[ -f "${path}" && -x "${path}" ]]; then
      return 0
    fi
  done
  return 1
}

#######################################
# Replaces a destination with a symlink to a skill directory. Refuses to delete
# anything that isn't a symlink or a managed skill directory, so a bad path
# can't turn into an rm -rf.
# Arguments:
#   Source directory, destination path.
#######################################
link_dir() {
  local src="$1"
  local dest="$2"
  if [[ -e "${dest}" && ! -L "${dest}" ]]; then
    if [[ -f "${dest}/SKILL.md" ]]; then
      rm -rf "${dest}"
    else
      echo "  [SKIP] ${dest} exists and isn't a managed skill directory." \
          "Remove it yourself."
      return 0
    fi
  fi
  rm -f "${dest}"
  ln -s "${src}" "${dest}"
  echo "  [OK] ${dest} -> ${src}"
}

#######################################
# Replaces a destination with a symlink to a file. Refuses to delete a
# directory.
# Arguments:
#   Source file, destination path.
#######################################
link_file() {
  local src="$1"
  local dest="$2"
  if [[ -d "${dest}" && ! -L "${dest}" ]]; then
    echo "  [SKIP] ${dest} is a directory. Remove it yourself."
    return 0
  fi
  rm -f "${dest}"
  ln -s "${src}" "${dest}"
  echo "  [OK] ${dest} -> ${src}"
}

#######################################
# Injects a rules file into an always-on instructions file, between its marker
# pair, creating the target when it's missing. The BEGIN marker is matched by
# pattern, so a block from an older version of this script is replaced rather
# than duplicated. Distinct marker ids don't interfere: the match is non-greedy
# and anchored on both ends.
# Arguments:
#   Rules file, marker id (for example google-style), target file.
#######################################
sync_block() {
  python3 - "$1" "$2" "$3" <<'PY'
import pathlib
import re
import sys

rules = pathlib.Path(sys.argv[1])
marker = sys.argv[2]
target = pathlib.Path(sys.argv[3])
begin = (f"<!-- BEGIN {marker}: managed by setup.sh in the "
         "google-styleguide repo; edit the rules file, not this block -->")
end = f"<!-- END {marker} -->"
block = f"{begin}\n{rules.read_text().rstrip()}\n{end}\n"

target.parent.mkdir(parents=True, exist_ok=True)
text = target.read_text() if target.exists() else ""
pat = re.compile(r"<!-- BEGIN " + re.escape(marker) + r":.*?-->.*?"
                 + re.escape(end) + r"\n?", re.S)
if pat.search(text):
    new, action = pat.sub(lambda _: block, text), "updated"
else:
    new = (text.rstrip() + "\n\n" if text.strip() else "") + block
    action = "appended"
if new != text:
    target.write_text(new)
print(f"  [OK] {action} {marker} block in {target}")
PY
}

#######################################
# Removes a managed block this script no longer owns. Touches nothing outside
# the marker pair, so hand-written content survives. Matches the BEGIN marker
# by pattern, so blocks from older versions are removed too.
# Arguments:
#   Marker id, target file.
#######################################
strip_block() {
  python3 - "$1" "$2" <<'PY'
import pathlib
import re
import sys

marker = sys.argv[1]
target = pathlib.Path(sys.argv[2])
if not target.exists():
    raise SystemExit
end = f"<!-- END {marker} -->"
text = target.read_text()
pat = re.compile(r"\n*<!-- BEGIN " + re.escape(marker) + r":.*?-->.*?"
                 + re.escape(end) + r"\n?", re.S)
if not pat.search(text):
    raise SystemExit
new = pat.sub("\n\n", text)
new = re.sub(r"\n{3,}", "\n\n", new).rstrip() + "\n"
target.write_text(new)
print(f"  [OK] removed stale {marker} block from {target}")
PY
}

#######################################
# Assembles the output style into build/ from the tracked template plus both
# rules files. The template stays byte-identical, so a run leaves the working
# tree clean.
#######################################
build_style() {
  mkdir -p "${BUILD}"
  cp "${STYLE_TEMPLATE}" "${STYLE}"
  sync_block "${RULES}" google-style "${STYLE}"
  sync_block "${CODE_RULES}" google-code "${STYLE}"
}

#######################################
# Pins outputStyle in the given settings file, because the output style is the
# only Claude Code carrier for the rules. Refuses to overwrite a different
# explicit choice, and returns 1 if the file isn't valid JSON.
#######################################
ensure_output_style() {
  python3 - "$1" "${STYLE_NAME}" <<'PY'
import json
import pathlib
import sys

path, want = pathlib.Path(sys.argv[1]), sys.argv[2]
data = {}
if path.exists() and path.read_text().strip():
    try:
        data = json.loads(path.read_text())
    except json.JSONDecodeError as e:
        print(f"  [FAIL] {path} isn't valid JSON ({e}); set outputStyle "
              "yourself")
        raise SystemExit(1)
current = data.get("outputStyle")
if current == want:
    print(f"  [OK] {path} already pins outputStyle '{want}'")
elif current:
    print(f"  [WARN] {path} pins outputStyle '{current}', not '{want}'. "
          "Left it alone.")
else:
    data["outputStyle"] = want
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, indent=2) + "\n")
    print(f"  [OK] pinned outputStyle '{want}' in {path}")
PY
}

#######################################
# Guards the one thing this split is for: the rules must reach a Claude Code
# turn exactly once, through the output style. Catches three ways a second copy
# creeps back into the always-on file -- a managed block this script failed to
# strip, text pasted by hand without markers, and an @-import of a file that
# already carries the rules.
# Arguments:
#   Target file, then one or more rules files to look for.
#######################################
check_no_duplication() {
  python3 - "$@" <<'PY'
import pathlib
import re
import sys

target = pathlib.Path(sys.argv[1])
rules_files = [pathlib.Path(p) for p in sys.argv[2:]]
if not target.exists():
    print(f"  [PASS] {target} doesn't exist, so it can't duplicate anything")
    raise SystemExit(0)
text = target.read_text()
lines = text.splitlines()
present = {line.strip() for line in lines}
fail = False

for marker in ("google-style", "google-code"):
    if f"BEGIN {marker}:" in text:
        print(f"  [FAIL] {target} still carries a managed {marker} block")
        fail = True
    else:
        print(f"  [PASS] {target} carries no managed {marker} block")

for rules in rules_files:
    body = rules.read_text().splitlines()
    headings = {line.strip() for line in body if line.startswith("## ")}
    canaries = {line.strip() for line in body
                if (line.startswith("- ") or line.startswith("**"))
                and len(line.strip()) >= 40}
    hit_headings = sorted(headings & present)
    hit_canaries = sorted(canaries & present)
    # One stray line can be coincidence. A heading, or three lines, is a copy.
    if hit_headings or len(hit_canaries) >= 3:
        print(f"  [FAIL] {target} contains unmarked text from {rules.name}: "
              f"{len(hit_headings)} heading(s), "
              f"{len(hit_canaries)} rule line(s)")
        for heading in hit_headings[:3]:
            print(f"         heading: {heading}")
        for canary in hit_canaries[:2]:
            print(f"         line:    {canary[:70]}")
        print("         Remove it by hand. This script only deletes what its "
              "markers own.")
        fail = True
    else:
        print(f"  [PASS] {target} has no unmarked copy of {rules.name}")

carriers = {"AGENTS.md", "GEMINI.md", "google-style.md",
            "google-style-rules.md", "google-code-rules.md"}
for number, line in enumerate(lines, 1):
    match = re.match(r"\s*@(\S+)", line)
    if match and pathlib.Path(match.group(1)).name in carriers:
        print(f"  [FAIL] {target}:{number} imports a file that already "
              f"carries the rules: {match.group(1)}")
        fail = True
raise SystemExit(1 if fail else 0)
PY
}

#######################################
# Wires Claude Code: the built output style carries both blocks, plus two
# linked skills. CLAUDE.md used to carry the same blocks, so strip them.
#######################################
setup_claude_code() {
  mkdir -p "${HOME}/.claude/skills" "${HOME}/.claude/output-styles"
  link_file "${STYLE}" "${HOME}/.claude/output-styles/google-style.md"
  ensure_output_style "${HOME}/.claude/settings.json"
  strip_block google-style "${HOME}/.claude/CLAUDE.md"
  strip_block google-code "${HOME}/.claude/CLAUDE.md"
  link_dir "${SKILL}" "${HOME}/.claude/skills/google-style"
  link_dir "${CODE_SKILL}" "${HOME}/.claude/skills/google-code"
}

#######################################
# Wires the OpenAI Codex CLI: model_instructions_file plus two linked skills.
#######################################
setup_codex() {
  local codex_cfg="${HOME}/.codex/config.toml"
  mkdir -p "${HOME}/.codex/skills"
  touch "${codex_cfg}"
  if grep -q '^model_instructions_file' "${codex_cfg}"; then
    python3 - "${codex_cfg}" "${HOME}/.agents/AGENTS.md" <<'PY'
import pathlib
import re
import sys

cfg, path = pathlib.Path(sys.argv[1]), sys.argv[2]
text = cfg.read_text()
new = re.sub(r'^model_instructions_file\s*=.*$',
             f'model_instructions_file = "{path}"', text, count=1, flags=re.M)
if new != text:
    cfg.write_text(new)
PY
    echo "  [OK] model_instructions_file in ${codex_cfg} points at" \
        "${HOME}/.agents/AGENTS.md"
  else
    echo "model_instructions_file = \"${HOME}/.agents/AGENTS.md\"" \
        >> "${codex_cfg}"
    echo "  [OK] added model_instructions_file to ${codex_cfg}"
  fi
  link_dir "${SKILL}" "${HOME}/.codex/skills/google-style"
  link_dir "${CODE_SKILL}" "${HOME}/.codex/skills/google-code"
}

#######################################
# Wires the universal ~/.agents folder, read by Codex and AGY. Neither has an
# output style, so AGENTS.md stays the always-on carrier for both blocks.
#######################################
setup_agents_dir() {
  mkdir -p "${HOME}/.agents/skills" "${HOME}/.agents/rules"
  sync_block "${RULES}" google-style "${HOME}/.agents/AGENTS.md"
  sync_block "${CODE_RULES}" google-code "${HOME}/.agents/AGENTS.md"
  link_file "${HOME}/.agents/AGENTS.md" "${HOME}/.agents/GEMINI.md"
  link_file "${RULES}" "${HOME}/.agents/rules/google-style-rules.md"
  link_file "${CODE_RULES}" "${HOME}/.agents/rules/google-code-rules.md"
  link_dir "${SKILL}" "${HOME}/.agents/skills/google-style"
  link_dir "${CODE_SKILL}" "${HOME}/.agents/skills/google-code"
}

#######################################
# Checks that every skill symlink this run installed resolves to a complete
# skill directory.
#######################################
verify_skills() {
  local fail=0
  local roots=()
  if (( wired_claude )); then roots+=("${HOME}/.claude/skills"); fi
  if (( wired_codex )); then roots+=("${HOME}/.codex/skills"); fi
  if (( wired_agents )); then roots+=("${HOME}/.agents/skills"); fi
  if (( ${#roots[@]} == 0 )); then
    echo "  [PASS] no skills installed this run"
    return 0
  fi
  local root dir probe entry
  for root in "${roots[@]}"; do
    for entry in "google-style:references/word-list.md" \
        "google-code:references/python.md"; do
      dir="${root}/${entry%:*}"
      probe="${entry##*:}"
      if [[ -L "${dir}" && -f "${dir}/${probe}" ]]; then
        echo "  [PASS] ${dir} resolves with references/"
      else
        echo "  [FAIL] ${dir} is not a symlink to a complete skill"
        fail=1
      fi
    done
  done
  return "${fail}"
}

#######################################
# Checks that each always-on carrier holds exactly one copy of each block, and
# that the tracked template holds none. A block in the template would mean a run
# had mutated its own source.
#######################################
verify_carriers() {
  local fail=0
  local files=("${STYLE}")
  if (( wired_agents )); then files+=("${HOME}/.agents/AGENTS.md"); fi
  local file marker count
  for file in "${files[@]}"; do
    for marker in google-style google-code; do
      count="$(grep -c "BEGIN ${marker}:" "${file}" 2>/dev/null || true)"
      if [[ "${count}" == "1" ]]; then
        echo "  [PASS] ${file} carries exactly one ${marker} block"
      else
        echo "  [FAIL] ${file} doesn't carry exactly one ${marker} block"
        fail=1
      fi
    done
  done
  for marker in google-style google-code; do
    if grep -q "BEGIN ${marker}:" "${STYLE_TEMPLATE}"; then
      echo "  [FAIL] ${STYLE_TEMPLATE} carries a ${marker} block; the tracked" \
          "template must stay clean"
      fail=1
    else
      echo "  [PASS] ${STYLE_TEMPLATE} carries no ${marker} block"
    fi
  done
  return "${fail}"
}

#######################################
# Checks the output style resolves and the global pin points at it. Claude Code
# resolves an output style by its frontmatter name, not its filename, and a
# mismatch drops it back to the default with no error -- which, now that the
# output style is the only Claude Code carrier, would drop every rule.
#######################################
verify_output_style() {
  local fail=0
  local actual_name want_global
  actual_name="$(python3 -c 'import re, sys, pathlib
text = pathlib.Path(sys.argv[1]).read_text()
match = re.match(r"---\n(.*?)\n---\n", text, re.S)
name = re.search(r"^name:\s*(\S+)", match.group(1), re.M) if match else None
print(name.group(1) if name else "")' "${STYLE}")"
  if [[ "${actual_name}" == "${STYLE_NAME}" ]]; then
    echo "  [PASS] ${STYLE} declares name: ${STYLE_NAME}"
  else
    echo "  [FAIL] ${STYLE} declares name: '${actual_name:-<none>}'," \
        "expected '${STYLE_NAME}'"
    fail=1
  fi

  want_global="$(python3 -c 'import json, sys
try:
    print(json.load(open(sys.argv[1])).get("outputStyle") or "")
except Exception:
    print("")' "${HOME}/.claude/settings.json")"
  if [[ "${want_global}" == "${STYLE_NAME}" ]]; then
    echo "  [PASS] ${HOME}/.claude/settings.json pins outputStyle" \
        "'${STYLE_NAME}'"
  else
    echo "  [FAIL] ${HOME}/.claude/settings.json pins outputStyle" \
        "'${want_global:-<none>}'"
    fail=1
  fi
  return "${fail}"
}

#######################################
# Wires every detected CLI, then verifies the result. Returns 1 if any check
# fails.
#######################################
main() {
  local arg
  for arg in "$@"; do
    case "${arg}" in
      --all) force_all=1 ;;
      -h|--help) usage; return 0 ;;
      *) err "unknown argument: ${arg}"; usage >&2; return 1 ;;
    esac
  done

  check_deps || return 1
  check_sources || return 1

  echo "Configuring cross-CLI Google developer style guides from ${SRC}..."
  build_style

  if (( force_all )) || cli_installed claude; then
    setup_claude_code
    wired_claude=1
  else
    echo "  [SKIP] Claude Code not detected: no claude on PATH."
  fi

  if (( force_all )) || cli_installed codex; then
    setup_codex
    wired_codex=1
  else
    echo "  [SKIP] Codex CLI not detected: no codex on PATH."
  fi

  # Codex reads ~/.agents/AGENTS.md; AGY ships either agy or antigravity.
  if (( force_all || wired_codex )) \
      || cli_installed agy antigravity gemini; then
    setup_agents_dir
    wired_agents=1
  else
    echo "  [SKIP] No ~/.agents reader detected: no codex, agy, antigravity," \
        "or gemini on PATH."
  fi

  echo
  echo "Verifying..."
  local fail=0
  verify_skills || fail=1
  verify_carriers || fail=1
  if (( wired_claude )); then
    check_no_duplication "${HOME}/.claude/CLAUDE.md" "${RULES}" \
        "${CODE_RULES}" || fail=1
    verify_output_style || fail=1
  fi

  if (( fail == 0 )); then
    if (( wired_claude || wired_codex || wired_agents )); then
      echo "All detected CLIs configured."
    else
      echo "No CLI detected on PATH. Nothing to configure."
    fi
  else
    echo "Setup incomplete."
    return 1
  fi
}

main "$@"
