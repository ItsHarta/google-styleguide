#Requires -Version 5.1

<#
.SYNOPSIS
Cross-CLI setup for the Google developer style guides on Windows.

.DESCRIPTION
The Windows port of setup.sh. Wires Claude Code, the OpenAI Codex CLI, and
Google Antigravity (AGY) to one source of truth. Clone this repo anywhere, run
.\setup.ps1, and re-run it after editing any source.

Each rules file owns its own marker pair, so both blocks coexist in one target
file. Claude Code carries them in the output style rather than in
~\.claude\CLAUDE.md, so the text loads once per turn instead of twice; that
makes the output style load-bearing, so this script pins outputStyle globally
and strips any stale block from CLAUDE.md. Codex and AGY have no output-style
mechanism, so ~\.agents\AGENTS.md carries both blocks.

The output style is assembled into the gitignored build\, leaving the tracked
template clean so a run never dirties the working tree.

Unlike setup.sh, this script copies instead of symlinking: a Windows symlink
needs Developer Mode or an elevated shell. Copies go stale, so re-run this
script after editing anything under rules\ or skills\.

Fails closed on error, because a partial run leaves a CLI half-wired.

.PARAMETER All
Wire every CLI, including ones this machine doesn't have installed. Without it,
each CLI is wired only when its command resolves on PATH.

.EXAMPLE
.\setup.ps1

.EXAMPLE
.\setup.ps1 -All
#>

[CmdletBinding()]
param(
    [switch]$All
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Src = $PSScriptRoot
$HomeDir = if ([string]::IsNullOrWhiteSpace($HOME)) {
    $env:USERPROFILE
} else {
    $HOME
}

function Join-Parts {
    param([Parameter(Mandatory = $true)][string[]]$Part)
    [System.IO.Path]::Combine($Part)
}

$Build = Join-Parts $Src, 'build'
$Rules = Join-Parts $Src, 'rules', 'google-style-rules.md'
$Skill = Join-Parts $Src, 'skills', 'google-style'
$CodeRules = Join-Parts $Src, 'rules', 'google-code-rules.md'
$CodeSkill = Join-Parts $Src, 'skills', 'google-code'
$StyleTemplate = Join-Parts $Src, 'output-styles', 'google-style.md'
$Style = Join-Parts $Build, 'google-style.md'
# Must equal the frontmatter name: field in $StyleTemplate.
$StyleName = 'google-style'

$AgentsFile = Join-Parts $HomeDir, '.agents', 'AGENTS.md'
$ClaudeSettings = Join-Parts $HomeDir, '.claude', 'settings.json'
$ClaudeMd = Join-Parts $HomeDir, '.claude', 'CLAUDE.md'

# Set by Invoke-Main: which targets this run wired, so verification checks
# only those.
$script:WiredClaude = $false
$script:WiredCodex = $false
$script:WiredAgents = $false

#######################################
# Writes an error message to stderr with a UTC timestamp.
#######################################
function Write-Err {
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Message
    )
    $stamp = [DateTime]::UtcNow.ToString('yyyy-MM-ddTHH:mm:ssZ')
    [Console]::Error.WriteLine("[$stamp]: $($Message -join ' ')")
}

#######################################
# Reads a text file, normalizing CRLF so every regex and comparison here sees
# the line endings setup.sh sees.
#######################################
function Read-TextFile {
    param([Parameter(Mandatory = $true)][string]$Path)
    [System.IO.File]::ReadAllText($Path) -replace "`r`n", "`n"
}

#######################################
# Writes a text file as UTF-8 with no BOM and LF endings, creating the parent
# directory. A BOM breaks output-style frontmatter parsing, and CRLF would make
# a managed block differ between a Windows run and a WSL run of setup.sh.
#######################################
function Write-TextFile {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][AllowEmptyString()][string]$Text
    )
    New-ParentDir $Path
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    $body = $Text -replace "`r`n", "`n"
    [System.IO.File]::WriteAllText($Path, $body, $utf8NoBom)
}

