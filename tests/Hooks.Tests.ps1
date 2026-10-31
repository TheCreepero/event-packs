BeforeAll {
    $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
    $script:ProtectHook = Join-Path $script:RepoRoot '.claude\hooks\Protect-ProjectFiles.ps1'
    $script:PowerShellExe = (Get-Process -Id $PID).Path

    function Invoke-ProtectHook {
        param([string]$ToolName, [hashtable]$ToolInput)

        $hookJson = ConvertTo-Json -InputObject @{ tool_name = $ToolName; tool_input = $ToolInput } -Depth 4 -Compress
        $previousErrorAction = $ErrorActionPreference
        $ErrorActionPreference = 'Continue'
        try {
            $null = $hookJson | & $script:PowerShellExe -NoProfile -ExecutionPolicy Bypass -File $script:ProtectHook -RepoRoot $script:RepoRoot 2>&1
            $hookExitCode = $LASTEXITCODE
        } finally {
            $ErrorActionPreference = $previousErrorAction
        }
        return $hookExitCode
    }
}

Describe 'Protect-ProjectFiles hook' {
    It 'refuses an edit of <Path>' -TestCases @(
        @{ Path = 'packs\finland\events\ep_fin_events.txt' },
        @{ Path = 'packs\finland\localisation\english\ep_fin_l_english.yml' },
        @{ Path = 'packs\finland\gfx\event_pictures\ep_fin\ep_fin_x.dds' },
        @{ Path = 'packs\finland\sound\x.wav' },
        @{ Path = 'packs\finland\history\x.txt' },
        @{ Path = 'packs\finland\WORKSHOP_DESCRIPTION_GUIDELINES.md' },
        @{ Path = 'source\finland\pictures.json' },
        @{ Path = 'wiki\Event-Pack-Finland.md' },
        @{ Path = 'tools\HoiModBuild.ps1' },
        @{ Path = '.agents\skills\event-pack-create\SKILL.md' }
    ) {
        param($Path)
        Invoke-ProtectHook -ToolName 'Write' -ToolInput @{ file_path = (Join-Path $script:RepoRoot $Path) } | Should -Be 2
    }

    It 'allows an edit of <Path>' -TestCases @(
        @{ Path = 'packs\finland\descriptor.mod' },
        @{ Path = 'packs\finland\thumbnail.png' },
        @{ Path = 'source\finland\events.json' },
        @{ Path = 'source\finland\fact-sheets.md' },
        @{ Path = 'docs\plans\2026-11-01-finland-pack.md' },
        @{ Path = 'scratch\rehearsal\packs\finland\events\ep_fin_events.txt' },
        @{ Path = 'scratch\rehearsal\source\finland\pictures.json' }
    ) {
        param($Path)
        Invoke-ProtectHook -ToolName 'Edit' -ToolInput @{ file_path = (Join-Path $script:RepoRoot $Path) } | Should -Be 0
    }

    It 'refuses the shell write <Command>' -TestCases @(
        @{ Command = 'Set-Content packs\finland\localisation\english\x.yml "a"' },
        @{ Command = 'Set-Content source\finland\pictures.json "{}"' },
        @{ Command = 'Set-Location packs\finland; Set-Content events\x.txt "x"' },
        @{ Command = '$p="packs\finland"; Set-Content "$p\events\x.txt" x' },
        @{ Command = "python -c `"open('packs/finland/events/x.txt','w').write('x')`"" },
        @{ Command = 'powershell -File .\build.ps1 -Generate; Remove-Item packs\finland\events\ep_fin_events.txt' },
        @{ Command = 'echo x > packs/finland/sound/x.wav' },
        @{ Command = 'cp other.json source/finland/pictures.json' },
        @{ Command = 'Get-ChildItem docs; Set-Content packs\finland\events\x.txt x' },
        @{ Command = 'cd packs/finland && rm events/x.txt' },
        @{ Command = "python -c `"import os; open('packs/finland/x.txt','w')`"" },
        @{ Command = 'Copy-Item x.md wiki\Event-Pack-Finland.md' },
        @{ Command = 'Set-Content tools\HoiModBuild.ps1 x' },
        @{ Command = 'Remove-Item tests\Run-Tests.ps1' },
        @{ Command = 'Set-Content .agents\skills\event-pack-create\SKILL.md x' },
        @{ Command = 'python "W:\Antigravity\Mod Thumbnail Generator\generate_branding.py" --title "EVENT PACK" --subtitle "FINLAND" --hoi4 --out-dirs "packs\finland"' },
        @{ Command = 'Copy-Item scratch\thumbnail\finland\thumbnail.png packs\finland\descriptor.mod' },
        @{ Command = 'Copy-Item scratch\thumbnail\finland\thumbnail.png packs\finland\gfx\thumbnail.png' },
        @{ Command = 'Copy-Item scratch\thumbnail\finland\thumbnail.png packs\finland\thumbnail.png.bak' },
        @{ Command = 'Copy-Item -Recurse scratch\thumbnail packs\finland\thumbnail.png' },
        @{ Command = 'Copy-Item scratch\a.png, scratch\b.png packs\finland\thumbnail.png' },
        @{ Command = 'Copy-Item "$(Remove-Item packs\finland\events\x.txt)" packs\finland\thumbnail.png' },
        @{ Command = 'Move-Item packs\finland\events\ep_fin_events.txt packs\finland\thumbnail.png' },
        @{ Command = 'Copy-Item scratch\thumbnail\finland\thumbnail.png packs\finland\thumbnail.png; Remove-Item packs\finland\events\x.txt' },
        @{ Command = 'Set-Location packs\finland; Copy-Item ..\..\scratch\t.png packs\finland\thumbnail.png' },
        @{ Command = 'Remove-Item packs\finland\events\x.txt | Copy-Item scratch\a.png packs\finland\thumbnail.png' },
        @{ Command = 'python x.py scratch\a.png packs\finland\thumbnail.png' },
        @{ Command = 'if ($true) { $p = ''packs\finland\events\x.txt'' }; Remove-Item $p' },
        @{ Command = '& { Set-Location packs\finland; Remove-Item events\x.txt }' },
        @{ Command = 'git status $(Remove-Item packs\finland\events\x.txt)' },
        @{ Command = '[System.IO.Directory]::SetCurrentDirectory(''packs\finland''); Remove-Item events\x.txt' },
        @{ Command = 'Set-Variable p packs\finland; Remove-Item $p\events\x.txt' },
        @{ Command = 'Get-Item packs\finland -OutVariable p; Remove-Item $p\events\x.txt' },
        @{ Command = "python -c @'`nopen('packs/finland/x.txt','w'); x = 1`n'@" }
    ) {
        param($Command)
        Invoke-ProtectHook -ToolName 'PowerShell' -ToolInput @{ command = $Command } | Should -Be 2
    }

    It 'refuses the Bash write <Command>' -TestCases @(
        @{ Command = '(cd packs/finland && rm events/x.txt)' },
        @{ Command = 'git status & rm packs/finland/events/x.txt' },
        @{ Command = 'python -c "x=\"; y\"; open(''packs/finland/x.txt'',''w'')"' },
        @{ Command = "python - <<EOF`nopen('packs/finland/x.txt','w')`nEOF" },
        @{ Command = "rm \`npacks/finland/events/x.txt" },
        @{ Command = 'echo `rm packs/finland/events/x.txt`' }
    ) {
        param($Command)
        Invoke-ProtectHook -ToolName 'Bash' -ToolInput @{ command = $Command } | Should -Be 2
    }

    It 'allows the command <Command>' -TestCases @(
        @{ Command = 'powershell -File .\build.ps1 -Generate -Pack finland' },
        @{ Command = 'powershell -File .\build.ps1 -FetchPicture -Pack finland -File "File:Abatis at Taipale.jpg" -Key abatis -Tone warm' },
        @{ Command = '.\build.ps1 -Check' },
        @{ Command = 'git status --short -- packs/finland' },
        @{ Command = 'git diff -- source/finland/pictures.json' },
        @{ Command = 'Get-Content packs\finland\events\ep_fin_events.txt' },
        @{ Command = 'Get-ChildItem packs\finland -Recurse 2>$null' },
        @{ Command = 'git mv docs/plans/2026-11-01-finland-pack.md docs/plans/archive/2026-11-01-finland-pack.md; git add packs/finland source/finland' },
        @{ Command = 'Move-Item docs\plans\x.md docs\plans\archive\x.md; git add docs\plans\archive\x.md packs\finland wiki\Event-Pack-Finland.md' },
        @{ Command = 'git add packs/finland source/finland && git commit -m "feat(finland): ten events"' },
        @{ Command = 'Get-Content packs\finland\events\ep_fin_events.txt; Copy-Item docs\a.md scratch\b.md' },
        @{ Command = 'Copy-Item .claude\skills\event-pack-create\SKILL.md scratch\skill.md' },
        @{ Command = 'Set-Location packs\finland; git status --short' },
        @{ Command = 'powershell -File .\build.ps1 -Check -Pack finland 2>&1 | Select-Object -Last 5' },
        @{ Command = 'python "W:\Antigravity\Mod Thumbnail Generator\generate_branding.py" --bg-image (Get-Item sources-cache\finland\abatis.*).FullName --title "EVENT PACK" --subtitle "FINLAND" --theme white --text-pos top --hoi4 --json --out-dirs "scratch\thumbnail\finland"' },
        @{ Command = 'Copy-Item scratch\thumbnail\finland\thumbnail.png packs\finland\thumbnail.png' },
        @{ Command = 'Copy-Item -LiteralPath "scratch\thumbnail\finland\thumbnail.png" -Destination "packs\finland\thumbnail.png" -Force' },
        @{ Command = 'Get-ChildItem scratch\thumbnail\finland; Copy-Item scratch\thumbnail\finland\thumbnail.png .\packs\finland\thumbnail.png' }
    ) {
        param($Command)
        Invoke-ProtectHook -ToolName 'PowerShell' -ToolInput @{ command = $Command } | Should -Be 0
    }

    It 'allows the Bash copy of a generated thumbnail into a pack' {
        Invoke-ProtectHook -ToolName 'Bash' -ToolInput @{ command = 'cp scratch/thumbnail/finland/thumbnail.png packs/finland/thumbnail.png' } | Should -Be 0
    }
}

Describe 'Show-PlanState hook' {
    It 'prints the plan states and the uncommitted files and exits 0' {
        $planStateHook = Join-Path $script:RepoRoot '.claude\hooks\Show-PlanState.ps1'
        $hookOutput = @('{}' | & $script:PowerShellExe -NoProfile -ExecutionPolicy Bypass -File $planStateHook -RepoRoot $script:RepoRoot)
        $LASTEXITCODE | Should -Be 0
        $hookOutput[0] | Should -BeLike 'Plans in docs/plans*'
        $hookOutput | Should -Contain 'Uncommitted files (git status --short):'
    }
}
