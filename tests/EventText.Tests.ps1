BeforeAll {
    $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
    . (Join-Path $script:RepoRoot 'tools\EventPacks.ps1')
    $script:BannedPatterns = Get-EpBannedPatterns -RepoRoot $script:RepoRoot

    function Get-TextMessages {
        param([string]$Text)

        return @(Test-EpText -Where 'probe' -Text $Text -BannedPatterns $script:BannedPatterns | ForEach-Object { $_.Message })
    }
}

Describe 'Text lint' {
    It 'passes plain period prose' {
        Get-TextMessages -Text 'The harvest in Ostrobothnia was late. Farmers in Seinajoki brought in the rye in October, and the cooperative dairies cut their prices.' | Should -BeNullOrEmpty
    }

    It 'finds the stock phrases of generated prose' {
        foreach ($probeText in @(
                'The new airfield stands as a testament to the nation.',
                'A rich tapestry of villages lines the shore.',
                'It serves as a stark reminder of the war.',
                'Ultimately, the parliament agreed.',
                'Their resilience carried the day.',
                'In the heart of Helsinki, crowds gathered.'
            )) {
            @(Get-TextMessages -Text $probeText | Where-Object { $_ -like 'banned phrase*' }).Count | Should -BeGreaterThan 0 -Because $probeText
        }
    }

    It 'finds the not-just-but construction' {
        @(Get-TextMessages -Text 'This was not just a race, but a statement to the world.' | Where-Object { $_ -like 'banned phrase*' }).Count | Should -BeGreaterThan 0
        @(Get-TextMessages -Text 'It was not only the army but also the farmers who paid.' | Where-Object { $_ -like 'banned phrase*' }).Count | Should -BeGreaterThan 0
    }

    It 'finds dashes, curved quotes, the ellipsis character and straight double quotes' {
        $emDash = [string][char]0x2014
        $leftQuote = [string][char]0x201C
        $rightQuote = [string][char]0x201D
        $ellipsis = [string][char]0x2026
        (Get-TextMessages -Text "The line held${emDash}for now.") | Should -Contain 'contains a em dash'
        (Get-TextMessages -Text "He said ${leftQuote}no${rightQuote}.") | Should -Contain 'contains a curved quote'
        (Get-TextMessages -Text "And then${ellipsis}") | Should -Contain 'contains a ellipsis character'
        @(Get-TextMessages -Text 'He said "no".' | Where-Object { $_ -like '*straight double quote*' }).Count | Should -Be 1
    }

    It 'finds the characters the localisation system reads as markup' {
        foreach ($markupText in @('The [ROOT.GetName] parliament met.', 'Prices rose by $5.', 'Plan #3 failed.', ('A ' + [char]0x00A7 + 'Yred' + [char]0x00A7 + '! line.'))) {
            @(Get-TextMessages -Text $markupText | Where-Object { $_ -like '*markup*' -or $_ -like '*code*' -or $_ -like '*formatting*' }).Count | Should -BeGreaterThan 0 -Because $markupText
        }
    }

    It 'leaves a question at the end of a description alone, as vanilla uses it' {
        Get-TextMessages -Text 'They want us to cede Karelia to them. How should we respond?' | Should -BeNullOrEmpty
    }

    It 'counts words with digits, hyphens and apostrophes as one word each' {
        Get-EpWordCount -Text "In 1937 the Civil Guard's anti-tank ditch grew." | Should -Be 8
    }
}

Describe 'Description rules' {
    BeforeAll {
        function New-ProbePack {
            param([string]$Desc, [string[]]$Anchors, [string]$FactSheet = ("## probe`r`n`r`n- Fact. Source: https://example.org/a (Probe). Quote: " + [char]0x00AB + 'Fact.' + [char]0x00BB + "`r`n"))

            $probeEvent = [PSCustomObject]@{
                id = 1; key = 'probe'; title = 'Probe'; desc = $Desc; picture = 'vanilla:GFX_report_event_generic_read_write'; factSheet = 'probe'; anchors = $Anchors
                fire = [PSCustomObject]@{ after = '1936.1.1'; before = '1937.1.1'; chance = 5 }
                options = @([PSCustomObject]@{ name = 'Noted.'; ai = 1; effects = @() })
            }
            return [PSCustomObject]@{ Name = 'probe'; RepoRoot = $script:RepoRoot; Tag = 'PRB'; Namespace = 'ep_prb'; Events = @($probeEvent); Ideas = @(); Pictures = @(); FactSheetText = $FactSheet }
        }

        function Get-RuleMessages {
            param($Pack)

            return @(Test-EpPackSource -Pack $Pack | Where-Object { $_.Level -eq 'ERROR' } | ForEach-Object { $_.Message })
        }

        $script:LongDesc = ('Tampere and Turku ' + (@(1..30 | ForEach-Object { 'word' }) -join ' ') + ' and more words to pass the lower bound of the rule for descriptions here.')
    }

    It 'accepts a description of the right length that uses two of its anchors' {
        Get-RuleMessages -Pack (New-ProbePack -Desc $script:LongDesc -Anchors @('Tampere', 'Turku')) | Should -BeNullOrEmpty
    }

    It 'rejects a description that is too short or uses too few anchors' {
        ((Get-RuleMessages -Pack (New-ProbePack -Desc 'Tampere and Turku.' -Anchors @('Tampere', 'Turku'))) -join "`n") | Should -Match 'words, needs 40 to 170'
        ((Get-RuleMessages -Pack (New-ProbePack -Desc $script:LongDesc -Anchors @('Tampere', 'Oulu'))) -join "`n") | Should -Match 'Missing: Oulu'
        ((Get-RuleMessages -Pack (New-ProbePack -Desc $script:LongDesc -Anchors @('Tampere'))) -join "`n") | Should -Match 'lists 1 anchor'
    }

    It 'rejects an event whose fact sheet is missing or cites no source' {
        ((Get-RuleMessages -Pack (New-ProbePack -Desc $script:LongDesc -Anchors @('Tampere', 'Turku') -FactSheet '')) -join "`n") | Should -Match "no section '## probe'"
        ((Get-RuleMessages -Pack (New-ProbePack -Desc $script:LongDesc -Anchors @('Tampere', 'Turku') -FactSheet "## probe`r`n`r`n- A fact without a link.`r`n")) -join "`n") | Should -Match 'cites no source URL'
    }
}