#######################################
# Creates the parent directory of a path if it doesn't exist.
#######################################
function New-ParentDir {
    param([Parameter(Mandatory = $true)][string]$Path)
    $parent = Split-Path -Parent $Path
    if ($parent -and -not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
}

#######################################
# Verifies every source file this script distributes exists.
#######################################
function Test-SourceFile {
    $paths = @(
        $Rules,
        (Join-Parts $Skill, 'SKILL.md'),
        $CodeRules,
        (Join-Parts $CodeSkill, 'SKILL.md'),
        $StyleTemplate
    )
    foreach ($path in $paths) {
        if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
            Write-Err "missing: $path"
            return $false
        }
    }
    return $true
}

#######################################
# Reports whether any of the named commands resolves on PATH. Config
# directories are deliberately not consulted: this script creates several of
# them, so a directory test reports a CLI as present from the second run
# onward. Application and ExternalScript cover the .exe, .cmd, and .ps1 shims a
# CLI installs on Windows, and reject a function or alias sharing the name.
#######################################
function Test-CliInstalled {
    param([Parameter(Mandatory = $true)][string[]]$Name)
    foreach ($name in $Name) {
        $found = Get-Command -Name $name `
            -CommandType Application, ExternalScript `
            -ErrorAction SilentlyContinue
        if ($found) {
            return $true
        }
    }
    return $false
}

