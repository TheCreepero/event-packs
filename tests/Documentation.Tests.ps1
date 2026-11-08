BeforeAll {
    $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
    $script:SkillRoot = Join-Path $script:RepoRoot '.claude\skills'
    $script:AgentRoot = Join-Path $script:RepoRoot '.claude\agents'
    $script:BuildParameters = @((Get-Command (Join-Path $script:RepoRoot 'build.ps1')).Parameters.Keys)

    function Get-FrontMatter {
        param([string]$Path)

        $text = [System.IO.File]::ReadAllText($Path, [System.Text.Encoding]::UTF8)
        $frontMatterMatch = [regex]::Match($text, '(?s)\A---\r?\n(.*?)\r?\n---')
        $fields = @{}
        foreach ($frontMatterLine in @($frontMatterMatch.Groups[1].Value -split '\r?\n')) {
            if ($frontMatterLine -match '^(\w[\w-]*):\s*(.*)$') {
                $fields[$Matches[1]] = $Matches[2].Trim()
            }
        }
        return $fields
    }
}

Describe 'Skills' {
    It 'has the four workflow skills, each with a name matching its folder and a description' {
        $skillNames = @(Get-ChildItem -LiteralPath $script:SkillRoot -Directory | ForEach-Object { $_.Name } | Sort-Object)
        $skillNames | Should -Be @('event-pack-audit', 'event-pack-create', 'event-pack-implement', 'event-pack-release')
        foreach ($skillName in $skillNames) {
            $frontMatter = Get-FrontMatter -Path (Join-Path $script:SkillRoot "$skillName\SKILL.md")
            $frontMatter['name'] | Should -Be $skillName
            $frontMatter['description'] | Should -Not -BeNullOrEmpty
        }
    }

    It 'keeps the Antigravity mirror identical to the Claude Code skills' {
        . (Join-Path $script:RepoRoot 'tools\HoiModBuild.ps1')
        $staleMirrors = @(Get-ModSkillMirrorStates -RepoPath $script:RepoRoot -ExcludeSkillName @() | Where-Object { $_.State -ne 'Current' } | ForEach-Object { "$($_.Target) $($_.State): $(@($_.Problems) + @($_.DifferingFiles) -join ', ')" })
        $staleMirrors | Should -BeNullOrEmpty -Because 'build.ps1 -SyncMirrors writes the mirror'
    }

    It 'names only build.ps1 switches that exist and agents that exist' {
        $agentNames = @(Get-ChildItem -LiteralPath $script:AgentRoot -Filter '*.md' | ForEach-Object { $_.BaseName })
        foreach ($skillFile in @(Get-ChildItem -LiteralPath $script:SkillRoot -Recurse -Filter 'SKILL.md')) {
            $skillText = [System.IO.File]::ReadAllText($skillFile.FullName, [System.Text.Encoding]::UTF8)
            foreach ($commandMatch in [regex]::Matches($skillText, 'build\.ps1((?:\s+-\w+(?:\s+(?:"[^"]*"|[^\s`-][^\s`]*))?)+)')) {
                foreach ($switchMatch in [regex]::Matches($commandMatch.Groups[1].Value, '-(\w+)')) {
                    $script:BuildParameters | Should -Contain $switchMatch.Groups[1].Value -Because "$($skillFile.Directory.Name) runs build.ps1 -$($switchMatch.Groups[1].Value)"
                }
            }
            foreach ($agentMatch in [regex]::Matches($skillText, '`(ep-[a-z-]+)`')) {
                $agentNames | Should -Contain $agentMatch.Groups[1].Value -Because "$($skillFile.Directory.Name) dispatches $($agentMatch.Groups[1].Value)"
            }
        }
    }

    It 'leaves the release skill to the user' {
        (Get-FrontMatter -Path (Join-Path $script:SkillRoot 'event-pack-release\SKILL.md'))['disable-model-invocation'] | Should -Be 'true'
    }
}