#######################################
# Deletes a path that a previous setup.sh run under WSL may have left as a
# symlink or junction, removing the link itself and never what it points at:
# Remove-Item -Recurse follows a directory reparse point in PowerShell 5.1,
# which would empty this checkout.
# Returns:
#   $true if the path was a reparse point and is now gone.
#######################################
function Remove-ReparsePoint {
    param([Parameter(Mandatory = $true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) {
        return $false
    }
    $item = Get-Item -LiteralPath $Path -Force
    $reparse = [System.IO.FileAttributes]::ReparsePoint
    if (-not ($item.Attributes -band $reparse)) {
        return $false
    }
    if ($item.PSIsContainer) {
        [System.IO.Directory]::Delete($item.FullName, $false)
    } else {
        [System.IO.File]::Delete($item.FullName)
    }
    return $true
}

#######################################
# Replaces a destination with a fresh copy of a skill directory. Refuses to
# delete anything that isn't a link or a managed skill directory, so a bad path
# can't turn into a recursive delete. Copying whole rather than merging drops
# files deleted from the source instead of leaving them behind.
# Arguments:
#   Source directory, destination path.
#######################################
function Copy-SkillDir {
    param(
        [Parameter(Mandatory = $true)][string]$Source,
        [Parameter(Mandatory = $true)][string]$Destination
    )
    $wasLink = Remove-ReparsePoint $Destination
    if (-not $wasLink -and (Test-Path -LiteralPath $Destination)) {
        $marker = Join-Parts $Destination, 'SKILL.md'
        if (-not (Test-Path -LiteralPath $marker -PathType Leaf)) {
            Write-Host ("  [SKIP] $Destination exists and isn't a managed " +
                'skill directory. Remove it yourself.')
            return
        }
        Remove-Item -LiteralPath $Destination -Recurse -Force
    }
    New-ParentDir $Destination
    Copy-Item -LiteralPath $Source -Destination $Destination -Recurse -Force
    Write-Host "  [OK] $Destination <- $Source (copy)"
}

#######################################
# Replaces a destination with a fresh copy of a file. Refuses to delete a
# directory, and deletes an existing link rather than writing through it into
# this checkout.
# Arguments:
#   Source file, destination path.
#######################################
function Copy-ManagedFile {
    param(
        [Parameter(Mandatory = $true)][string]$Source,
        [Parameter(Mandatory = $true)][string]$Destination
    )
    if (-not (Remove-ReparsePoint $Destination)) {
        if (Test-Path -LiteralPath $Destination -PathType Container) {
            Write-Host ("  [SKIP] $Destination is a directory. " +
                'Remove it yourself.')
            return
        }
        if (Test-Path -LiteralPath $Destination) {
            Remove-Item -LiteralPath $Destination -Force
        }
    }
    New-ParentDir $Destination
    Copy-Item -LiteralPath $Source -Destination $Destination -Force
    Write-Host "  [OK] $Destination <- $Source (copy)"
}

#######################################
# Injects a rules file into an always-on instructions file, between its marker
# pair, creating the target when it's missing. The BEGIN marker is matched by
# pattern, so a block from an older version of either script is replaced rather
# than duplicated. Distinct marker ids don't interfere: the match is non-greedy
# and anchored on both ends. The marker text matches setup.sh byte for byte, so
# a home directory shared with WSL stays idempotent across both scripts.
# Arguments:
#   Rules file, marker id (for example google-style), target file.
#######################################
function Sync-Block {
    param(
        [Parameter(Mandatory = $true)][string]$RulesFile,
        [Parameter(Mandatory = $true)][string]$Marker,
        [Parameter(Mandatory = $true)][string]$Target
    )
    $begin = "<!-- BEGIN ${Marker}: managed by setup.sh in the " +
        'google-styleguide repo; edit the rules file, not this block -->'
    $end = "<!-- END $Marker -->"
    $block = "$begin`n" + (Read-TextFile $RulesFile).TrimEnd() + "`n$end`n"

    $text = if (Test-Path -LiteralPath $Target -PathType Leaf) {
        Read-TextFile $Target
    } else {
        ''
    }
    $pattern = '(?s)<!-- BEGIN ' + [regex]::Escape($Marker) + ':.*?-->.*?' +
        [regex]::Escape($end) + '\n?'
    if ([regex]::IsMatch($text, $pattern)) {
        $new = [regex]::Replace($text, $pattern, { $block })
        $action = 'updated'
    } else {
        $prefix = if ($text.Trim()) { $text.TrimEnd() + "`n`n" } else { '' }
        $new = $prefix + $block
        $action = 'appended'
    }
    if ($new -ne $text) {
        Write-TextFile $Target $new
    }
    Write-Host "  [OK] $action $Marker block in $Target"
}

#######################################
# Removes a managed block this script no longer owns. Touches nothing outside
# the marker pair, so hand-written content survives. Matches the BEGIN marker
# by pattern, so blocks from older versions are removed too.
# Arguments:
#   Marker id, target file.
#######################################
function Remove-Block {
    param(
        [Parameter(Mandatory = $true)][string]$Marker,
        [Parameter(Mandatory = $true)][string]$Target
    )
    if (-not (Test-Path -LiteralPath $Target -PathType Leaf)) {
        return
    }
    $end = "<!-- END $Marker -->"
    $text = Read-TextFile $Target
    $pattern = '(?s)\n*<!-- BEGIN ' + [regex]::Escape($Marker) + ':.*?-->.*?' +
        [regex]::Escape($end) + '\n?'
    if (-not [regex]::IsMatch($text, $pattern)) {
        return
    }
    $new = [regex]::Replace($text, $pattern, "`n`n")
    $new = [regex]::Replace($new, '\n{3,}', "`n`n").TrimEnd() + "`n"
    Write-TextFile $Target $new
    Write-Host "  [OK] removed stale $Marker block from $Target"
}

#######################################
# Assembles the output style into build\ from the tracked template plus both
# rules files. The template stays byte-identical, so a run leaves the working
# tree clean.
#######################################
function Build-Style {
    New-Item -ItemType Directory -Path $Build -Force | Out-Null
    Copy-Item -LiteralPath $StyleTemplate -Destination $Style -Force
    Sync-Block $Rules google-style $Style
    Sync-Block $CodeRules google-code $Style
}

#######################################
# Pins outputStyle in the given settings file, because the output style is the
# only Claude Code carrier for the rules. Refuses to overwrite a different
# explicit choice. Inserts the key textually and validates the result rather
# than re-serializing: ConvertTo-Json in PowerShell 5.1 escapes non-ASCII and
# < > &, so a round trip would rewrite unrelated settings.
# Returns:
#   $false if the file isn't valid JSON before or after the edit.
#######################################
function Set-OutputStylePin {
    param([Parameter(Mandatory = $true)][string]$Path)
    $text = if (Test-Path -LiteralPath $Path -PathType Leaf) {
        Read-TextFile $Path
    } else {
        ''
    }
    $current = $null
    $empty = $true
    if ($text.Trim()) {
        try {
            $data = $text | ConvertFrom-Json
        } catch {
            Write-Host ("  [FAIL] $Path isn't valid JSON " +
                "($($_.Exception.Message)); set outputStyle yourself")
            return $false
        }
        $names = @($data.PSObject.Properties.Name)
        $empty = $names.Count -eq 0
        if ($names -contains 'outputStyle') {
            $current = $data.outputStyle
        }
    }

    if ($current -eq $StyleName) {
        Write-Host "  [OK] $Path already pins outputStyle '$StyleName'"
        return $true
    }
    if ($current) {
        Write-Host ("  [WARN] $Path pins outputStyle '$current', not " +
            "'$StyleName'. Left it alone.")
        return $true
    }

    if ($empty) {
        $new = "{`n  `"outputStyle`": `"$StyleName`"`n}`n"
    } else {
        $brace = $text.IndexOf('{')
        if ($brace -lt 0) {
            Write-Host ("  [FAIL] $Path isn't a JSON object; set " +
                'outputStyle yourself')
            return $false
        }
        $new = $text.Substring(0, $brace + 1) +
            "`n  `"outputStyle`": `"$StyleName`"," +
            $text.Substring($brace + 1)
    }
    try {
        $null = $new | ConvertFrom-Json
    } catch {
        Write-Host ("  [FAIL] editing $Path would produce invalid JSON; " +
            'set outputStyle yourself')
        return $false
    }
    Write-TextFile $Path $new
    Write-Host "  [OK] pinned outputStyle '$StyleName' in $Path"
    return $true
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
function Test-NoDuplication {
    param(
        [Parameter(Mandatory = $true)][string]$Target,
        [Parameter(Mandatory = $true)][string[]]$RulesFile
    )
    if (-not (Test-Path -LiteralPath $Target -PathType Leaf)) {
        Write-Host ("  [PASS] $Target doesn't exist, so it can't " +
            'duplicate anything')
        return $true
    }
    $text = Read-TextFile $Target
    $lines = $text -split "`n"
    $present = New-Object 'System.Collections.Generic.HashSet[string]'
    foreach ($line in $lines) {
        [void]$present.Add($line.Trim())
    }
    $ok = $true

    foreach ($marker in @('google-style', 'google-code')) {
        if ($text.Contains("BEGIN ${marker}:")) {
            Write-Host "  [FAIL] $Target still carries a managed $marker block"
            $ok = $false
        } else {
            Write-Host "  [PASS] $Target carries no managed $marker block"
        }
    }

    foreach ($file in $RulesFile) {
        $body = (Read-TextFile $file) -split "`n"
        $headings = @($body |
            Where-Object { $_.StartsWith('## ') } |
            ForEach-Object { $_.Trim() } |
            Select-Object -Unique)
        $canaries = @($body |
            Where-Object {
                ($_.StartsWith('- ') -or $_.StartsWith('**')) -and
                    $_.Trim().Length -ge 40
            } |
            ForEach-Object { $_.Trim() } |
            Select-Object -Unique)
        $hitHeadings = @($headings |
            Where-Object { $present.Contains($_) } | Sort-Object)
        $hitCanaries = @($canaries |
            Where-Object { $present.Contains($_) } | Sort-Object)
        $name = Split-Path -Leaf $file
        # One stray line can be coincidence. A heading, or three lines, is a
        # copy.
        if ($hitHeadings.Count -gt 0 -or $hitCanaries.Count -ge 3) {
            Write-Host ("  [FAIL] $Target contains unmarked text from " +
                "${name}: $($hitHeadings.Count) heading(s), " +
                "$($hitCanaries.Count) rule line(s)")
            foreach ($heading in ($hitHeadings | Select-Object -First 3)) {
                Write-Host "         heading: $heading"
            }
            foreach ($canary in ($hitCanaries | Select-Object -First 2)) {
                $head = if ($canary.Length -gt 70) {
                    $canary.Substring(0, 70)
                } else {
                    $canary
                }
                Write-Host "         line:    $head"
            }
            Write-Host ('         Remove it by hand. This script only ' +
                'deletes what its markers own.')
            $ok = $false
        } else {
            Write-Host "  [PASS] $Target has no unmarked copy of $name"
        }
    }

    $carriers = @('AGENTS.md', 'GEMINI.md', 'google-style.md',
        'google-style-rules.md', 'google-code-rules.md')
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match '^\s*@(\S+)') {
            $import = $Matches[1]
            if ($carriers -contains (Split-Path -Leaf $import)) {
                Write-Host ("  [FAIL] ${Target}:$($i + 1) imports a file " +
                    "that already carries the rules: $import")
                $ok = $false
            }
        }
    }
    return $ok
}

#######################################
# Wires Claude Code: the built output style carries both blocks, plus two
# copied skills. CLAUDE.md used to carry the same blocks, so strip them.
#######################################
function Install-ClaudeCode {
    Copy-ManagedFile $Style (Join-Parts $HomeDir, '.claude', 'output-styles',
        'google-style.md')
    $pinned = Set-OutputStylePin $ClaudeSettings
    Remove-Block google-style $ClaudeMd
    Remove-Block google-code $ClaudeMd
    Copy-SkillDir $Skill (Join-Parts $HomeDir, '.claude', 'skills',
        'google-style')
    Copy-SkillDir $CodeSkill (Join-Parts $HomeDir, '.claude', 'skills',
        'google-code')
    return $pinned
}

#######################################
# Wires the OpenAI Codex CLI: model_instructions_file plus two copied skills.
# The path is written as a TOML literal string, because a Windows path in a
# basic string would read every backslash as an escape.
#######################################
function Install-Codex {
    $config = Join-Parts $HomeDir, '.codex', 'config.toml'
    $entry = "model_instructions_file = '$AgentsFile'"
    $text = if (Test-Path -LiteralPath $config -PathType Leaf) {
        Read-TextFile $config
    } else {
        ''
    }
    if ($text -match '(?m)^model_instructions_file') {
        # An instance, not [regex]::Replace: the static overload takes no
        # count, so a 4th argument would bind to RegexOptions instead.
        $re = New-Object regex '(?m)^model_instructions_file\s*=.*$'
        $new = $re.Replace($text, { $entry }, 1)
        if ($new -ne $text) {
            Write-TextFile $config $new
        }
        Write-Host ("  [OK] model_instructions_file in $config points at " +
            $AgentsFile)
    } else {
        $prefix = if ($text -and -not $text.EndsWith("`n")) { "`n" } else { '' }
        Write-TextFile $config ($text + $prefix + $entry + "`n")
        Write-Host "  [OK] added model_instructions_file to $config"
    }
    Copy-SkillDir $Skill (Join-Parts $HomeDir, '.codex', 'skills',
        'google-style')
    Copy-SkillDir $CodeSkill (Join-Parts $HomeDir, '.codex', 'skills',
        'google-code')
}

#######################################
# Wires the universal ~\.agents folder, read by Codex and AGY. Neither has an
# output style, so AGENTS.md stays the always-on carrier for both blocks.
#######################################
function Install-AgentsDir {
    Sync-Block $Rules google-style $AgentsFile
    Sync-Block $CodeRules google-code $AgentsFile
    Copy-ManagedFile $AgentsFile (Join-Parts $HomeDir, '.agents', 'GEMINI.md')
    Copy-ManagedFile $Rules (Join-Parts $HomeDir, '.agents', 'rules',
        'google-style-rules.md')
    Copy-ManagedFile $CodeRules (Join-Parts $HomeDir, '.agents', 'rules',
        'google-code-rules.md')
    Copy-SkillDir $Skill (Join-Parts $HomeDir, '.agents', 'skills',
        'google-style')
    Copy-SkillDir $CodeSkill (Join-Parts $HomeDir, '.agents', 'skills',
        'google-code')
}

#######################################
# Checks that every skill this run installed is a complete copy. Hashing the
# probe file catches a copy left stale by an edit made since the last run,
# which is the failure mode copying trades for not needing symlink privilege.
#######################################
function Test-Skill {
    $roots = @()
    if ($script:WiredClaude) {
        $roots += Join-Parts $HomeDir, '.claude', 'skills'
    }
    if ($script:WiredCodex) {
        $roots += Join-Parts $HomeDir, '.codex', 'skills'
    }
    if ($script:WiredAgents) {
        $roots += Join-Parts $HomeDir, '.agents', 'skills'
    }
    if ($roots.Count -eq 0) {
        Write-Host '  [PASS] no skills installed this run'
        return $true
    }
    # Each entry is a skill name, its source, and a file that must resolve
    # inside the copy.
    $probes = @{
        'google-style' = @{
            Source = $Skill
            File = 'references\word-list.md'
        }
        'google-code' = @{
            Source = $CodeSkill
            File = 'references\python.md'
        }
    }
    $ok = $true
    foreach ($root in $roots) {
        foreach ($name in @('google-style', 'google-code')) {
            $dir = Join-Parts $root, $name
            $probe = Join-Parts $dir, $probes[$name].File
            $source = Join-Parts $probes[$name].Source, $probes[$name].File
            if (-not (Test-Path -LiteralPath $probe -PathType Leaf)) {
                Write-Host "  [FAIL] $dir is not a complete skill copy"
                $ok = $false
                continue
            }
            $copied = (Get-FileHash -LiteralPath $probe).Hash
            $original = (Get-FileHash -LiteralPath $source).Hash
            if ($copied -ne $original) {
                Write-Host "  [FAIL] $dir is a stale copy; re-run this script"
                $ok = $false
                continue
            }
            Write-Host "  [PASS] $dir resolves with references\"
        }
    }
    return $ok
}

#######################################
# Checks that each always-on carrier holds exactly one copy of each block, and
# that the tracked template holds none. A block in the template would mean a
# run had mutated its own source.
#######################################
function Test-Carrier {
    $files = @($Style)
    if ($script:WiredAgents) {
        $files += $AgentsFile
    }
    $ok = $true
    foreach ($file in $files) {
        $text = if (Test-Path -LiteralPath $file -PathType Leaf) {
            Read-TextFile $file
        } else {
            ''
        }
        foreach ($marker in @('google-style', 'google-code')) {
            $pattern = 'BEGIN ' + [regex]::Escape($marker) + ':'
            $count = ([regex]::Matches($text, $pattern)).Count
            if ($count -eq 1) {
                Write-Host "  [PASS] $file carries exactly one $marker block"
            } else {
                Write-Host ("  [FAIL] $file doesn't carry exactly one " +
                    "$marker block")
                $ok = $false
            }
        }
    }
    $template = Read-TextFile $StyleTemplate
    foreach ($marker in @('google-style', 'google-code')) {
        if ($template.Contains("BEGIN ${marker}:")) {
            Write-Host ("  [FAIL] $StyleTemplate carries a $marker block; " +
                'the tracked template must stay clean')
            $ok = $false
        } else {
            Write-Host "  [PASS] $StyleTemplate carries no $marker block"
        }
    }
    return $ok
}

#######################################
# Checks the output style resolves and the global pin points at it. Claude Code
# resolves an output style by its frontmatter name, not its filename, and a
# mismatch drops it back to the default with no error -- which, now that the
# output style is the only Claude Code carrier, would drop every rule.
#######################################
function Test-OutputStylePin {
    $ok = $true
    $text = Read-TextFile $Style
    $actual = ''
    $frontmatter = [regex]::Match($text, '(?s)\A---\n(.*?)\n---\n')
    if ($frontmatter.Success) {
        $body = $frontmatter.Groups[1].Value
        $name = [regex]::Match($body, '(?m)^name:\s*(\S+)')
        if ($name.Success) {
            $actual = $name.Groups[1].Value
        }
    }
    if ($actual -eq $StyleName) {
        Write-Host "  [PASS] $Style declares name: $StyleName"
    } else {
        $shown = if ($actual) { $actual } else { '<none>' }
        Write-Host ("  [FAIL] $Style declares name: '$shown', expected " +
            "'$StyleName'")
        $ok = $false
    }

    $pinned = ''
    if (Test-Path -LiteralPath $ClaudeSettings -PathType Leaf) {
        try {
            $data = (Read-TextFile $ClaudeSettings) | ConvertFrom-Json
            if (@($data.PSObject.Properties.Name) -contains 'outputStyle') {
                $pinned = [string]$data.outputStyle
            }
        } catch {
            $pinned = ''
        }
    }
    if ($pinned -eq $StyleName) {
        Write-Host "  [PASS] $ClaudeSettings pins outputStyle '$StyleName'"
    } else {
        $shown = if ($pinned) { $pinned } else { '<none>' }
        Write-Host "  [FAIL] $ClaudeSettings pins outputStyle '$shown'"
        $ok = $false
    }
    return $ok
}

#######################################
# Wires every detected CLI, then verifies the result. Returns 1 if any check
# fails.
#######################################
function Invoke-Main {
    if (-not (Test-SourceFile)) {
        return 1
    }

    Write-Host ("Configuring cross-CLI Google developer style guides " +
        "from $Src...")
    Build-Style

    $fail = $false
    if ($All -or (Test-CliInstalled claude)) {
        if (-not (Install-ClaudeCode)) {
            $fail = $true
        }
        $script:WiredClaude = $true
    } else {
        Write-Host '  [SKIP] Claude Code not detected: no claude on PATH.'
    }

    if ($All -or (Test-CliInstalled codex)) {
        Install-Codex
        $script:WiredCodex = $true
    } else {
        Write-Host '  [SKIP] Codex CLI not detected: no codex on PATH.'
    }

    # Codex reads ~\.agents\AGENTS.md; AGY ships either agy or antigravity.
    $agentsReader = Test-CliInstalled agy, antigravity, gemini
    if ($All -or $script:WiredCodex -or $agentsReader) {
        Install-AgentsDir
        $script:WiredAgents = $true
    } else {
        Write-Host ('  [SKIP] No ~\.agents reader detected: no codex, agy, ' +
            'antigravity, or gemini on PATH.')
    }

    Write-Host ''
    Write-Host 'Verifying...'
    if (-not (Test-Skill)) { $fail = $true }
    if (-not (Test-Carrier)) { $fail = $true }
    if ($script:WiredClaude) {
        if (-not (Test-NoDuplication $ClaudeMd @($Rules, $CodeRules))) {
            $fail = $true
        }
        if (-not (Test-OutputStylePin)) { $fail = $true }
    }

    if ($fail) {
        Write-Host 'Setup incomplete.'
        return 1
    }
    if ($script:WiredClaude -or $script:WiredCodex -or $script:WiredAgents) {
        Write-Host 'All detected CLIs configured.'
        Write-Host ('Installed as copies, not links: re-run this script ' +
            'after editing rules\ or skills\.')
    } else {
        Write-Host 'No CLI detected on PATH. Nothing to configure.'
    }
    return 0
}

exit (Invoke-Main)