Describe 'Agents' {
    It 'every agent names itself, a model, a turn limit and its tools' {
        foreach ($agentFile in @(Get-ChildItem -LiteralPath $script:AgentRoot -Filter '*.md')) {
            $frontMatter = Get-FrontMatter -Path $agentFile.FullName
            $frontMatter['name'] | Should -Be $agentFile.BaseName
            @('sonnet', 'opus', 'haiku') | Should -Contain $frontMatter['model'] -Because $agentFile.Name
            [int]$frontMatter['maxTurns'] | Should -BeGreaterThan 0 -Because $agentFile.Name
            $frontMatter['tools'] | Should -Not -BeNullOrEmpty -Because $agentFile.Name
        }
    }

    It 'gives the researchers the web tools and keeps the editor and reviewer read-only' {
        (Get-FrontMatter -Path (Join-Path $script:AgentRoot 'ep-historical-researcher.md'))['tools'] | Should -Match 'WebSearch'
        (Get-FrontMatter -Path (Join-Path $script:AgentRoot 'ep-picture-researcher.md'))['tools'] | Should -Match 'WebFetch'
        (Get-FrontMatter -Path (Join-Path $script:AgentRoot 'ep-editor.md'))['tools'] | Should -Not -Match 'Edit|Write|PowerShell|Bash|Web'
        (Get-FrontMatter -Path (Join-Path $script:AgentRoot 'ep-reviewer.md'))['tools'] | Should -Not -Match 'Edit|Write'
    }

    It 'the researchers carry the shared research method' {
        foreach ($agentName in @('ep-historical-researcher', 'ep-picture-researcher', 'ep-audit-researcher')) {
            [System.IO.File]::ReadAllText((Join-Path $script:AgentRoot "$agentName.md")) | Should -Match '(?s)hoi-agent-block:web-research-method:begin -->\r?\n- Use WebSearch' -Because "$agentName includes the Manager's block; Sync-ModScaffold.ps1 fills it"
        }
    }
}

Describe 'Plan template and guides' {
    It 'the plan template has every section the skills and the implementer use' {
        $templateText = [System.IO.File]::ReadAllText((Join-Path $script:RepoRoot 'docs\plans\TEMPLATE-pack.md'))
        foreach ($heading in @('## For the implementer', '## Context', '## Decisions', '## Events', '## Pictures', '## Fact verification', '## Trigger verification', '## Editor record', '## Kept on judgment', '## Implementation steps', '## Stop conditions', '## Outcome', '## Fact sheets', '## Events source')) {
            $templateText | Should -Match ('(?m)^' + [regex]::Escape($heading) + '\s*$')
        }
        $templateText | Should -Match '(?m)^Status: PLANNING'
        $templateText | Should -Match '(?m)^Pack intro: ' -Because 'the pack intro goes into the plan and a step writes it'
        $templateText | Should -Match '(?m)^Bundle intro: '
        $templateText | Should -Match '```json events'
        $templateText | Should -Match '```markdown fact-sheets'
    }

    It 'the style guide and the source format exist and the rule file points to them' {
        $rulesText = [System.IO.File]::ReadAllText((Join-Path $script:RepoRoot 'AGENTS.md'))
        foreach ($guidePath in @('docs/style-guide.md', 'docs/source-format.md')) {
            Test-Path -LiteralPath (Join-Path $script:RepoRoot $guidePath) | Should -BeTrue
            $rulesText | Should -Match ([regex]::Escape($guidePath))
        }
    }

    It 'the rules, the source format, the plan template and the skills agree on the Checked line of a dossier' {
        $checkedLine = 'Checked: <plan file name>, <K> kept, <F> fixed, <D> dropped. The facts below are the researcher''s notes, not the checked ones: see'
        foreach ($documentPath in @('docs\source-format.md', '.claude\skills\event-pack-create\SKILL.md', '.claude\skills\event-pack-audit\SKILL.md')) {
            [System.IO.File]::ReadAllText((Join-Path $script:RepoRoot $documentPath), [System.Text.Encoding]::UTF8) | Should -Match ([regex]::Escape($checkedLine)) -Because "$documentPath gives the form of the Checked line"
        }
        foreach ($documentPath in @('AGENTS.md', 'docs\plans\TEMPLATE-pack.md', '.claude\skills\event-pack-implement\SKILL.md')) {
            [System.IO.File]::ReadAllText((Join-Path $script:RepoRoot $documentPath), [System.Text.Encoding]::UTF8) | Should -Match '`Checked:`' -Because "$documentPath names the Checked line"
        }
    }
}
