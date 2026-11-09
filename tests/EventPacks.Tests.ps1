BeforeAll {
    $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
    . (Join-Path $script:RepoRoot 'tools\EventPacks.ps1')
    . (Join-Path $script:RepoRoot 'tools\EventPacksTestMod.ps1')
    $script:CommonsFixtureDir = Join-Path $PSScriptRoot 'fixtures\image-sources\commons'

    function Get-CommonsFixture {
        param([string]$Name)

        return ([System.IO.File]::ReadAllText((Join-Path $script:CommonsFixtureDir "$Name.json"), [System.Text.Encoding]::UTF8) | ConvertFrom-Json)
    }

    function Write-FixtureFile {
        param([string]$Root, [string]$RelativePath, [string]$Text, [switch]$Bom)

        Write-EpText -Path (Join-Path $Root $RelativePath) -Text $Text -Bom:$Bom
    }

    function Write-FixtureDds {
        param([string]$Path, [int]$Width = 210, [int]$Height = 176)

        $ddsBytes = New-Object byte[] 128
        [System.Text.Encoding]::ASCII.GetBytes('DDS ').CopyTo($ddsBytes, 0)
        [System.BitConverter]::GetBytes([int]124).CopyTo($ddsBytes, 4)
        [System.BitConverter]::GetBytes($Height).CopyTo($ddsBytes, 12)
        [System.BitConverter]::GetBytes($Width).CopyTo($ddsBytes, 16)
        $parentPath = Split-Path -Parent $Path
        if (-not (Test-Path -LiteralPath $parentPath)) {
            New-Item -ItemType Directory -Path $parentPath -Force | Out-Null
        }
        [System.IO.File]::WriteAllBytes($Path, $ddsBytes)
    }

    function Get-FixtureEvent {
        return [PSCustomObject][ordered]@{
            id        = 1
            key       = 'border_fortification'
            title     = 'Work on the Isthmus Line'
            desc      = 'Volunteers from the Civil Guard and students from Helsinki spend the summer of 1937 digging trenches and anti-tank ditches on the Karelian Isthmus. The army supplies tools and rations, the volunteers their own time. Engineers mark the line between Summa and Taipale, and the work goes on until the autumn rain fills the ditches.'
            picture   = 'abatis'
            factSheet = 'border_fortification'
            anchors   = @('Karelian Isthmus', 'Taipale', '1937')
            fire      = [PSCustomObject][ordered]@{ after = '1937.5.1'; before = '1937.9.1'; chance = 10; trigger = 'has_war = no' }
            options   = @(
                [PSCustomObject][ordered]@{ name = 'Every metre counts.'; ai = 70; effects = @([PSCustomObject]@{ war_support = 0.02 }, [PSCustomObject]@{ timed_idea = 'volunteer_work'; days = 120 }) },
                [PSCustomObject][ordered]@{ name = 'Send them home before the harvest.'; ai = 30; effects = @([PSCustomObject]@{ political_power = 25 }, [PSCustomObject]@{ stability = -0.01 }) }
            )
        }
    }

    function Get-FixtureFactLine {
        param([switch]$WithoutQuote)

        $factLine = '- Volunteers dug on the Karelian Isthmus in 1937, Taipale to Summa. Source: https://example.org/isthmus (Isthmus works)'
        if ($WithoutQuote) {
            return $factLine
        }
        return $factLine + '. Quote: ' + [char]0x00AB + 'Kesalla 1937 vapaaehtoiset kaivoivat Taipaleen ja Summan valilla.' + [char]0x00BB
    }

    function Set-FixtureFactSheet {
        param([string]$Root, [string[]]$FactLines)

        Write-FixtureFile -Root $Root -RelativePath 'source\testland\fact-sheets.md' -Text ("# Fact sheets`r`n`r`n## border_fortification`r`n`r`n" + ($FactLines -join "`r`n") + "`r`n")
    }

    function New-EpFixtureRepo {
        param([string[]]$Packs = @('testland'))

        $fixtureRoot = Join-Path $TestDrive ([guid]::NewGuid().ToString('N').Substring(0, 8))
        New-Item -ItemType Directory -Path (Join-Path $fixtureRoot 'data') -Force | Out-Null
        Copy-Item -Path (Join-Path $script:RepoRoot 'data\*') -Destination (Join-Path $fixtureRoot 'data')
        $packageSettings = [ordered]@{}
        foreach ($packName in $Packs) {
            $packageSettings[$packName] = [PSCustomObject]@{ root = "packs/$packName"; modFolderName = "event_pack_$packName" }
        }
        Write-FixtureFile -Root $fixtureRoot -RelativePath 'tools\HoiModBuild.json' -Text (ConvertTo-Json -InputObject ([PSCustomObject]@{ packages = [PSCustomObject]$packageSettings }) -Depth 5)
        $tagIndex = 0
        foreach ($packName in $Packs) {
            $tag = @('TST', 'TSU', 'TSV')[$tagIndex]
            $tagIndex++
            $eventSource = [PSCustomObject][ordered]@{
                pack        = $packName
                tag         = $tag
                namespace   = 'ep_' + $tag.ToLowerInvariant()
                displayName = 'Testland ' + $tagIndex
                events      = @(Get-FixtureEvent)
                ideas       = @([PSCustomObject][ordered]@{ key = 'volunteer_work'; name = 'Volunteer Work on the Isthmus'; desc = 'Students and Civil Guard men dig on the Karelian Isthmus.'; picture = 'generic_morale_bonus'; modifier = [PSCustomObject]@{ war_support_factor = 0.03 } })
            }
            Write-FixtureFile -Root $fixtureRoot -RelativePath "source\$packName\events.json" -Text (ConvertTo-Json -InputObject $eventSource -Depth 10)
            $picture = (Get-EpCommonsVerdict -Response (Get-CommonsFixture -Name 'cc-by')).Picture
            $picture.key = 'abatis'
            $picture.fetched = '2026-10-31'
            $picture.downloadSha256 = '0000000000000000000000000000000000000000000000000000000000000000'
            Write-FixtureFile -Root $fixtureRoot -RelativePath "source\$packName\pictures.json" -Text (ConvertTo-Json -InputObject ([PSCustomObject]@{ pictures = @($picture) }) -Depth 5)
            Write-FixtureFile -Root $fixtureRoot -RelativePath "source\$packName\fact-sheets.md" -Text ("# Fact sheets`r`n`r`n## border_fortification`r`n`r`n" + (Get-FixtureFactLine) + "`r`n")
            Write-FixtureFile -Root $fixtureRoot -RelativePath "source\$packName\workshop-intro.bbcode" -Text 'Fixture intro.'
            Write-FixtureDds -Path (Join-Path $fixtureRoot "packs\$packName\gfx\event_pictures\ep_$($tag.ToLowerInvariant())\ep_$($tag.ToLowerInvariant())_abatis.dds")
        }
        return $fixtureRoot
    }

    function Set-FixtureEvents {
        param([string]$Root, [string]$Pack = 'testland', [scriptblock]$Change)

        $eventsPath = Join-Path $Root "source\$Pack\events.json"
        $eventSource = Read-EpJson -Path $eventsPath
        & $Change $eventSource
        Write-EpText -Path $eventsPath -Text (ConvertTo-Json -InputObject $eventSource -Depth 10)
    }

    function Get-ErrorMessages {
        param([string]$Root, [string]$Pack = 'testland')

        return @(Test-EpPack -RepoRoot $Root -Pack $Pack | Where-Object { $_.Level -eq 'ERROR' } | ForEach-Object { "$($_.Where): $($_.Message)" })
    }
}

Describe 'Generation' {
    It 'writes the event, anchor, idea, sprite, localisation, Workshop and wiki files from the source' {
        $fixtureRoot = New-EpFixtureRepo
        Invoke-EpGenerate -RepoRoot $fixtureRoot -Pack 'testland' 6>$null | Select-Object -Last 1 | Should -Be 0
        $eventsText = [System.IO.File]::ReadAllText((Join-Path $fixtureRoot 'packs\testland\events\ep_tst_events.txt'))
        $eventsText | Should -Match 'add_namespace = ep_tst'
        $eventsText | Should -Match 'id = ep_tst\.1'
        $eventsText | Should -Match 'picture = GFX_ep_tst_abatis'
        $eventsText | Should -Match 'is_triggered_only = yes'
        $eventsText | Should -Match 'add_war_support = 0\.02'
        $eventsText | Should -Match 'add_stability = -0\.01'
        $eventsText | Should -Match 'add_political_power = 25'
        $eventsText | Should -Match 'add_timed_idea = \{ idea = ep_tst_volunteer_work days = 120 \}'
        $eventsText | Should -Match 'name = ep_tst\.1\.b'
        $anchorText = [System.IO.File]::ReadAllText((Join-Path $fixtureRoot 'packs\testland\common\on_actions\ep_tst_on_actions.txt'))
        $anchorText | Should -Match 'on_weekly_TST = \{'
        $anchorText | Should -Match 'NOT = \{ has_country_flag = ep_tst_fired_1 \}'
        $anchorText | Should -Match 'date > 1937\.5\.1'
        $anchorText | Should -Match 'date < 1937\.9\.1'
        $anchorText | Should -Match 'has_war = no'
        $anchorText | Should -Match '(?s)random = \{\s+chance = 10\s+set_country_flag = ep_tst_fired_1\s+country_event = \{ id = ep_tst\.1 \}'
        [System.IO.File]::ReadAllText((Join-Path $fixtureRoot 'packs\testland\common\ideas\ep_tst_ideas.txt')) | Should -Match '(?s)ep_tst_volunteer_work = \{.*allowed = \{ always = no \}.*war_support_factor = 0\.03'
        [System.IO.File]::ReadAllText((Join-Path $fixtureRoot 'packs\testland\interface\ep_tst_event_pictures.gfx')) | Should -Match 'texturefile = "gfx/event_pictures/ep_tst/ep_tst_abatis\.dds"'
        foreach ($language in (Get-EpLanguages)) {
            $localisationPath = Join-Path $fixtureRoot "packs\testland\localisation\$language\ep_tst_l_$language.yml"
            Test-Path -LiteralPath $localisationPath | Should -BeTrue
            $localisationBytes = [System.IO.File]::ReadAllBytes($localisationPath)
            @($localisationBytes[0], $localisationBytes[1], $localisationBytes[2]) | Should -Be @(0xEF, 0xBB, 0xBF)
            [System.IO.File]::ReadAllText($localisationPath) | Should -Match ("l_" + $language + ":\r\n ep_tst\.1\.t:0 `"Work on the Isthmus Line`"")
        }
        $workshopText = [System.IO.File]::ReadAllText((Join-Path $fixtureRoot 'packs\testland\WORKSHOP_DESCRIPTION_GUIDELINES.md'))
        $workshopText | Should -Match '```bbcode'
        $workshopText | Should -Match '\[\*\]1937: Work on the Isthmus Line'
        $workshopText | Should -Match 'licences that allow their use here \(CC BY 4\.0\)'
        $workshopText | Should -Not -Match 'github\.com'
        $workshopText | Should -Match '(?m)^<!-- cross-links:begin -->\r\n<!-- cross-links:end -->\r\n```'
        $workshopText | Should -Not -Match 'More from the author'
        $wikiText = [System.IO.File]::ReadAllText((Join-Path $fixtureRoot 'wiki\Event-Pack-Testland-1.md'))
        $wikiText | Should -Match '\[CC BY 4\.0\]\(https://creativecommons\.org/licenses/by/4\.0\), Hugo Sundstr.m'
    }

    It 'writes nothing the second time and then finds no error' {
        $fixtureRoot = New-EpFixtureRepo
        Invoke-EpGenerate -RepoRoot $fixtureRoot -Pack 'testland' 6>$null | Out-Null
        $delta = Get-EpGenerationDelta -Pack (Get-EpPack -RepoRoot $fixtureRoot -Pack 'testland')
        $delta.Changed.Count | Should -Be 0
        $delta.Stale.Count | Should -Be 0
        Get-ErrorMessages -Root $fixtureRoot | Should -BeNullOrEmpty
    }

    It 'carries the cross-link block between the markers over when it generates again' {
        $fixtureRoot = New-EpFixtureRepo
        Invoke-EpGenerate -RepoRoot $fixtureRoot -Pack 'testland' 6>$null | Out-Null
        $descriptionPath = Join-Path $fixtureRoot 'packs\testland\WORKSHOP_DESCRIPTION_GUIDELINES.md'
        $emptyText = [System.IO.File]::ReadAllText($descriptionPath)
        $filledText = $emptyText.Replace("<!-- cross-links:begin -->`r`n<!-- cross-links:end -->", "<!-- cross-links:begin -->`r`n[b]More[/b] block line one`r`nblock line two`r`n<!-- cross-links:end -->")
        $filledText | Should -Not -Be $emptyText
        [System.IO.File]::WriteAllText($descriptionPath, $filledText, [System.Text.UTF8Encoding]::new($false))
        $delta = Get-EpGenerationDelta -Pack (Get-EpPack -RepoRoot $fixtureRoot -Pack 'testland')
        $delta.Changed.Count | Should -Be 0
        $delta.Stale.Count | Should -Be 0
        Invoke-EpGenerate -RepoRoot $fixtureRoot -Pack 'testland' 6>$null | Out-Null
        [System.IO.File]::ReadAllText($descriptionPath) | Should -Be $filledText
        Get-ErrorMessages -Root $fixtureRoot | Should -BeNullOrEmpty
    }

    It 'orders the events of the Workshop list by the date their window opens, then by id' {
        $vickers = [PSCustomObject]@{ id = 4; fire = [PSCustomObject]@{ after = '1938.7.1' } }
        $maternity = [PSCustomObject]@{ id = 5; fire = [PSCustomObject]@{ after = '1937.12.1' } }
        $sameDay = [PSCustomObject]@{ id = 3; fire = [PSCustomObject]@{ after = '1938.7.1' } }
        $undated = [PSCustomObject]@{ id = 1 }
        Get-EpEventSortKey -PackEvent $maternity | Should -Be 19371201
        Get-EpEventSortKey -PackEvent $undated | Should -Be ([int]::MaxValue)
        $ordered = @(@($vickers, $maternity, $undated, $sameDay) | Sort-Object { Get-EpEventSortKey -PackEvent $_ }, { [int]$_.id } | ForEach-Object { $_.id })
        $ordered | Should -Be @(5, 3, 4, 1)
    }

    It 'writes the strip regions, no buttons region, and carries what a region holds over when it generates again' {
        $fixtureRoot = New-EpFixtureRepo
        Write-FixtureFile -Root $fixtureRoot -RelativePath 'source\testland\workshop-intro.bbcode' -Text "<!-- region:image:hero -->`r`n<!-- /region -->`r`nFixture intro.`r`n`r`n[h1]Info:[/h1]`r`n<!-- region:info:game-version -->`r`n<!-- /region -->`r`n"
        Invoke-EpGenerate -RepoRoot $fixtureRoot -Pack 'testland' 6>$null | Out-Null
        $descriptionPath = Join-Path $fixtureRoot 'packs\testland\WORKSHOP_DESCRIPTION_GUIDELINES.md'
        $emptyText = [System.IO.File]::ReadAllText($descriptionPath)
        $emptyText | Should -Match '(?m)^<!-- region:image:hero -->\r\n<!-- /region -->\r\nFixture intro\.'
        $emptyText | Should -Match '(?m)^<!-- region:image:strip-events -->\r\n<!-- /region -->\r\n\[h1\]Events\[/h1\]'
        $emptyText | Should -Match '(?m)^<!-- region:image:strip-picture-credits -->\r\n<!-- /region -->\r\n\[h1\]Picture credits\[/h1\]'
        $emptyText | Should -Not -Match 'region:buttons'
        $emptyText | Should -Match '(?m)\r\n\r\n<!-- cross-links:begin -->'
        $filledText = $emptyText.Replace("<!-- region:info:game-version -->`r`n<!-- /region -->", "<!-- region:info:game-version -->`r`n- Built for game version 1.19.`r`n<!-- /region -->")
        $filledText | Should -Not -Be $emptyText
        [System.IO.File]::WriteAllText($descriptionPath, $filledText, [System.Text.UTF8Encoding]::new($false))
        Invoke-EpGenerate -RepoRoot $fixtureRoot -Pack 'testland' 6>$null | Out-Null
        [System.IO.File]::ReadAllText($descriptionPath) | Should -Be $filledText
        $delta = Get-EpGenerationDelta -Pack (Get-EpPack -RepoRoot $fixtureRoot -Pack 'testland')
        $delta.Changed.Count | Should -Be 0
        Get-ErrorMessages -Root $fixtureRoot | Should -BeNullOrEmpty
    }

    It 'finds the cross-link markers with spaces or a tab around them and writes them again without' {
        $fixtureRoot = New-EpFixtureRepo
        Invoke-EpGenerate -RepoRoot $fixtureRoot -Pack 'testland' 6>$null | Out-Null
        $descriptionPath = Join-Path $fixtureRoot 'packs\testland\WORKSHOP_DESCRIPTION_GUIDELINES.md'
        $emptyText = [System.IO.File]::ReadAllText($descriptionPath)
        $paddedText = $emptyText.Replace("<!-- cross-links:begin -->`r`n<!-- cross-links:end -->", "  <!-- cross-links:begin -->  `r`n[b]More[/b] padded block line`r`n`t<!-- cross-links:end -->`t")
        $paddedText | Should -Not -Be $emptyText
        [System.IO.File]::WriteAllText($descriptionPath, $paddedText, [System.Text.UTF8Encoding]::new($false))
        Invoke-EpGenerate -RepoRoot $fixtureRoot -Pack 'testland' 6>$null | Out-Null
        [System.IO.File]::ReadAllText($descriptionPath) | Should -Match '(?m)^<!-- cross-links:begin -->\r\n\[b\]More\[/b\] padded block line\r\n<!-- cross-links:end -->\r\n```'
    }

    It 'reports a generated file edited by hand and a file the source does not generate' {
        $fixtureRoot = New-EpFixtureRepo
        Invoke-EpGenerate -RepoRoot $fixtureRoot -Pack 'testland' 6>$null | Out-Null
        Add-Content -LiteralPath (Join-Path $fixtureRoot 'packs\testland\events\ep_tst_events.txt') -Value '# hand edit'
        Write-FixtureFile -Root $fixtureRoot -RelativePath 'packs\testland\events\stray_events.txt' -Text 'add_namespace = stray'
        $errorMessages = Get-ErrorMessages -Root $fixtureRoot
        @($errorMessages | Where-Object { $_ -like 'packs/testland/events/ep_tst_events.txt: differs*' }).Count | Should -Be 1
        @($errorMessages | Where-Object { $_ -like 'packs/testland/events/stray_events.txt: not generated*' }).Count | Should -Be 1
        Invoke-EpGenerate -RepoRoot $fixtureRoot -Pack 'testland' 6>$null | Out-Null
        Get-ErrorMessages -Root $fixtureRoot | Should -BeNullOrEmpty
    }

    It 'refuses to generate from a source with errors' {
        $fixtureRoot = New-EpFixtureRepo
        Set-FixtureEvents -Root $fixtureRoot -Change { param($eventSource) $eventSource.events[0].options[0].effects[0].war_support = 0.2 }
        Invoke-EpGenerate -RepoRoot $fixtureRoot -Pack 'testland' 6>$null | Select-Object -Last 1 | Should -Be 1
        Test-Path -LiteralPath (Join-Path $fixtureRoot 'packs\testland\events') | Should -BeFalse
    }
}

Describe 'Effect caps' {
    It 'rejects an effect over its cap, an unknown effect, a long timed idea and an unknown modifier' {
        $fixtureRoot = New-EpFixtureRepo
        Set-FixtureEvents -Root $fixtureRoot -Change {
            param($eventSource)
            $eventSource.events[0].options[0].effects[0].war_support = 0.15
            $eventSource.events[0].options[0].effects[1].days = 365
            $eventSource.events[0].options[1].effects = @([PSCustomObject]@{ add_manpower = 1000 })
            $eventSource.ideas[0].modifier = [PSCustomObject]@{ industrial_capacity_dockyard = 0.1 }
        }
        $errorMessages = (Get-ErrorMessages -Root $fixtureRoot) -join "`n"
        $errorMessages | Should -Match 'war_support 0\.15 is over the cap of 0\.1 \[SCR-088\]'
        $errorMessages | Should -Match 'timed idea for 365 days'
        $errorMessages | Should -Match "effect 'add_manpower' is not one of"
        $errorMessages | Should -Match "modifier 'industrial_capacity_dockyard' is not in data/effect-caps.json"
    }

    It 'rejects a timed idea the pack does not define and an idea picture outside the list' {
        $fixtureRoot = New-EpFixtureRepo
        Set-FixtureEvents -Root $fixtureRoot -Change {
            param($eventSource)
            $eventSource.events[0].options[0].effects[1].timed_idea = 'no_such_idea'
            $eventSource.ideas[0].picture = 'some_custom_picture'
        }
        $errorMessages = (Get-ErrorMessages -Root $fixtureRoot) -join "`n"
        $errorMessages | Should -Match "timed_idea 'no_such_idea' is not in the pack's ideas"
        $errorMessages | Should -Match "picture 'some_custom_picture' is not one of"
    }

    It 'writes experience, command power, manpower and popularity effects' {
        $fixtureRoot = New-EpFixtureRepo
        Set-FixtureEvents -Root $fixtureRoot -Change {
            param($eventSource)
            $eventSource.events[0].options[1].effects = @(
                [PSCustomObject]@{ army_experience = 5 },
                [PSCustomObject]@{ command_power = -5 },
                [PSCustomObject]@{ manpower = 1500 },
                [PSCustomObject][ordered]@{ popularity = 0.03; ideology = 'communism' }
            )
        }
        Invoke-EpGenerate -RepoRoot $fixtureRoot -Pack 'testland' 6>$null | Select-Object -Last 1 | Should -Be 0
        Get-ErrorMessages -Root $fixtureRoot | Should -BeNullOrEmpty
        $eventsText = [System.IO.File]::ReadAllText((Join-Path $fixtureRoot 'packs\testland\events\ep_tst_events.txt'))
        $eventsText | Should -Match 'army_experience = 5'
        $eventsText | Should -Match 'add_command_power = -5'
        $eventsText | Should -Match 'add_manpower = 1500'
        $eventsText | Should -Match 'add_popularity = \{ ideology = communism popularity = 0\.03 \}'
    }

    It 'rejects a new effect over its cap, fractional manpower and a popularity without a known ideology' {
        $fixtureRoot = New-EpFixtureRepo
        Set-FixtureEvents -Root $fixtureRoot -Change {
            param($eventSource)
            $eventSource.events[0].options[0].effects = @(
                [PSCustomObject]@{ command_power = 12 },
                [PSCustomObject]@{ manpower = 500.5 },
                [PSCustomObject]@{ popularity = 0.02 }
            )
            $eventSource.events[0].options[1].effects = @(
                [PSCustomObject][ordered]@{ popularity = 0.02; ideology = 'monarchism' },
                [PSCustomObject]@{ ideology = 'fascism' }
            )
        }
        $errorMessages = (Get-ErrorMessages -Root $fixtureRoot) -join "`n"
        $errorMessages | Should -Match 'command_power 12 is over the cap of 10'
        $errorMessages | Should -Not -Match 'command_power 12 is over the cap of 10 \['
        $errorMessages | Should -Match 'manpower 500\.5 is not a whole number'
        $errorMessages | Should -Match 'ep_tst\.1\.a: popularity needs an ideology'
        $errorMessages | Should -Match 'ep_tst\.1\.b: popularity needs an ideology'
        $errorMessages | Should -Match "ideology 'fascism' without popularity"
    }
}

Describe 'Pictures and licences' {
    It 'accepts public domain, CC0 and CC BY files from Commons, with the licence and author' {
        $publicDomain = Get-EpCommonsVerdict -Response (Get-CommonsFixture -Name 'pd')
        $publicDomain.Accepted | Should -BeTrue
        $publicDomain.Picture.licenseCategory | Should -Be 'PD'
        $publicDomain.Picture.author | Should -Be 'Unknown author'
        $publicDomain.Picture.publicDomainReason | Should -Be 'PD-Finland50'
        Get-EpLicenceLabel -Picture $publicDomain.Picture | Should -Be 'Public domain (PD-Finland50)'
        $publicDomain.Picture.pageUrl | Should -Match '^https://commons\.wikimedia\.org/wiki/File:'
        $publicDomain.Picture.downloadUrl | Should -Match '^https://'
        (Get-EpCommonsVerdict -Response (Get-CommonsFixture -Name 'cc0')).Picture.licenseCategory | Should -Be 'CC0'
        $attribution = Get-EpCommonsVerdict -Response (Get-CommonsFixture -Name 'cc-by')
        $attribution.Accepted | Should -BeTrue
        $attribution.Picture.licenseCategory | Should -Be 'CC BY'
        $attribution.Picture.licenseUrl | Should -Be 'https://creativecommons.org/licenses/by/4.0'
    }

    It 'rejects CC BY-SA, a missing file, a file tagged for deletion and a file smaller than the event picture' {
        $shareAlike = Get-EpCommonsVerdict -Response (Get-CommonsFixture -Name 'cc-by-sa')
        $shareAlike.Accepted | Should -BeFalse
        $shareAlike.Reason | Should -Match 'outside the policy'
        (Get-EpCommonsVerdict -Response (Get-CommonsFixture -Name 'missing')).Accepted | Should -BeFalse
        $tagged = Get-CommonsFixture -Name 'pd'
        $tagged.query.pages[0] | Add-Member -NotePropertyName 'templates' -NotePropertyValue @([PSCustomObject]@{ ns = 10; title = 'Template:Delete' }) -Force
        $taggedVerdict = Get-EpCommonsVerdict -Response $tagged
        $taggedVerdict.Accepted | Should -BeFalse
        $taggedVerdict.Reason | Should -Match 'Template:Delete'
        $small = Get-CommonsFixture -Name 'pd'
        $small.query.pages[0].imageinfo[0].width = 200
        (Get-EpCommonsVerdict -Response $small).Reason | Should -Match 'smaller than the 210x176'
        $noReason = Get-CommonsFixture -Name 'pd'
        $noReason.query.pages[0].templates = @($noReason.query.pages[0].templates | Where-Object { $_.title -notmatch '^Template:PD-' })
        (Get-EpCommonsVerdict -Response $noReason).Reason | Should -Match 'without a PD- licence template'
    }

    It 'asks Commons for the licence metadata and the deletion templates in one query' {
        $queryUrl = Get-EpCommonsQueryUrl -FileTitle 'File:Abatis at Taipale.jpg'
        $queryUrl | Should -Match 'titles=File%3AAbatis%20at%20Taipale\.jpg'
        $queryUrl | Should -Match 'iiprop=url%7Csize%7Cmime%7Cextmetadata'
        $queryUrl | Should -Match 'prop=imageinfo%7Ctemplates'
        $queryUrl | Should -Match 'tllimit=max'
    }

    It 'rejects a picture outside the licence policy, a CC BY picture without author, and a missing or wrong-size DDS' {
        $fixtureRoot = New-EpFixtureRepo
        $picturesPath = Join-Path $fixtureRoot 'source\testland\pictures.json'
        $pictureSource = Read-EpJson -Path $picturesPath
        $pictureSource.pictures[0].licenseCategory = 'CC BY-SA'
        Write-EpText -Path $picturesPath -Text (ConvertTo-Json -InputObject $pictureSource -Depth 5)
        ((Get-ErrorMessages -Root $fixtureRoot) -join "`n") | Should -Match 'outside the policy'
        $pictureSource.pictures[0].licenseCategory = 'CC BY'
        $pictureSource.pictures[0].author = ''
        Write-EpText -Path $picturesPath -Text (ConvertTo-Json -InputObject $pictureSource -Depth 5)
        ((Get-ErrorMessages -Root $fixtureRoot) -join "`n") | Should -Match 'CC BY needs a named author'
        $ddsPath = Join-Path $fixtureRoot 'packs\testland\gfx\event_pictures\ep_tst\ep_tst_abatis.dds'
        Write-FixtureDds -Path $ddsPath -Width 450 -Height 240
        ((Get-ErrorMessages -Root $fixtureRoot) -join "`n") | Should -Match 'not 210x176'
        Remove-Item -LiteralPath $ddsPath
        ((Get-ErrorMessages -Root $fixtureRoot) -join "`n") | Should -Match 'no DDS in the pack'
    }

    It 'accepts a vanilla event picture without a manifest entry' {
        $fixtureRoot = New-EpFixtureRepo
        Set-FixtureEvents -Root $fixtureRoot -Change { param($eventSource) $eventSource.events[0].picture = 'vanilla:GFX_report_event_generic_read_write' }
        Remove-Item -LiteralPath (Join-Path $fixtureRoot 'packs\testland\gfx') -Recurse
        Invoke-EpGenerate -RepoRoot $fixtureRoot -Pack 'testland' 6>$null | Out-Null
        [System.IO.File]::ReadAllText((Join-Path $fixtureRoot 'packs\testland\events\ep_tst_events.txt')) | Should -Match 'picture = GFX_report_event_generic_read_write'
        @(Get-ErrorMessages -Root $fixtureRoot) | Should -BeNullOrEmpty
    }
}

Describe 'The licence record cannot be bent by hand' {
    BeforeAll {
        function Set-FixturePicture {
            param([string]$Root, [scriptblock]$Change)

            $picturesPath = Join-Path $Root 'source\testland\pictures.json'
            $pictureSource = Read-EpJson -Path $picturesPath
            & $Change $pictureSource.pictures[0]
            Write-EpText -Path $picturesPath -Text (ConvertTo-Json -InputObject $pictureSource -Depth 5)
        }
    }

    It 'rejects CC BY without a named author on Commons' {
        $unnamed = Get-CommonsFixture -Name 'cc-by'
        $unnamed.query.pages[0].imageinfo[0].extmetadata.Artist.value = 'Unknown author'
        (Get-EpCommonsVerdict -Response $unnamed).Reason | Should -Match 'without a named author'
        $unnamed.query.pages[0].imageinfo[0].extmetadata.Artist.value = ''
        (Get-EpCommonsVerdict -Response $unnamed).Accepted | Should -BeFalse
    }

    It 'rejects a file that is not a picture, and a download URL off the Wikimedia servers' {
        $document = Get-CommonsFixture -Name 'pd'
        $document.query.pages[0].imageinfo[0].mime = 'application/pdf'
        (Get-EpCommonsVerdict -Response $document).Reason | Should -Match 'not a picture'
        $elsewhere = Get-CommonsFixture -Name 'pd'
        $elsewhere.query.pages[0].imageinfo[0].thumburl = 'https://example.com/abatis.jpg'
        (Get-EpCommonsVerdict -Response $elsewhere).Reason | Should -Match 'not on Wikimedia'
    }

    It 'rejects a category that does not match the Commons licence code' {
        $fixtureRoot = New-EpFixtureRepo
        Set-FixturePicture -Root $fixtureRoot -Change { param($picture) $picture.license = 'cc-by-sa-4.0' }
        ((Get-ErrorMessages -Root $fixtureRoot) -join "`n") | Should -Match 'does not match its Commons code'
    }

    It 'rejects public domain without a PD- template reason in the record' {
        $fixtureRoot = New-EpFixtureRepo
        Set-FixturePicture -Root $fixtureRoot -Change { param($picture) $picture.license = 'pd'; $picture.licenseCategory = 'PD'; $picture.publicDomainReason = 'trust me' }
        ((Get-ErrorMessages -Root $fixtureRoot) -join "`n") | Should -Match 'public domain without the reason'
    }

    It 'rejects pages and downloads off Commons, and a record without its hash or fetch date' {
        $fixtureRoot = New-EpFixtureRepo
        Set-FixturePicture -Root $fixtureRoot -Change { param($picture) $picture.pageUrl = 'https://example.com/page'; $picture.downloadUrl = 'https://example.com/a.jpg'; $picture.downloadSha256 = ''; $picture.fetched = '' }
        $errorMessages = (Get-ErrorMessages -Root $fixtureRoot) -join "`n"
        $errorMessages | Should -Match 'not a Wikimedia Commons file page'
        $errorMessages | Should -Match 'not on Wikimedia'
        $errorMessages | Should -Match 'no downloadSha256'
        $errorMessages | Should -Match 'no fetched'
    }

    It 'rejects a cached download whose hash differs from the record' {
        $fixtureRoot = New-EpFixtureRepo
        $packData = Get-EpPack -RepoRoot $fixtureRoot -Pack 'testland'
        Write-FixtureFile -Root $fixtureRoot -RelativePath ((Get-EpCacheFilePath -Pack $packData -Picture $packData.Pictures[0]).Substring($packData.RepoRoot.Length + 1)) -Text 'other bytes'
        ((Get-ErrorMessages -Root $fixtureRoot) -join "`n") | Should -Match 'does not match the SHA-256'
    }

    It 'warns about public domain that holds only in the United States' {
        $fixtureRoot = New-EpFixtureRepo
        Set-FixturePicture -Root $fixtureRoot -Change { param($picture) $picture.license = 'pd'; $picture.licenseCategory = 'PD'; $picture.publicDomainReason = 'PD-US-expired' }
        @(Test-EpPack -RepoRoot $fixtureRoot -Pack 'testland' | Where-Object { $_.Level -eq 'WARN' -and $_.Message -match 'United States only' }).Count | Should -Be 1
    }

    It 'keeps the crop and tone of a picture fetched again without them' {
        $fixtureRoot = New-EpFixtureRepo
        Set-FixturePicture -Root $fixtureRoot -Change { param($picture) $picture.crop = '30'; $picture.tone = 'warm' }
        Mock Invoke-RestMethod { Get-CommonsFixture -Name 'cc-by' }
        Mock Invoke-WebRequest { [System.IO.File]::WriteAllText($OutFile, 'picture bytes') }
        Invoke-EpFetchPicture -RepoRoot $fixtureRoot -Pack 'testland' -File 'File:Calling of reservists 1939 (Numeroimaton; JOKAHBL3B J06-1).tif' -Key 'abatis' 6>$null | Select-Object -Last 1 | Should -Be 0
        $picture = (Get-EpPack -RepoRoot $fixtureRoot -Pack 'testland').Pictures[0]
        $picture.crop | Should -Be '30'
        $picture.tone | Should -Be 'warm'
        $picture.downloadSha256 | Should -Be ((Get-FileHash -LiteralPath (Get-EpCacheFilePath -Pack (Get-EpPack -RepoRoot $fixtureRoot -Pack 'testland') -Picture $picture) -Algorithm SHA256).Hash.ToLowerInvariant())
    }

    It 'reuses a finished download of the same URL instead of downloading it again' {
        $fixtureRoot = New-EpFixtureRepo
        $script:DownloadCount = 0
        Mock Invoke-RestMethod { Get-CommonsFixture -Name 'cc-by' }
        Mock Invoke-WebRequest { $script:DownloadCount++; [System.IO.File]::WriteAllText($OutFile, 'picture bytes') }
        Invoke-EpFetchPicture -RepoRoot $fixtureRoot -Pack 'testland' -File 'x.jpg' -Key 'zulu' 6>$null | Select-Object -Last 1 | Should -Be 0
        Invoke-EpFetchPicture -RepoRoot $fixtureRoot -Pack 'testland' -File 'x.jpg' -Key 'zulu' -Crop '20' 6>$null | Select-Object -Last 1 | Should -Be 0
        $script:DownloadCount | Should -Be 1
        $packData = Get-EpPack -RepoRoot $fixtureRoot -Pack 'testland'
        $picture = Get-EpPictureByKey -Pack $packData -PictureKey 'zulu'
        $picture.crop | Should -Be '20'
        $cachePath = Get-EpCacheFilePath -Pack $packData -Picture $picture
        $picture.downloadSha256 | Should -Be ((Get-FileHash -LiteralPath $cachePath -Algorithm SHA256).Hash.ToLowerInvariant())
        Test-Path -LiteralPath (Get-EpCacheSourcePath -CachePath $cachePath) | Should -BeTrue
        @(Get-ChildItem -LiteralPath $packData.CacheDir -Filter 'zulu.*' -File).Count | Should -Be 1 -Because "the thumbnail spec names a background as sources-cache/<pack>/<key>.* and needs exactly one match"
        Invoke-EpRemovePicture -RepoRoot $fixtureRoot -Pack 'testland' -Key 'zulu' 6>$null | Select-Object -Last 1 | Should -Be 0
        Test-Path -LiteralPath (Get-EpCacheSourcePath -CachePath $cachePath) | Should -BeFalse
    }

    It 'downloads again when the cached download is older than the reuse window' {
        $fixtureRoot = New-EpFixtureRepo
        $script:DownloadCount = 0
        Mock Invoke-RestMethod { Get-CommonsFixture -Name 'cc-by' }
        Mock Invoke-WebRequest { $script:DownloadCount++; [System.IO.File]::WriteAllText($OutFile, 'picture bytes') }
        Invoke-EpFetchPicture -RepoRoot $fixtureRoot -Pack 'testland' -File 'x.jpg' -Key 'zulu' 6>$null | Out-Null
        $packData = Get-EpPack -RepoRoot $fixtureRoot -Pack 'testland'
        $sourcePath = Get-EpCacheSourcePath -CachePath (Get-EpCacheFilePath -Pack $packData -Picture (Get-EpPictureByKey -Pack $packData -PictureKey 'zulu'))
        $cacheSource = [System.IO.File]::ReadAllText($sourcePath) | ConvertFrom-Json
        $cacheSource.downloaded = (Get-Date).AddDays(-10).ToString('yyyy-MM-dd')
        [System.IO.File]::WriteAllText($sourcePath, ($cacheSource | ConvertTo-Json))
        Invoke-EpFetchPicture -RepoRoot $fixtureRoot -Pack 'testland' -File 'x.jpg' -Key 'zulu' 6>$null | Out-Null
        $script:DownloadCount | Should -Be 1 -Because 'a 10-day-old download is inside the window'
        ([System.IO.File]::ReadAllText($sourcePath) | ConvertFrom-Json).downloaded | Should -Be $cacheSource.downloaded -Because 'a reuse must not date the download anew'
        $cacheSource.downloaded = (Get-Date).AddDays(-30).ToString('yyyy-MM-dd')
        [System.IO.File]::WriteAllText($sourcePath, ($cacheSource | ConvertTo-Json))
        Invoke-EpFetchPicture -RepoRoot $fixtureRoot -Pack 'testland' -File 'x.jpg' -Key 'zulu' 6>$null | Out-Null
        $script:DownloadCount | Should -Be 2
    }

    It 'downloads again when the cached file has no sidecar, other bytes than its sidecar, or another URL' {
        $fixtureRoot = New-EpFixtureRepo
        $script:DownloadCount = 0
        Mock Invoke-RestMethod { Get-CommonsFixture -Name 'cc-by' }
        Mock Invoke-WebRequest { $script:DownloadCount++; [System.IO.File]::WriteAllText($OutFile, 'picture bytes') }
        Invoke-EpFetchPicture -RepoRoot $fixtureRoot -Pack 'testland' -File 'x.jpg' -Key 'zulu' 6>$null | Out-Null
        $packData = Get-EpPack -RepoRoot $fixtureRoot -Pack 'testland'
        $cachePath = Get-EpCacheFilePath -Pack $packData -Picture (Get-EpPictureByKey -Pack $packData -PictureKey 'zulu')
        [System.IO.File]::WriteAllText($cachePath, 'cut off')
        Invoke-EpFetchPicture -RepoRoot $fixtureRoot -Pack 'testland' -File 'x.jpg' -Key 'zulu' 6>$null | Out-Null
        $script:DownloadCount | Should -Be 2
        $sourcePath = Get-EpCacheSourcePath -CachePath $cachePath
        Remove-Item -LiteralPath $sourcePath
        Invoke-EpFetchPicture -RepoRoot $fixtureRoot -Pack 'testland' -File 'x.jpg' -Key 'zulu' 6>$null | Out-Null
        $script:DownloadCount | Should -Be 3
        [System.IO.File]::WriteAllText($sourcePath, (@{ downloadUrl = 'https://upload.wikimedia.org/other.jpg'; downloadSha256 = (Get-FileHash -LiteralPath $cachePath -Algorithm SHA256).Hash; downloaded = (Get-Date).ToString('yyyy-MM-dd') } | ConvertTo-Json))
        Invoke-EpFetchPicture -RepoRoot $fixtureRoot -Pack 'testland' -File 'x.jpg' -Key 'zulu' 6>$null | Out-Null
        $script:DownloadCount | Should -Be 4
    }

    It 'leaves the cached file and its sidecar as they were when a download fails' {
        $fixtureRoot = New-EpFixtureRepo
        Mock Start-Sleep { }
        Mock Invoke-RestMethod { Get-CommonsFixture -Name 'cc-by' }
        Mock Invoke-WebRequest { [System.IO.File]::WriteAllText($OutFile, 'picture bytes') }
        Invoke-EpFetchPicture -RepoRoot $fixtureRoot -Pack 'testland' -File 'x.jpg' -Key 'zulu' 6>$null | Out-Null
        $packData = Get-EpPack -RepoRoot $fixtureRoot -Pack 'testland'
        $cachePath = Get-EpCacheFilePath -Pack $packData -Picture (Get-EpPictureByKey -Pack $packData -PictureKey 'zulu')
        [System.IO.File]::WriteAllText($cachePath, 'other bytes')
        Mock Invoke-WebRequest { [System.IO.File]::WriteAllText($OutFile, 'cut'); throw 'connection reset' }
        { Invoke-EpFetchPicture -RepoRoot $fixtureRoot -Pack 'testland' -File 'x.jpg' -Key 'zulu' 6>$null } | Should -Throw
        [System.IO.File]::ReadAllText($cachePath) | Should -Be 'other bytes'
        @(Get-ChildItem -LiteralPath $packData.CacheDir -Filter 'zulu.*' -File).Count | Should -Be 1
    }

    It 'waits and tries again when Wikimedia answers 429 or 503, as long as Retry-After asks' {
        $fixtureRoot = New-EpFixtureRepo
        $script:DownloadAttempts = 0
        Mock Start-Sleep { }
        Mock Invoke-RestMethod { Get-CommonsFixture -Name 'cc-by' }
        Mock Invoke-WebRequest {
            $script:DownloadAttempts++
            if ($script:DownloadAttempts -le 2) {
                $statusCode = if ($script:DownloadAttempts -eq 1) { 429 } else { 503 }
                $exception = [System.Exception]::new('Too many requests')
                Add-Member -InputObject $exception -NotePropertyName Response -NotePropertyValue ([PSCustomObject]@{ StatusCode = $statusCode; Headers = @{ 'Retry-After' = '30' } })
                throw $exception
            }
            [System.IO.File]::WriteAllText($OutFile, 'picture bytes')
        }
        Invoke-EpFetchPicture -RepoRoot $fixtureRoot -Pack 'testland' -File 'x.jpg' -Key 'zulu' 6>$null | Select-Object -Last 1 | Should -Be 0
        $script:DownloadAttempts | Should -Be 3
        Should -Invoke Start-Sleep -Times 2 -Exactly -ParameterFilter { $Seconds -eq 30 }
        Get-EpPictureByKey -Pack (Get-EpPack -RepoRoot $fixtureRoot -Pack 'testland') -PictureKey 'zulu' | Should -Not -BeNullOrEmpty
    }

    It 'gives up after the last attempt with Wikimedia''s message and never retries another failure' {
        Mock Start-Sleep { }
        Mock Invoke-RestMethod {
            $exception = [System.Exception]::new('Too many requests')
            Add-Member -InputObject $exception -NotePropertyName Response -NotePropertyValue ([PSCustomObject]@{ StatusCode = 429; Headers = @{} })
            $errorRecord = [System.Management.Automation.ErrorRecord]::new($exception, 'WebCmdletWebResponseException', 'InvalidOperation', $null)
            $errorRecord.ErrorDetails = [System.Management.Automation.ErrorDetails]::new("<html><body><p>Too many requests -</p>`n<p>use thumbnail steps</p></body></html>")
            throw $errorRecord
        }
        $script:RequestOutput = [System.Collections.Generic.List[string]]::new()
        { Invoke-EpCommonsRequest -Uri 'https://commons.wikimedia.org/w/api.php' -MaxAttempts 3 6>&1 | ForEach-Object { $script:RequestOutput.Add([string]$_) } } | Should -Throw
        Should -Invoke Invoke-RestMethod -Times 3 -Exactly
        @($script:RequestOutput | Where-Object { $_ -eq '  Wikimedia answered 429: Too many requests - use thumbnail steps' }).Count | Should -Be 3
        $script:RequestOutput[-1] | Should -Be '  giving up after 3 attempts'
        Should -Invoke Start-Sleep -Times 1 -Exactly -ParameterFilter { $Seconds -eq 5 }
        Should -Invoke Start-Sleep -Times 1 -Exactly -ParameterFilter { $Seconds -eq 10 }
        Mock Invoke-RestMethod { throw 'not found' }
        { Invoke-EpCommonsRequest -Uri 'https://commons.wikimedia.org/w/api.php' 6>$null } | Should -Throw 'not found'
        Should -Invoke Start-Sleep -Times 2 -Exactly
    }
}

Describe 'Facts are quoted from their page' {
    It 'accepts a fact line with its source and the quote of its page' {
        $fixtureRoot = New-EpFixtureRepo
        @(Get-ErrorMessages -Root $fixtureRoot | Where-Object { $_ -match 'fact sheet' }) | Should -BeNullOrEmpty
    }

    It 'rejects a fact line without a quote, and one without a source' {
        $fixtureRoot = New-EpFixtureRepo
        Set-FixtureFactSheet -Root $fixtureRoot -FactLines @((Get-FixtureFactLine), (Get-FixtureFactLine -WithoutQuote), '- The army supplied the tools. Quote: <<no source>>')
        $factErrors = @(Get-ErrorMessages -Root $fixtureRoot | Where-Object { $_ -match 'without its source and the quote' })
        $factErrors.Count | Should -Be 2
        $factErrors[0] | Should -Match 'Volunteers dug on the Karelian Isthmus'
    }

    It 'exempts the events below factQuotesFromId, and only those' {
        $fixtureRoot = New-EpFixtureRepo
        Set-FixtureFactSheet -Root $fixtureRoot -FactLines @(Get-FixtureFactLine -WithoutQuote)
        Set-FixtureEvents -Root $fixtureRoot -Change { param($eventSource) $eventSource | Add-Member -NotePropertyName 'factQuotesFromId' -NotePropertyValue 2 }
        @(Get-ErrorMessages -Root $fixtureRoot | Where-Object { $_ -match 'fact sheet' }) | Should -BeNullOrEmpty
        Set-FixtureEvents -Root $fixtureRoot -Change { param($eventSource) $eventSource.factQuotesFromId = 1 }
        @(Get-ErrorMessages -Root $fixtureRoot | Where-Object { $_ -match 'without its source and the quote' }).Count | Should -Be 1
    }

    It 'rejects an UNVERIFIED fact in a fact sheet, also in an exempt event' {
        $fixtureRoot = New-EpFixtureRepo
        Set-FixtureFactSheet -Root $fixtureRoot -FactLines @((Get-FixtureFactLine), '- The work went on until the autumn rain. UNVERIFIED')
        Set-FixtureEvents -Root $fixtureRoot -Change { param($eventSource) $eventSource | Add-Member -NotePropertyName 'factQuotesFromId' -NotePropertyValue 5 }
        ((Get-ErrorMessages -Root $fixtureRoot) -join "`n") | Should -Match 'holds an UNVERIFIED fact.*autumn rain'
        Set-FixtureFactSheet -Root $fixtureRoot -FactLines @((Get-FixtureFactLine), '- The army supplied the tools. UNVERIFIED (no page found)')
        ((Get-ErrorMessages -Root $fixtureRoot) -join "`n") | Should -Match 'holds an UNVERIFIED fact.*supplied the tools'
    }

    It 'rejects a covered section written as prose, without fact lines' {
        $fixtureRoot = New-EpFixtureRepo
        Set-FixtureFactSheet -Root $fixtureRoot -FactLines @('Volunteers dug on the Karelian Isthmus in 1937. Source: https://example.org/isthmus')
        ((Get-ErrorMessages -Root $fixtureRoot) -join "`n") | Should -Match 'has no fact lines'
    }

    It 'rejects a factQuotesFromId that is not a whole number from 1' {
        $fixtureRoot = New-EpFixtureRepo
        foreach ($badValue in @(0, 'later', 2.5)) {
            Set-FixtureEvents -Root $fixtureRoot -Change { param($eventSource) $eventSource | Add-Member -NotePropertyName 'factQuotesFromId' -NotePropertyValue $badValue -Force }
            ((Get-ErrorMessages -Root $fixtureRoot) -join "`n") | Should -Match 'factQuotesFromId .* must be a whole number from 1'
        }
    }

    It 'warns in the audit about the events that predate quoted facts' {
        $fixtureRoot = New-EpFixtureRepo
        Set-FixtureFactSheet -Root $fixtureRoot -FactLines @(Get-FixtureFactLine -WithoutQuote)
        Set-FixtureEvents -Root $fixtureRoot -Change { param($eventSource) $eventSource | Add-Member -NotePropertyName 'factQuotesFromId' -NotePropertyValue 2 }
        Invoke-EpGenerate -RepoRoot $fixtureRoot -Pack 'testland' 6>$null | Out-Null
        $auditText = @(Invoke-EpAudit -RepoRoot $fixtureRoot -Pack 'testland' 6>&1 | ForEach-Object { [string]$_ }) -join "`n"
        $auditText | Should -Match '\[WARN\].*the facts of events 1 predate quoted facts \(factQuotesFromId 2\)'
    }

    It 'writes the quoted fact format into the fact sheet of a new pack' {
        $fixtureRoot = New-EpFixtureRepo
        Invoke-EpNewPack -RepoRoot $fixtureRoot -Pack 'newland' -Tag 'NWL' -DisplayName 'Newland' 6>$null | Out-Null
        $factSheetText = [System.IO.File]::ReadAllText((Join-Path $fixtureRoot 'source\newland\fact-sheets.md'), [System.Text.Encoding]::UTF8)
        $factSheetText | Should -Match ('Quote: ' + [char]0x00AB)
    }

    It 'renders the thumbnail of a new pack with the Manager thumbnail tool' {
        $fixtureRoot = New-EpFixtureRepo
        $fakeManagerRoot = Join-Path $TestDrive ([guid]::NewGuid().ToString('N').Substring(0, 8))
        Write-FixtureFile -Root $fakeManagerRoot -RelativePath 'Scripts\Showcase\New-HoiThumbnail.ps1' -Text ("param([string]`$Path, [string]`$Pack, [switch]`$Apply, [switch]`$PassThru)`r`n[System.IO.File]::WriteAllText((Join-Path `$Path ('packs\' + `$Pack + '\thumbnail.png')), ('rendered apply=' + `$Apply + ' passthru=' + `$PassThru))`r`n")
        function Get-ModManagerRoot { return $fakeManagerRoot }
        $newPackOutput = @(Invoke-EpNewPack -RepoRoot $fixtureRoot -Pack 'newland' -Tag 'NWL' -DisplayName 'Newland' 6>&1 | ForEach-Object { [string]$_ }) -join "`n"
        [System.IO.File]::ReadAllText((Join-Path $fixtureRoot 'packs\newland\thumbnail.png')) | Should -BeExactly 'rendered apply=True passthru=True'
        $newPackOutput | Should -Match 'Rendered packs\\newland\\thumbnail\.png'
        $newPackOutput | Should -Not -Match 'mod-thumbnail-generator'
    }

    It 'falls back to the master thumbnail and names the command when the thumbnail tool <Case>' -TestCases @(
        @{ Case = 'is not found'; FakeScript = $null; Problem = 'the Modding Manager was not found' },
        @{ Case = 'fails'; FakeScript = "Write-Output 'New-HoiThumbnail.ps1: no game install was found'`r`nexit 1`r`n"; Problem = 'New-HoiThumbnail.ps1: no game install was found' }
    ) {
        param($Case, $FakeScript, $Problem)
        $fixtureRoot = New-EpFixtureRepo
        New-Item -ItemType Directory -Path (Join-Path $fixtureRoot 'assets') -Force | Out-Null
        [System.IO.File]::WriteAllBytes((Join-Path $fixtureRoot 'assets\thumbnail_master.png'), [byte[]](1, 2, 3))
        $fakeManagerRoot = $null
        if ($FakeScript) {
            $fakeManagerRoot = Join-Path $TestDrive ([guid]::NewGuid().ToString('N').Substring(0, 8))
            Write-FixtureFile -Root $fakeManagerRoot -RelativePath 'Scripts\Showcase\New-HoiThumbnail.ps1' -Text $FakeScript
        }
        function Get-ModManagerRoot { return $fakeManagerRoot }
        $newPackOutput = @(Invoke-EpNewPack -RepoRoot $fixtureRoot -Pack 'newland' -Tag 'NWL' -DisplayName 'Newland' 6>&1 | ForEach-Object { [string]$_ }) -join "`n"
        [System.IO.File]::ReadAllBytes((Join-Path $fixtureRoot 'packs\newland\thumbnail.png')) | Should -Be ([byte[]](1, 2, 3))
        $newPackOutput | Should -Match ([regex]::Escape("No thumbnail rendered: $Problem."))
        $newPackOutput | Should -Match ('New-HoiThumbnail\.ps1" -Path "' + [regex]::Escape($fixtureRoot) + '" -Pack newland -Apply')
    }

    It 'adds only the new pack entry to hand-written build settings' {
        $fixtureRoot = New-EpFixtureRepo
        $settingsPath = Join-Path $fixtureRoot 'tools\HoiModBuild.json'
        $originalLines = @('{', '    "packages": {', '        "testland": {', '            "root": "packs/testland",', '            "modFolderName": "event_pack_testland"', '        }', '    },', '    "testSuites": {', '        "Documentation": ["build.ps1", ".claude/skills/**", "AGENTS.md"],', '        "none": ["assets/**", "research/**"]', '    }', '}')
        Write-FixtureFile -Root $fixtureRoot -RelativePath 'tools\HoiModBuild.json' -Text (($originalLines -join "`r`n") + "`r`n")
        Invoke-EpNewPack -RepoRoot $fixtureRoot -Pack 'newland' -Tag 'NWL' -DisplayName 'Newland' 6>$null | Out-Null
        $settingsText = [System.IO.File]::ReadAllText($settingsPath, [System.Text.Encoding]::UTF8)
        $expectedLines = @($originalLines[0..4]) + @('        },', '        "newland": {', '            "root": "packs/newland",', '            "modFolderName": "event_pack_newland"', '        }') + @($originalLines[6..11])
        $settingsText | Should -BeExactly (($expectedLines -join "`r`n") + "`r`n")
        $settings = $settingsText | ConvertFrom-Json
        $original = ($originalLines -join "`r`n") | ConvertFrom-Json
        ConvertTo-Json -InputObject $settings.testSuites -Compress | Should -BeExactly (ConvertTo-Json -InputObject $original.testSuites -Compress)
        ConvertTo-Json -InputObject $settings.packages.testland -Compress | Should -BeExactly (ConvertTo-Json -InputObject $original.packages.testland -Compress)
        $settings.packages.newland.root | Should -BeExactly 'packs/newland'
        $settings.packages.newland.modFolderName | Should -BeExactly 'event_pack_newland'
    }

    It 'follows the indent of the build settings and refuses a packages key that is not at the top level' {
        $twoSpaceText = "{`n  `"packages`": {`n    `"testland`": {`n      `"root`": `"packs/testland`"`n    }`n  }`n}`n"
        $expectedText = "{`n  `"packages`": {`n    `"testland`": {`n      `"root`": `"packs/testland`"`n    },`n    `"newland`": {`n      `"root`": `"packs/newland`",`n      `"modFolderName`": `"event_pack_newland`"`n    }`n  }`n}`n"
        Add-EpPackageSettingText -Text $twoSpaceText -Pack 'newland' | Should -BeExactly $expectedText
        { Add-EpPackageSettingText -Text '{ "other": { "packages": {} } }' -Pack 'newland' } | Should -Throw '*top-level packages object*'
    }

    It 'writes the packages object in the hand-written layout when the build settings have <Case>' -TestCases @(
        @{ Case = 'no packages'; Original = "{`r`n    `"testSuites`": {`r`n        `"none`": [`"research/**`"]`r`n    }`r`n}`r`n"; Prefix = @('{', '    "testSuites": {', '        "none": ["research/**"]', '    },') },
        @{ Case = 'no file'; Original = $null; Prefix = @('{') }
    ) {
        param($Case, $Original, $Prefix)
        $fixtureRoot = New-EpFixtureRepo
        $settingsPath = Join-Path $fixtureRoot 'tools\HoiModBuild.json'
        if ($null -eq $Original) {
            Remove-Item -LiteralPath $settingsPath
        } else {
            Write-FixtureFile -Root $fixtureRoot -RelativePath 'tools\HoiModBuild.json' -Text $Original
        }
        Invoke-EpNewPack -RepoRoot $fixtureRoot -Pack 'newland' -Tag 'NWL' -DisplayName 'Newland' 6>$null | Out-Null
        $expectedLines = @($Prefix) + @('    "packages": {', '        "newland": {', '            "root": "packs/newland",', '            "modFolderName": "event_pack_newland"', '        }', '    }', '}')
        [System.IO.File]::ReadAllText($settingsPath, [System.Text.Encoding]::UTF8) | Should -BeExactly (($expectedLines -join "`r`n") + "`r`n")
    }
}

Describe 'Own work on an old picture' {
    It 'rejects own work on a 1936 press photograph, dated only in its description' {
        $ownWork = Get-EpCommonsVerdict -Response (Get-CommonsFixture -Name 'pd-self-old')
        $ownWork.Accepted | Should -BeFalse
        $ownWork.Reason | Should -Match 'own work on a picture dated 1936'
    }

    It 'accepts own work on a recent picture, and an old public domain picture that is not own work' {
        $recent = Get-CommonsFixture -Name 'pd-self-old'
        $recent.query.pages[0].imageinfo[0].extmetadata.ImageDescription.value = 'The treaty memorial in Paris, photographed in 1985.'
        (Get-EpCommonsVerdict -Response $recent).Accepted | Should -BeTrue
        $oldPublicDomain = Get-EpCommonsVerdict -Response (Get-CommonsFixture -Name 'pd')
        $oldPublicDomain.Accepted | Should -BeTrue
        $oldPublicDomain.Picture.dateOriginal | Should -Match '1939'
    }

    It 'takes the earliest year of the date, name, description and title, so a scan date does not hide the picture''s own' {
        $scanned = Get-CommonsFixture -Name 'pd-self-old'
        $scanned.query.pages[0].imageinfo[0].extmetadata | Add-Member -NotePropertyName 'DateTimeOriginal' -NotePropertyValue ([PSCustomObject]@{ value = '2007-06-01' }) -Force
        (Get-EpCommonsVerdict -Response $scanned).Reason | Should -Match 'dated 1936'
        Get-EpPictureYear -Texts @('2018-10-28', 'Magazine page of 1937', '') | Should -Be 1937
        Get-EpPictureYear -Texts @('', 'no year here') | Should -BeNullOrEmpty
    }

    It 'rejects a recorded own-work row dated before 1960 that an event uses, and warns when the record has no date' {
        $fixtureRoot = New-EpFixtureRepo
        $picturesPath = Join-Path $fixtureRoot 'source\testland\pictures.json'
        $pictureSource = Read-EpJson -Path $picturesPath
        $pictureSource.pictures[0].license = 'pd'
        $pictureSource.pictures[0].licenseCategory = 'PD'
        $pictureSource.pictures[0].publicDomainReason = 'PD-self'
        $pictureSource.pictures[0].dateOriginal = '1937'
        Write-EpText -Path $picturesPath -Text (ConvertTo-Json -InputObject $pictureSource -Depth 5)
        ((Get-ErrorMessages -Root $fixtureRoot) -join "`n") | Should -Match 'own work on a picture dated 1937'
        $pictureSource.pictures[0].dateOriginal = ''
        $pictureSource.pictures[0] | Add-Member -NotePropertyName 'pictureYear' -NotePropertyValue $null -Force
        $pictureSource.pictures[0].commonsTitle = 'File:Reservists.tif'
        Write-EpText -Path $picturesPath -Text (ConvertTo-Json -InputObject $pictureSource -Depth 5)
        @(Test-EpPack -RepoRoot $fixtureRoot -Pack 'testland' | Where-Object { $_.Level -eq 'WARN' -and $_.Message -match 'own work without a date' }).Count | Should -Be 1
        ((Get-ErrorMessages -Root $fixtureRoot) -join "`n") | Should -Not -Match 'own work'
    }

    It 'leaves an unused own-work row to the unused-picture warning' {
        $fixtureRoot = New-EpFixtureRepo
        Set-FixtureEvents -Root $fixtureRoot -Change { param($eventSource) $eventSource.events[0].picture = 'vanilla:GFX_report_event_generic_read_write' }
        $picturesPath = Join-Path $fixtureRoot 'source\testland\pictures.json'
        $pictureSource = Read-EpJson -Path $picturesPath
        $pictureSource.pictures[0].credit = 'Own work'
        $pictureSource.pictures[0].dateOriginal = '1936'
        Write-EpText -Path $picturesPath -Text (ConvertTo-Json -InputObject $pictureSource -Depth 5)
        $pictureProblems = @(Test-EpPack -RepoRoot $fixtureRoot -Pack 'testland' | Where-Object { $_.Where -eq 'picture abatis' })
        @($pictureProblems | Where-Object { $_.Message -match 'own work' }) | Should -BeNullOrEmpty
        @($pictureProblems | Where-Object { $_.Message -eq 'no event uses this picture' }).Count | Should -Be 1
    }
}

Describe 'Removing a picture row' {
    BeforeAll {
        function Add-FixtureSparePicture {
            param([string]$Root)

            $picturesPath = Join-Path $Root 'source\testland\pictures.json'
            $pictureSource = Read-EpJson -Path $picturesPath
            $sparePicture = $pictureSource.pictures[0].PSObject.Copy()
            $sparePicture.key = 'spare'
            $pictureSource.pictures = @($pictureSource.pictures[0], $sparePicture)
            Write-EpText -Path $picturesPath -Text (ConvertTo-Json -InputObject $pictureSource -Depth 5)
            $packData = Get-EpPack -RepoRoot $Root -Pack 'testland'
            $cachePath = Get-EpCacheFilePath -Pack $packData -Picture (Get-EpPictureByKey -Pack $packData -PictureKey 'spare')
            Write-FixtureFile -Root $Root -RelativePath $cachePath.Substring($packData.RepoRoot.Length + 1) -Text 'spare bytes'
            return $cachePath
        }
    }

    It 'removes an unused row, its cached download and a stale DDS, and a dry run removes nothing' {
        $fixtureRoot = New-EpFixtureRepo
        $cachePath = Add-FixtureSparePicture -Root $fixtureRoot
        $staleDdsPath = Join-Path $fixtureRoot 'packs\testland\gfx\event_pictures\ep_tst\ep_tst_spare.dds'
        Write-FixtureDds -Path $staleDdsPath
        Invoke-EpRemovePicture -RepoRoot $fixtureRoot -Pack 'testland' -Key 'spare' -DryRun 6>$null | Select-Object -Last 1 | Should -Be 0
        @((Get-EpPack -RepoRoot $fixtureRoot -Pack 'testland').Pictures).Count | Should -Be 2
        Test-Path -LiteralPath $cachePath | Should -BeTrue
        Test-Path -LiteralPath $staleDdsPath | Should -BeTrue
        Invoke-EpRemovePicture -RepoRoot $fixtureRoot -Pack 'testland' -Key 'spare' 6>$null | Select-Object -Last 1 | Should -Be 0
        @((Get-EpPack -RepoRoot $fixtureRoot -Pack 'testland').Pictures | ForEach-Object { $_.key }) | Should -Be @('abatis')
        Test-Path -LiteralPath $cachePath | Should -BeFalse
        Test-Path -LiteralPath $staleDdsPath | Should -BeFalse
    }

    It 'refuses a picture an event uses, and a key that is not recorded' {
        $fixtureRoot = New-EpFixtureRepo
        Invoke-EpRemovePicture -RepoRoot $fixtureRoot -Pack 'testland' -Key 'abatis' 6>$null | Select-Object -Last 1 | Should -Be 1
        Invoke-EpRemovePicture -RepoRoot $fixtureRoot -Pack 'testland' -Key 'nothing_here' 6>$null | Select-Object -Last 1 | Should -Be 1
        @((Get-EpPack -RepoRoot $fixtureRoot -Pack 'testland').Pictures).Count | Should -Be 1
    }
}

Describe 'Nothing ships unchecked' {
    It 'rejects a file in a pack that is neither generated nor a picture of the manifest' {
        $fixtureRoot = New-EpFixtureRepo
        Invoke-EpGenerate -RepoRoot $fixtureRoot -Pack 'testland' 6>$null | Out-Null
        Write-FixtureDds -Path (Join-Path $fixtureRoot 'packs\testland\gfx\event_pictures\ep_tst\ep_tst_stray.dds')
        Write-FixtureFile -Root $fixtureRoot -RelativePath 'packs\testland\sound\stray.wav' -Text 'x'
        $errorMessages = (Get-ErrorMessages -Root $fixtureRoot) -join "`n"
        $errorMessages | Should -Match 'packs/testland/gfx/event_pictures/ep_tst/ep_tst_stray\.dds: is not generated'
        $errorMessages | Should -Match 'packs/testland/sound/stray\.wav: is not generated'
    }

    It 'accepts only country event pictures from the base game' {
        $fixtureRoot = New-EpFixtureRepo
        Set-FixtureEvents -Root $fixtureRoot -Change { param($eventSource) $eventSource.events[0].picture = 'vanilla:GFX_news_event_generic_read_write' }
        ((Get-ErrorMessages -Root $fixtureRoot) -join "`n") | Should -Match 'not a vanilla event picture sprite'
    }
}

Describe 'Packs stand alone' {
    It 'generates two packs side by side without a shared name' {
        $fixtureRoot = New-EpFixtureRepo -Packs @('testland', 'otherland')
        foreach ($packName in @('testland', 'otherland')) {
            Invoke-EpGenerate -RepoRoot $fixtureRoot -Pack $packName 6>$null | Out-Null
        }
        Get-ErrorMessages -Root $fixtureRoot -Pack 'testland' | Should -BeNullOrEmpty
        Get-ErrorMessages -Root $fixtureRoot -Pack 'otherland' | Should -BeNullOrEmpty
        Test-Path -LiteralPath (Join-Path $fixtureRoot 'packs\otherland\events\ep_tsu_events.txt') | Should -BeTrue
    }

    It "rejects a trigger that names another pack's flags, and a namespace two packs share" {
        $fixtureRoot = New-EpFixtureRepo -Packs @('testland', 'otherland')
        Set-FixtureEvents -Root $fixtureRoot -Pack 'otherland' -Change { param($eventSource) $eventSource.events[0].fire.trigger = 'has_country_flag = ep_tst_fired_1' }
        ((Get-ErrorMessages -Root $fixtureRoot -Pack 'otherland') -join "`n") | Should -Match "names 'ep_tst' of another pack"
        Set-FixtureEvents -Root $fixtureRoot -Pack 'otherland' -Change { param($eventSource) $eventSource.namespace = 'ep_tst'; $eventSource.events[0].fire.trigger = '' }
        ((Get-ErrorMessages -Root $fixtureRoot -Pack 'otherland') -join "`n") | Should -Match 'is used by another pack'
    }
}

Describe 'The test mod' {
    It 'fires every event of every pack to its country and writes nothing into the packs' {
        $fixtureRoot = New-EpFixtureRepo -Packs @('testland', 'otherland')
        Set-FixtureEvents -Root $fixtureRoot -Change { param($eventSource) $secondEvent = Get-FixtureEvent; $secondEvent.id = 2; $eventSource.events = @($eventSource.events) + $secondEvent }
        $launcherDir = Join-Path $fixtureRoot 'launcher'
        $packsRoot = Join-Path $fixtureRoot 'packs'
        $packFilesBefore = @(Get-ChildItem -LiteralPath $packsRoot -Recurse -File | ForEach-Object { $_.FullName + ' ' + (Get-FileHash -LiteralPath $_.FullName).Hash })
        Invoke-EpTestMod -RepoRoot $fixtureRoot -Pack @('testland') -ModDir $launcherDir -DryRun 6>$null | Select-Object -Last 1 | Should -Be 0
        Test-Path -LiteralPath (Join-Path $fixtureRoot 'artifacts') | Should -BeFalse
        Test-Path -LiteralPath $launcherDir | Should -BeFalse
        Invoke-EpTestMod -RepoRoot $fixtureRoot -Pack @('testland', 'otherland') -ModDir $launcherDir 6>$null | Select-Object -Last 1 | Should -Be 0
        @(Get-ChildItem -LiteralPath $packsRoot -Recurse -File | ForEach-Object { $_.FullName + ' ' + (Get-FileHash -LiteralPath $_.FullName).Hash }) | Should -Be $packFilesBefore
        $effectsText = [System.IO.File]::ReadAllText((Join-Path $fixtureRoot 'artifacts\event_packs_test\common\scripted_effects\ep_test_effects.txt'))
        $effectsText | Should -Match '(?s)d_ep_tst_all = \{\s+TST = \{\s+set_country_flag = ep_tst_fired_1\s+country_event = \{ id = ep_tst\.1 \}\s+set_country_flag = ep_tst_fired_2\s+country_event = \{ id = ep_tst\.2 \}\s+\}\s+\}'
        $effectsText | Should -Match '(?s)d_ep_tst_reset = \{\s+TST = \{\s+clr_country_flag = ep_tst_fired_1\s+clr_country_flag = ep_tst_fired_2\s+\}\s+\}'
        $effectsText | Should -Match '(?s)d_ep_tsu_all = \{\s+TSU = \{\s+set_country_flag = ep_tsu_fired_1\s+country_event = \{ id = ep_tsu\.1 \}\s+\}\s+\}'
        [System.IO.File]::ReadAllText((Join-Path $launcherDir 'event_packs_test.mod')) | Should -Match ('path="' + [regex]::Escape($fixtureRoot.Replace('\', '/')) + '/artifacts/event_packs_test"')
        [System.IO.File]::ReadAllText((Join-Path $fixtureRoot 'artifacts\event_packs_test\descriptor.mod')) | Should -Not -Match 'path='
    }

    It 'sets the same guard flags and fires the same events as the weekly anchor' {
        $fixtureRoot = New-EpFixtureRepo
        Set-FixtureEvents -Root $fixtureRoot -Change { param($eventSource) $secondEvent = Get-FixtureEvent; $secondEvent.id = 2; $eventSource.events = @($eventSource.events) + $secondEvent }
        $testPack = Get-EpPack -RepoRoot $fixtureRoot -Pack 'testland'
        $anchorLines = @((New-EpOnActionsText -Pack $testPack) -split "`r`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ -match '^(set_country_flag|country_event) ' })
        $anchorLines.Count | Should -Be 4
        $allLines = @(([regex]::Match((New-EpTestEffectsText -Packs @($testPack)), '(?s)d_ep_tst_all = \{.*?\r\n\}').Value -split "`r`n") | ForEach-Object { $_.Trim() } | Where-Object { $_ -match '^(set_country_flag|country_event) ' })
        $allLines | Should -Be $anchorLines
    }
}

Describe 'Event renders for the Workshop page' {
    BeforeAll {
        $script:PythonExecutable = Get-EpPythonExecutable

        function Invoke-EventRenderer {
            param([string]$SourceDir, [string]$PackDir, [string]$OutputDir)

            $rendererOutput = @(& $script:PythonExecutable -I (Join-Path $script:RepoRoot 'tools\render_event_cards.py') --pack finland --source-dir $SourceDir --pack-dir $PackDir --out $OutputDir 2>&1 | ForEach-Object { "$_" })
            return [PSCustomObject]@{ ExitCode = $LASTEXITCODE; Text = ($rendererOutput -join "`n") }
        }
    }

    It 'reads an uncompressed 32-bit DDS in one step, to the pixels Pillow decodes, with and without alpha' {
        if (-not $script:PythonExecutable) { Set-ItResult -Skipped -Because 'Python 3 with Pillow is not installed'; return }
        $probe = @'
import os, struct, sys
sys.path.insert(0, sys.argv[1])
import render_event_cards
from PIL import Image
for flags, alpha_mask in ((0x41, 0xFF000000), (0x40, 0)):
    width, height = 5, 3
    pixels = b"".join(bytes(((x * 40) % 256, (y * 70) % 256, (200 - x * 30) % 256, (x * 50 + 10) % 256)) for y in range(height) for x in range(width))
    header = struct.pack("<4s7I44x8I5I", b"DDS ", 124, 0x100F, height, width, width * 4, 0, 0, 32, flags, 0, 32, 0xFF0000, 0xFF00, 0xFF, alpha_mask, 0x1000, 0, 0, 0, 0)
    path = os.path.join(sys.argv[2], "probe_%x.dds" % flags)
    with open(path, "wb") as handle:
        handle.write(header + pixels)
    ours = render_event_cards.open_image(path)
    same = ours.convert("RGBA").tobytes() == Image.open(path).convert("RGBA").tobytes()
    print("%x fast=%s same=%s" % (flags, ours.format is None, same))
'@
        $probePath = Join-Path $TestDrive 'dds_probe.py'
        [System.IO.File]::WriteAllText($probePath, $probe, [System.Text.UTF8Encoding]::new($false))
        $probeOutput = @(& $script:PythonExecutable -I -B $probePath (Join-Path $script:RepoRoot 'tools') $TestDrive 2>&1 | ForEach-Object { "$_" })
        $probeOutput | Should -Be @('41 fast=True same=True', '40 fast=True same=True') -Because ($probeOutput -join "`n")
    }

    It 'draws one 16:9 image per event of a pack, all of one size, with the window at 1:1, and an overview' {
        if (-not $script:PythonExecutable) { Set-ItResult -Skipped -Because 'Python 3 with Pillow is not installed'; return }
        $outputDir = Join-Path $TestDrive 'renders'
        $result = Invoke-EventRenderer -SourceDir (Join-Path $script:RepoRoot 'source\finland') -PackDir (Join-Path $script:RepoRoot 'packs\finland') -OutputDir $outputDir
        if ($result.Text -match 'no Hearts of Iron IV install found') { Set-ItResult -Skipped -Because 'the game is not installed here'; return }
        $result.ExitCode | Should -Be 0 -Because $result.Text
        $eventCount = @(([System.IO.File]::ReadAllText((Join-Path $script:RepoRoot 'source\finland\events.json'), [System.Text.Encoding]::UTF8) | ConvertFrom-Json).events).Count
        $allFiles = @(Get-ChildItem -LiteralPath $outputDir -File | Where-Object { $_.Extension -in @('.png', '.jpg') -and $_.BaseName -ne 'contact-sheet-NOT-FOR-WORKSHOP' } | Sort-Object Name)
        $allFiles[0].BaseName | Should -Be '00-overview'
        $renderFiles = @($allFiles | Select-Object -Skip 1)
        $renderFiles.Count | Should -Be $eventCount
        $renderFiles[0].Name | Should -Match '^01-[a-z0-9_]+\.(png|jpg)$'
        Add-Type -AssemblyName System.Drawing
        $overviewImage = [System.Drawing.Image]::FromFile($allFiles[0].FullName)
        try { '{0}x{1}' -f $overviewImage.Width, $overviewImage.Height | Should -Be '1600x900' } finally { $overviewImage.Dispose() }
        $result.Text | Should -Match '00-overview: 7 events on a pile'
        $imageSizes = @(foreach ($renderFile in $renderFiles) {
            $renderImage = [System.Drawing.Image]::FromFile($renderFile.FullName)
            try { '{0}x{1}' -f $renderImage.Width, $renderImage.Height } finally { $renderImage.Dispose() }
        })
        @($imageSizes | Sort-Object -Unique).Count | Should -Be 1
        $width, $height = @($imageSizes[0] -split 'x' | ForEach-Object { [int]$_ })
        $width | Should -Be ([math]::Round($height * 16 / 9))
        $width | Should -BeGreaterThan 581
        $result.Text | Should -Match "Rendered $eventCount events to"
    }

    It 'writes one contact sheet of every event next to the renders, under a name that no Workshop upload takes for an event image' {
        if (-not $script:PythonExecutable) { Set-ItResult -Skipped -Because 'Python 3 with Pillow is not installed'; return }
        $probe = @'
import sys
sys.path.insert(0, sys.argv[1])
import render_event_cards as cards
from PIL import Image
colours = [(220, 40, 40), (40, 200, 60), (50, 70, 230), (230, 210, 40), (200, 60, 200), (40, 210, 210), (240, 140, 30)]
windows = [Image.new("RGBA", (485, 300 + 40 * i), colours[i] + (255,)) for i in range(7)]
labels = ["%02d-ep_probe_%d" % (i + 1, i) for i in range(7)]
sheet = cards.contact_sheet(list(zip(labels, windows)))
print("size %dx%d columns %d mode %s" % (sheet.width, sheet.height, cards.SHEET_COLUMNS, sheet.mode))
cell = cards.SHEET_CELL_WIDTH
drawn = 0
for i, colour in enumerate(colours):
    column = i % cards.SHEET_COLUMNS
    x0 = cards.SHEET_MARGIN + column * (cell + cards.SHEET_GAP)
    data = sheet.crop((x0, 0, x0 + cell, sheet.height)).convert("RGB").tobytes()
    pixels = list(zip(data[0::3], data[1::3], data[2::3]))
    near = sum(1 for p in pixels if all(abs(a - b) < 12 for a, b in zip(p, colour)))
    drawn += 1 if near > cell * cell // 2 else 0
print("cards drawn %d" % drawn)
label_top = cards.SHEET_MARGIN + cards.SHEET_FONT_SIZE + 8 + cards.SHEET_GAP
data = sheet.crop((cards.SHEET_MARGIN, label_top, cards.SHEET_MARGIN + cell, label_top + cards.SHEET_FONT_SIZE + 8)).convert("RGB").tobytes()
light = sum(1 for p in zip(data[0::3], data[1::3], data[2::3]) if min(p) > 200 and max(p) - min(p) < 20)
print("label pixels %s" % (light > 40))
single = cards.contact_sheet([(labels[0], windows[0])])
print("single %s" % (single.width < sheet.width and single.height < sheet.height))
'@
        $probePath = Join-Path $TestDrive 'sheet_probe.py'
        [System.IO.File]::WriteAllText($probePath, $probe, [System.Text.UTF8Encoding]::new($false))
        $probeOutput = @(& $script:PythonExecutable -I -B $probePath (Join-Path $script:RepoRoot 'tools') 2>&1 | ForEach-Object { "$_" })
        $probeOutput.Count | Should -Be 4 -Because ($probeOutput -join "`n")
        $sheetSize = [regex]::Match($probeOutput[0], '^size (\d+)x(\d+) columns 5 mode RGB$')
        $sheetSize.Success | Should -BeTrue -Because ($probeOutput -join "`n")
        [int]$sheetSize.Groups[1].Value | Should -BeLessThan 1568
        $probeOutput[1] | Should -Be 'cards drawn 7'
        $probeOutput[2] | Should -Be 'label pixels True'
        $probeOutput[3] | Should -Be 'single True'
        $outputDir = Join-Path $TestDrive 'sheet-renders'
        $result = Invoke-EventRenderer -SourceDir (Join-Path $script:RepoRoot 'source\finland') -PackDir (Join-Path $script:RepoRoot 'packs\finland') -OutputDir $outputDir
        if ($result.Text -match 'no Hearts of Iron IV install found') { Set-ItResult -Skipped -Because 'the game is not installed here'; return }
        $result.ExitCode | Should -Be 0 -Because $result.Text
        $eventCount = @(([System.IO.File]::ReadAllText((Join-Path $script:RepoRoot 'source\finland\events.json'), [System.Text.Encoding]::UTF8) | ConvertFrom-Json).events).Count
        $result.Text | Should -Match "contact-sheet-NOT-FOR-WORKSHOP: $eventCount events"
        $sheetFiles = @(Get-ChildItem -LiteralPath $outputDir -File | Where-Object { $_.BaseName -eq 'contact-sheet-NOT-FOR-WORKSHOP' })
        $sheetFiles.Count | Should -Be 1
        $sheetFiles[0].Length | Should -BeLessThan (1024 * 1024)
        @(Get-ChildItem -LiteralPath $outputDir -File | Where-Object { $_.BaseName -match '^\d\d-' }).Count | Should -Be ($eventCount + 1)
    }

    It 'warns of a title or option that overflows its box, and fails on a missing picture' {
        if (-not $script:PythonExecutable) { Set-ItResult -Skipped -Because 'Python 3 with Pillow is not installed'; return }
        $sourceDir = Join-Path $TestDrive 'source\finland'
        $packDir = Join-Path $TestDrive 'packs\finland'
        $eventSource = [System.IO.File]::ReadAllText((Join-Path $script:RepoRoot 'source\finland\events.json'), [System.Text.Encoding]::UTF8) | ConvertFrom-Json
        $eventSource.events = @($eventSource.events[0])
        Write-EpText -Path (Join-Path $sourceDir 'events.json') -Text (ConvertTo-Json -InputObject $eventSource -Depth 8)
        Copy-Item -LiteralPath (Join-Path $script:RepoRoot 'packs\finland') -Destination $packDir -Recurse
        $localisationPath = Join-Path $packDir 'localisation\english\ep_fin_l_english.yml'
        $localisationText = [System.IO.File]::ReadAllText($localisationPath, [System.Text.Encoding]::UTF8)
        $longTitle = 'Three Finns Take Gold, Silver and Bronze in the 10,000 Metres Final at the Berlin Olympic Games'
        $longOption = 'Meet the whole team at the harbour in Helsinki when the ship brings them home from Germany, with the band, the flags, the ministers and every sports club of the capital'
        $localisationText = [regex]::Replace($localisationText, '(?m)^ ep_fin\.1\.t:0 ".*"', " ep_fin.1.t:0 `"$longTitle`"")
        $localisationText = [regex]::Replace($localisationText, '(?m)^ ep_fin\.1\.a:0 ".*"', " ep_fin.1.a:0 `"$longOption`"")
        Write-EpText -Path $localisationPath -Text $localisationText -Bom
        $result = Invoke-EventRenderer -SourceDir $sourceDir -PackDir $packDir -OutputDir (Join-Path $TestDrive 'long-title')
        if ($result.Text -match 'no Hearts of Iron IV install found') { Set-ItResult -Skipped -Because 'the game is not installed here'; return }
        $result.ExitCode | Should -Be 0 -Because $result.Text
        $result.Text | Should -Match '\[WARN\] ep_fin\.1: title is \d+ px wide, over its 551 px box; it wraps to 2 lines'
        $result.Text | Should -Match '\[WARN\] ep_fin\.1: option 1 is \d+ px wide; it wraps to \d lines at 340 px'
        Remove-Item -LiteralPath (Join-Path $packDir ('gfx\event_pictures\ep_fin\ep_fin_' + $eventSource.events[0].picture + '.dds'))
        $result = Invoke-EventRenderer -SourceDir $sourceDir -PackDir $packDir -OutputDir (Join-Path $TestDrive 'no-picture')
        $result.ExitCode | Should -Be 1
        $result.Text | Should -Match '\[ERROR\] ep_fin\.1: picture GFX_ep_fin_\w+ not found'
    }

    It "draws the country's flag in the game's flag frame at the top right of the cards and the overview" {
        if (-not $script:PythonExecutable) { Set-ItResult -Skipped -Because 'Python 3 with Pillow is not installed'; return }
        $outputDir = Join-Path $TestDrive 'flag-renders'
        $result = Invoke-EventRenderer -SourceDir (Join-Path $script:RepoRoot 'source\finland') -PackDir (Join-Path $script:RepoRoot 'packs\finland') -OutputDir $outputDir
        if ($result.Text -match 'no Hearts of Iron IV install found') { Set-ItResult -Skipped -Because 'the game is not installed here'; return }
        $result.ExitCode | Should -Be 0 -Because $result.Text
        $result.Text | Should -Not -Match '\[WARN\] flag'
        $probe = @'
import glob, os, sys
sys.path.insert(0, sys.argv[1])
import render_event_cards as cards
from PIL import Image, ImageChops, ImageStat
game_dir = cards.find_game_dir()
flag = Image.open(os.path.join(game_dir, "gfx", "flags", "FIN_neutrality.tga")).convert("RGB")
for path in sorted(glob.glob(os.path.join(sys.argv[2], "*.*"))):
    if os.path.basename(path).startswith("contact-sheet"):
        continue
    image = Image.open(path).convert("RGB")
    frame_left = image.width - 24 - 92
    left = frame_left + 5
    top = 24 + 2
    region = image.crop((left + 6, top + 6, left + flag.width - 6, top + flag.height - 6))
    inner = flag.crop((6, 6, flag.width - 6, flag.height - 6))
    drift = max(ImageStat.Stat(ImageChops.difference(region, inner)).mean)
    border = image.crop((frame_left + 10, 24 + 2, frame_left + 80, 24 + 3))
    border_drift = max(ImageStat.Stat(ImageChops.difference(border, flag.crop((5, 0, 75, 1)))).mean)
    drawn = drift <= (6 if path.lower().endswith(".jpg") else 0) and border_drift > 20
    print("%s %s" % (os.path.basename(path), "flag" if drawn else "no-flag"))
'@
        $probePath = Join-Path $TestDrive 'flag_probe.py'
        [System.IO.File]::WriteAllText($probePath, $probe, [System.Text.UTF8Encoding]::new($false))
        $probeOutput = @(& $script:PythonExecutable -I -B $probePath (Join-Path $script:RepoRoot 'tools') $outputDir 2>&1 | ForEach-Object { "$_" })
        $probeOutput.Count | Should -BeGreaterThan 1 -Because ($probeOutput -join "`n")
        @($probeOutput | Where-Object { $_ -notmatch ' flag$' }) | Should -Be @() -Because ($probeOutput -join "`n")
        @($probeOutput | Where-Object { $_ -match '^00-overview\.' }).Count | Should -Be 1
    }

    It 'picks the flag of the ruling party in the undated set_politics, else the plain tag flag' {
        if (-not $script:PythonExecutable) { Set-ItResult -Skipped -Because 'Python 3 with Pillow is not installed'; return }
        $fixtureGame = Join-Path $TestDrive 'flag-game'
        $historyText = @'
1939.1.1 = {
	set_politics = {
		ruling_party = fascism
	}
}
# ruling_party = communism
set_politics = {
	ruling_party = democratic # x
	last_election = "1931.3.2"
}
'@
        Write-EpText -Path (Join-Path $fixtureGame 'history\countries\AAA - Aland.txt') -Text $historyText
        Write-EpText -Path (Join-Path $fixtureGame 'history\countries\BBB - Bland.txt') -Text 'capital = 1'
        Write-EpText -Path (Join-Path $fixtureGame 'history\countries\CCC - Cland.txt') -Text "set_politics = {`n`truling_party = neutrality`n}"
        New-Item -ItemType Directory -Path (Join-Path $fixtureGame 'gfx\flags') -Force | Out-Null
        $probe = @'
import os, sys
sys.path.insert(0, sys.argv[1])
import render_event_cards as cards
from PIL import Image
flags = os.path.join(sys.argv[2], "gfx", "flags")
for name in ("AAA_democratic", "AAA_fascism", "BBB", "CCC"):
    Image.new("RGBA", (82, 52), (255, 0, 0, 255)).save(os.path.join(flags, name + ".tga"))
for tag in ("AAA", "BBB", "CCC", "DDD"):
    found = cards.find_flag(sys.argv[2], tag)
    print("%s %s %s" % (tag, cards.ruling_party(sys.argv[2], tag), os.path.basename(found) if found else None))
'@
        $probePath = Join-Path $TestDrive 'party_probe.py'
        [System.IO.File]::WriteAllText($probePath, $probe, [System.Text.UTF8Encoding]::new($false))
        $probeOutput = @(& $script:PythonExecutable -I -B $probePath (Join-Path $script:RepoRoot 'tools') $fixtureGame 2>&1 | ForEach-Object { "$_" })
        $probeOutput | Should -Be @('AAA democratic AAA_democratic.tga', 'BBB None BBB.tga', 'CCC neutrality CCC.tga', 'DDD None None') -Because ($probeOutput -join "`n")
    }

    It 'warns of a pack without a tag or with a tag that has no flag file, and still renders' {
        if (-not $script:PythonExecutable) { Set-ItResult -Skipped -Because 'Python 3 with Pillow is not installed'; return }
        $packDir = Join-Path $TestDrive 'flagless\packs\finland'
        Copy-Item -LiteralPath (Join-Path $script:RepoRoot 'packs\finland') -Destination $packDir -Recurse
        $eventSource = [System.IO.File]::ReadAllText((Join-Path $script:RepoRoot 'source\finland\events.json'), [System.Text.Encoding]::UTF8) | ConvertFrom-Json
        $eventSource.events = @($eventSource.events[0])
        $untaggedDir = Join-Path $TestDrive 'flagless\untagged'
        $eventSource.PSObject.Properties.Remove('tag')
        Write-EpText -Path (Join-Path $untaggedDir 'events.json') -Text (ConvertTo-Json -InputObject $eventSource -Depth 8)
        $result = Invoke-EventRenderer -SourceDir $untaggedDir -PackDir $packDir -OutputDir (Join-Path $TestDrive 'flagless\untagged-out')
        if ($result.Text -match 'no Hearts of Iron IV install found') { Set-ItResult -Skipped -Because 'the game is not installed here'; return }
        $result.ExitCode | Should -Be 0 -Because $result.Text
        $result.Text | Should -Match '\[WARN\] flag: events\.json has no tag'
        @(Get-ChildItem -LiteralPath (Join-Path $TestDrive 'flagless\untagged-out') -File).Count | Should -Be 3
        $unknownDir = Join-Path $TestDrive 'flagless\unknown'
        $eventSource | Add-Member -NotePropertyName 'tag' -NotePropertyValue 'QQQ'
        Write-EpText -Path (Join-Path $unknownDir 'events.json') -Text (ConvertTo-Json -InputObject $eventSource -Depth 8)
        $result = Invoke-EventRenderer -SourceDir $unknownDir -PackDir $packDir -OutputDir (Join-Path $TestDrive 'flagless\unknown-out')
        $result.ExitCode | Should -Be 0 -Because $result.Text
        $result.Text | Should -Match '\[WARN\] flag: no flag file for QQQ'
        @(Get-ChildItem -LiteralPath (Join-Path $TestDrive 'flagless\unknown-out') -File).Count | Should -Be 3
    }
}

Describe 'Bundle' {
    BeforeAll {
        function New-EpBundleFixtureRepo {
            $fixtureRoot = New-EpFixtureRepo -Packs @('testland', 'otherland')
            $packageSettings = [ordered]@{
                all       = [PSCustomObject]@{ root = 'packs/all'; modFolderName = 'immersive_events_expanded'; members = @('testland', 'otherland') }
                testland  = [PSCustomObject]@{ root = 'packs/testland'; modFolderName = 'event_pack_testland' }
                otherland = [PSCustomObject]@{ root = 'packs/otherland'; modFolderName = 'event_pack_otherland' }
            }
            Write-FixtureFile -Root $fixtureRoot -RelativePath 'tools\HoiModBuild.json' -Text (ConvertTo-Json -InputObject ([PSCustomObject]@{ packages = [PSCustomObject]$packageSettings }) -Depth 5)
            foreach ($packName in @('testland', 'otherland', 'all')) {
                $packTitle = if ($packName -eq 'all') { 'Immersive Events Expanded' } else { 'Event Pack: ' + $packName }
                Write-FixtureFile -Root $fixtureRoot -RelativePath "packs\$packName\descriptor.mod" -Text ("version=`"1.0`"`r`nname=`"$packTitle`"`r`npicture=`"thumbnail.png`"`r`nsupported_version=`"1.19.*`"`r`n")
            }
            Write-FixtureFile -Root $fixtureRoot -RelativePath 'packs\all\thumbnail.png' -Text 'png'
            Write-FixtureFile -Root $fixtureRoot -RelativePath 'source\all\workshop-intro.bbcode' -Text "<!-- region:image:hero -->`r`n<!-- /region -->`r`nHistorical flavor events for Testland 1 and Testland 2 in one item.`r`n"
            return $fixtureRoot
        }

        function Get-BundleErrors {
            param([string]$Root)

            return @(Test-EpBundle -RepoRoot $Root -Bundle 'all' | Where-Object { $_.Level -eq 'ERROR' } | ForEach-Object { "$($_.Where): $($_.Message)" })
        }
    }

    It 'keeps the bundle out of the pack names, and finds the bundle that holds a member' {
        $fixtureRoot = New-EpBundleFixtureRepo
        @(Get-EpPackNames -RepoRoot $fixtureRoot) | Should -Be @('testland', 'otherland')
        @(Get-EpBundleNames -RepoRoot $fixtureRoot) | Should -Be @('all')
        @(Get-EpBundleNames -RepoRoot $fixtureRoot -Member 'otherland') | Should -Be @('all')
        @(Get-EpBundleNames -RepoRoot $fixtureRoot -Member 'elsewhere').Count | Should -Be 0
    }

    It 'writes the bundle page: the intro, a country list with the event counts, and the link markers' {
        $fixtureRoot = New-EpBundleFixtureRepo
        Invoke-EpGenerate -RepoRoot $fixtureRoot -Pack 'all' 6>$null | Select-Object -Last 1 | Should -Be 0
        $pageText = [System.IO.File]::ReadAllText((Join-Path $fixtureRoot 'packs\all\WORKSHOP_DESCRIPTION_GUIDELINES.md'), [System.Text.Encoding]::UTF8)
        $pageText | Should -Match '(?m)^# Immersive Events Expanded - Workshop description'
        $pageText | Should -Match 'Historical flavor events for Testland 1 and Testland 2 in one item\.'
        $pageText | Should -Match '\[\*\]Testland 1: 1 event\r?\n\[\*\]Testland 2: 1 event'
        $pageText | Should -Match '<!-- region:image:strip-countries -->'
        $pageText | Should -Match '<!-- cross-links:begin -->\r?\n<!-- cross-links:end -->'
        $pageText | Should -Not -Match ('[' + [char]0x2014 + [char]0x2013 + [char]0x2026 + ']')
        Get-BundleErrors -Root $fixtureRoot | Should -BeNullOrEmpty
    }

    It 'writes the bundle page again when a member pack is generated, and keeps what the Manager wrote in it' {
        $fixtureRoot = New-EpBundleFixtureRepo
        Invoke-EpGenerate -RepoRoot $fixtureRoot -Pack 'all' 6>$null | Out-Null
        $pagePath = Join-Path $fixtureRoot 'packs\all\WORKSHOP_DESCRIPTION_GUIDELINES.md'
        $carriedText = ([System.IO.File]::ReadAllText($pagePath, [System.Text.Encoding]::UTF8)).Replace("<!-- cross-links:begin -->`r`n<!-- cross-links:end -->", "<!-- cross-links:begin -->`r`n[b]More from the author[/b]`r`n<!-- cross-links:end -->")
        Write-EpText -Path $pagePath -Text $carriedText
        Invoke-EpGenerate -RepoRoot $fixtureRoot -Pack 'testland' 6>$null | Select-Object -Last 1 | Should -Be 0
        [System.IO.File]::ReadAllText($pagePath, [System.Text.Encoding]::UTF8) | Should -Match '\[b\]More from the author\[/b\]'
        Remove-Item -LiteralPath $pagePath
        Invoke-EpGenerate -RepoRoot $fixtureRoot -Pack 'otherland' 6>$null | Select-Object -Last 1 | Should -Be 0
        Test-Path -LiteralPath $pagePath | Should -BeTrue
    }

    It 'passes the check of a bundle that is in step, and checks it with the packs it holds' {
        $fixtureRoot = New-EpBundleFixtureRepo
        Invoke-EpGenerate -RepoRoot $fixtureRoot -Pack 'all' 6>$null | Out-Null
        Get-BundleErrors -Root $fixtureRoot | Should -BeNullOrEmpty
        $checkOutput = @(Invoke-EpCheck -RepoRoot $fixtureRoot -Pack 'testland' 6>&1 | ForEach-Object { [string]$_ })
        ($checkOutput -join "`n") | Should -Match "Bundle 'all': 2 member"
    }

    It 'prints each pack''s problems under that pack''s line, not under the line before it' {
        $fixtureRoot = New-EpBundleFixtureRepo
        Invoke-EpGenerate -RepoRoot $fixtureRoot -Pack 'all' 6>$null | Out-Null
        $picturesPath = Join-Path $fixtureRoot 'source\testland\pictures.json'
        $pictureSource = Read-EpJson -Path $picturesPath
        $pictureSource.pictures[0].license = 'pd'; $pictureSource.pictures[0].licenseCategory = 'PD'; $pictureSource.pictures[0].publicDomainReason = 'PD-US-expired'
        Write-EpText -Path $picturesPath -Text (ConvertTo-Json -InputObject $pictureSource -Depth 5)
        $checkOutput = @(Invoke-EpCheck -RepoRoot $fixtureRoot 6>&1 | ForEach-Object { [string]$_ })
        $warningIndex = [array]::FindIndex([string[]]$checkOutput, [Predicate[string]] { param($line) $line -match 'United States only' })
        $warningIndex | Should -BeGreaterThan -1
        $packLineIndex = [array]::FindLastIndex([string[]]$checkOutput, $warningIndex, [Predicate[string]] { param($line) $line -match "^(Pack|Bundle) '" })
        $checkOutput[$packLineIndex] | Should -Match "^Pack 'testland'" -Because 'a warning belongs to the pack line printed above it'
    }

    It 'returns a failing exit code from the check for a bundle error, and 0 without one' {
        $fixtureRoot = New-EpBundleFixtureRepo
        Invoke-EpGenerate -RepoRoot $fixtureRoot -Pack 'all' 6>$null | Out-Null
        Invoke-EpCheck -RepoRoot $fixtureRoot -Pack 'all' 6>$null | Select-Object -Last 1 | Should -Be 0
        $settings = Read-EpJson -Path (Join-Path $fixtureRoot 'tools\HoiModBuild.json')
        $settings.packages.all.members = @('testland')
        Write-EpText -Path (Join-Path $fixtureRoot 'tools\HoiModBuild.json') -Text (ConvertTo-Json -InputObject $settings -Depth 6)
        Invoke-EpCheck -RepoRoot $fixtureRoot -Pack 'all' 6>$null | Select-Object -Last 1 | Should -Be 1
    }

    It 'fails the check when a pack is not a member of the bundle' {
        $fixtureRoot = New-EpBundleFixtureRepo
        Invoke-EpGenerate -RepoRoot $fixtureRoot -Pack 'all' 6>$null | Out-Null
        $settings = Read-EpJson -Path (Join-Path $fixtureRoot 'tools\HoiModBuild.json')
        $settings.packages.all.members = @('testland')
        Write-EpText -Path (Join-Path $fixtureRoot 'tools\HoiModBuild.json') -Text (ConvertTo-Json -InputObject $settings -Depth 6)
        Get-BundleErrors -Root $fixtureRoot | Should -Contain "tools/HoiModBuild.json: pack 'otherland' is not a member of bundle 'all': add it to the members list, or its release would leave it out of the bundle"
    }

    It 'lists a member that is not a pack as a problem instead of stopping' {
        $fixtureRoot = New-EpBundleFixtureRepo
        $settings = Read-EpJson -Path (Join-Path $fixtureRoot 'tools\HoiModBuild.json')
        $settings.packages.all.members = @('testland', 'otherland', 'ghostland')
        Write-EpText -Path (Join-Path $fixtureRoot 'tools\HoiModBuild.json') -Text (ConvertTo-Json -InputObject $settings -Depth 6)
        @(Get-BundleErrors -Root $fixtureRoot | Where-Object { $_ -like "*member 'ghostland' of bundle 'all' is not an event pack*" }).Count | Should -Be 1
    }

    It 'fails the check for an intro that does not name a member' {
        $fixtureRoot = New-EpBundleFixtureRepo
        Write-FixtureFile -Root $fixtureRoot -RelativePath 'source\all\workshop-intro.bbcode' -Text "<!-- region:image:hero -->`r`n<!-- /region -->`r`nHistorical flavor events for Testland 1 in one item.`r`n"
        Invoke-EpGenerate -RepoRoot $fixtureRoot -Pack 'all' 6>$null | Out-Null
        @(Get-BundleErrors -Root $fixtureRoot | Where-Object { $_ -like "*does not name 'Testland 2'*" }).Count | Should -Be 1
    }

    It 'fails the check for a page edited by hand, a file in the bundle root and a different supported version' {
        $fixtureRoot = New-EpBundleFixtureRepo
        Invoke-EpGenerate -RepoRoot $fixtureRoot -Pack 'all' 6>$null | Out-Null
        $pagePath = Join-Path $fixtureRoot 'packs\all\WORKSHOP_DESCRIPTION_GUIDELINES.md'
        Write-EpText -Path $pagePath -Text (([System.IO.File]::ReadAllText($pagePath, [System.Text.Encoding]::UTF8)) + 'by hand')
        Write-FixtureFile -Root $fixtureRoot -RelativePath 'packs\all\events\extra_events.txt' -Text 'x'
        Write-FixtureFile -Root $fixtureRoot -RelativePath 'packs\all\descriptor.mod' -Text ("version=`"1.0`"`r`nname=`"Immersive Events Expanded`"`r`nsupported_version=`"1.18.*`"`r`n")
        $bundleErrors = Get-BundleErrors -Root $fixtureRoot
        @($bundleErrors | Where-Object { $_ -like '*differs from what the source generates*' }).Count | Should -Be 1
        @($bundleErrors | Where-Object { $_ -like '*a bundle holds only its descriptor*' }).Count | Should -Be 1
        @($bundleErrors | Where-Object { $_ -like "*supported_version '1.18.*' differs from '1.19.*'*" }).Count | Should -Be 2
    }

    It 'adds a new pack to the members of the bundle' {
        $fixtureRoot = New-EpBundleFixtureRepo
        Invoke-EpNewPack -RepoRoot $fixtureRoot -Pack 'newland' -Tag 'NWL' -DisplayName 'Newland' 6>$null | Out-Null
        $settings = Read-EpJson -Path (Join-Path $fixtureRoot 'tools\HoiModBuild.json')
        @($settings.packages.all.members) | Should -Be @('testland', 'otherland', 'newland')
        $settings.packages.newland.root | Should -BeExactly 'packs/newland'
        @(Get-EpPackNames -RepoRoot $fixtureRoot) | Should -Be @('testland', 'otherland', 'newland')
    }

    It 'leaves a bundle without members out of the new-pack step and refuses a members list it cannot find' {
        { Add-EpBundleMemberText -Text '{ "packages": { "all": { "root": "packs/all" } } }' -Bundle 'all' -Pack 'newland' } | Should -Throw '*members list of bundle*'
        Add-EpBundleMemberText -Text '{ "packages": { "all": { "root": "packs/all", "members": [] } } }' -Bundle 'all' -Pack 'newland' | Should -Match '"members": \["newland"\]'
    }
}

Describe 'Plans' {
    BeforeAll {
        function Get-FixturePlanEvent {
            $planEvent = Get-FixtureEvent
            $planEvent.id = 2
            $planEvent.key = 'trench_line'
            $planEvent.title = 'Trenches on the Isthmus'
            $planEvent.picture = 'trench_line'
            $planEvent.factSheet = 'trench_line'
            return $planEvent
        }

        function New-FixturePlan {
            param([string]$Root)

            $eventSource = Read-EpJson -Path (Join-Path $Root 'source\testland\events.json')
            $eventSource.events = @(@($eventSource.events) + @(Get-FixturePlanEvent))
            $pictureRows = [System.Collections.Generic.List[object]]::new()
            $pictureRows.Add([ordered]@{ Key = 'trench_line'; File = 'File:Trench line 1939.jpg'; Licence = 'PD (Public domain), 800x600, unknown author'; Crop = '50'; Tone = 'warm'; Event = 'trench_line' })
            return @{
                PackLine   = 'Pack: testland (TST, namespace ep_tst)'
                Source     = $eventSource
                EventsText = $null
                FactSheet  = [ordered]@{ trench_line = (Get-FixtureFactLine) }
                Rows       = $pictureRows
            }
        }

        function Write-FixturePlan {
            param([string]$Root, [hashtable]$Plan, [string]$Name = 'test-plan.md')

            $lines = [System.Collections.Generic.List[string]]::new()
            foreach ($headerLine in @('# Testland pack: test plan', '', 'Status: READY')) { $lines.Add($headerLine) }
            if ($Plan.PackLine) { $lines.Add($Plan.PackLine) }
            foreach ($tableLine in @('Kind: new events', '', '## Pictures', '', '| Key | Commons file | Licence (from the dry run) | Crop | Tone | Event |', '|---|---|---|---|---|---|')) { $lines.Add($tableLine) }
            foreach ($row in $Plan.Rows) {
                $lines.Add('| ' + (@($row.Key, $row.File, $row.Licence, $row.Crop, $row.Tone, $row.Event) -join ' | ') + ' |')
            }
            foreach ($middleLine in @('', 'Thumbnail: unchanged', '', '## Implementation steps', '', '- [ ] 1. Apply the plan.', '', '## Fact sheets', '', '```markdown fact-sheets')) { $lines.Add($middleLine) }
            $firstSection = $true
            foreach ($sectionKey in @($Plan.FactSheet.Keys)) {
                if (-not $firstSection) { $lines.Add('') }
                $firstSection = $false
                $lines.Add('## ' + $sectionKey)
                $lines.Add('')
                $lines.Add($Plan.FactSheet[$sectionKey])
            }
            foreach ($blockLine in @('```', '', '## Events source', '', '```json events')) { $lines.Add($blockLine) }
            $lines.Add($(if ($null -ne $Plan.EventsText) { $Plan.EventsText } else { (ConvertTo-Json -InputObject $Plan.Source -Depth 10) -replace "`r`n", "`n" }))
            $lines.Add('```')
            $planPath = Join-Path $Root ('docs\plans\' + $Name)
            Write-EpText -Path $planPath -Text (($lines -join "`n") + "`n")
            return $planPath
        }

        function Get-PlanMessages {
            param([string]$Root, [string]$PlanPath, [string]$Level = 'ERROR', [string]$Pack)

            $planArguments = @{ RepoRoot = $Root; PlanPath = $PlanPath }
            if ($Pack) { $planArguments['Pack'] = $Pack }
            return @(Test-EpPlan @planArguments | Where-Object { $_.Level -eq $Level } | ForEach-Object { "$($_.Where): $($_.Message)" })
        }

        function Get-FixtureHashes {
            param([string]$Root)

            return @(Get-ChildItem -LiteralPath $Root -Recurse -File | Sort-Object FullName | ForEach-Object { $_.FullName.Substring($Root.Length) + '=' + (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash })
        }

        function Get-GitBlobText {
            param([string]$Revision, [string]$Path)

            $processInfo = [System.Diagnostics.ProcessStartInfo]::new('git', ('-C "{0}" show {1}:{2}' -f $script:RepoRoot, $Revision, $Path))
            $processInfo.UseShellExecute = $false
            $processInfo.RedirectStandardOutput = $true
            $processInfo.RedirectStandardError = $true
            $processInfo.StandardOutputEncoding = [System.Text.UTF8Encoding]::new($false)
            try {
                $gitProcess = [System.Diagnostics.Process]::Start($processInfo)
            } catch {
                return $null
            }
            $blobText = $gitProcess.StandardOutput.ReadToEnd()
            [void]$gitProcess.StandardError.ReadToEnd()
            $gitProcess.WaitForExit()
            if ($gitProcess.ExitCode -ne 0) {
                return $null
            }
            return $blobText
        }

        function Write-CanonicalEvents {
            param([string]$Root, $EventSource)

            Write-EpText -Path (Join-Path $Root 'source\testland\events.json') -Text ((ConvertTo-EpJsonText -Value $EventSource) + "`n")
        }

        function New-ThreeEventRepo {
            $fixtureRoot = New-EpFixtureRepo
            $eventSource = Read-EpJson -Path (Join-Path $fixtureRoot 'source\testland\events.json')
            $threeEvents = foreach ($eventNumber in 1..3) {
                $packEvent = Get-FixtureEvent
                $packEvent.id = $eventNumber
                $packEvent.key = @('border_fortification', 'second_event', 'third_event')[$eventNumber - 1]
                $packEvent.title = @('Work on the Isthmus Line', 'Second Work on the Line', 'Third Work on the Line')[$eventNumber - 1]
                $packEvent
            }
            $eventSource.events = @($threeEvents)
            Write-CanonicalEvents -Root $fixtureRoot -EventSource $eventSource
            return $fixtureRoot
        }

        function New-MergePlan {
            param([object[]]$Events, [object[]]$Ideas)

            $mergeSource = [PSCustomObject][ordered]@{ pack = 'testland'; tag = 'TST'; mergeById = $true; events = @($Events) }
            if ($PSBoundParameters.ContainsKey('Ideas')) {
                $mergeSource | Add-Member -NotePropertyName 'ideas' -NotePropertyValue @($Ideas)
            }
            return @{ PackLine = 'Pack: testland (TST, namespace ep_tst)'; Source = $mergeSource; EventsText = $null; FactSheet = [ordered]@{}; Rows = [System.Collections.Generic.List[object]]::new() }
        }
    }

    It 'passes a plan whose blocks and picture rows hold to every source rule' {
        $fixtureRoot = New-EpFixtureRepo
        $planPath = Write-FixturePlan -Root $fixtureRoot -Plan (New-FixturePlan -Root $fixtureRoot)
        Get-PlanMessages -Root $fixtureRoot -PlanPath $planPath | Should -BeNullOrEmpty
        Get-PlanMessages -Root $fixtureRoot -PlanPath $planPath -Level 'WARN' | Should -BeNullOrEmpty
        Invoke-EpPlanCheck -RepoRoot $fixtureRoot -PlanPath $planPath 6>$null | Select-Object -Last 1 | Should -Be 0
    }

    It 'refuses a plan block that breaks the rule: <Rule>' -TestCases @(
        @{ Rule = 'factQuotesFromId a whole number'; Pattern = "factQuotesFromId '0' must be a whole number"; Change = { param($plan) $plan.Source | Add-Member -NotePropertyName 'factQuotesFromId' -NotePropertyValue 0 } }
        @{ Rule = 'country tag'; Pattern = "tag 'tst' is not a country tag"; Change = { param($plan) $plan.Source.tag = 'tst' } }
        @{ Rule = 'namespace form'; Pattern = 'must be ep_ and lower-case letters or digits'; Change = { param($plan) $plan.Source.namespace = 'ep-tst' } }
        @{ Rule = 'id a whole number from 1'; Pattern = 'id must be a whole number from 1'; Change = { param($plan) $plan.Source.events[1].id = 0 } }
        @{ Rule = 'id unique'; Pattern = 'id used twice'; Change = { param($plan) $plan.Source.events[1].id = 1 } }
        @{ Rule = 'key form'; Pattern = "key 'Trench_Line' must be lower-case"; Change = { param($plan) $plan.Source.events[1].key = 'Trench_Line' } }
        @{ Rule = 'key unique'; Pattern = "key 'border_fortification' used twice"; Change = { param($plan) $plan.Source.events[1].key = 'border_fortification' } }
        @{ Rule = 'title not empty'; Pattern = 'ep_tst\.2 title: empty text'; Change = { param($plan) $plan.Source.events[1].title = '' } }
        @{ Rule = 'no forbidden character'; Pattern = 'ep_tst\.2 desc: contains a em dash'; Change = { param($plan) $plan.Source.events[1].desc = $plan.Source.events[1].desc.Replace(' The army', ([string][char]0x2014) + 'the army') } }
        @{ Rule = 'no banned phrase'; Pattern = "banned phrase 'testament to'"; Change = { param($plan) $plan.Source.events[1].desc += ' It is a testament to their work.' } }
        @{ Rule = 'title length'; Pattern = 'characters, at most 60'; Change = { param($plan) $plan.Source.events[1].title = 'Volunteers from the Civil Guard Dig Trenches Across the Karelian Isthmus' } }
        @{ Rule = 'desc word count'; Pattern = 'words, needs 40 to 170'; Change = { param($plan) $plan.Source.events[1].desc = 'Taipale and the Karelian Isthmus in 1937.' } }
        @{ Rule = 'desc character count'; Pattern = 'the event window shows 2226'; Change = { param($plan) $plan.Source.events[1].desc = ((1..100 | ForEach-Object { 'Karelianisthmusfortifiers' }) -join ' ') + ' Karelian Isthmus at Taipale.' } }
        @{ Rule = 'two anchors listed'; Pattern = 'lists 1 anchor\(s\) from its fact sheet; needs 2'; Change = { param($plan) $plan.Source.events[1].anchors = @('Taipale') } }
        @{ Rule = 'two anchors used'; Pattern = 'uses 0 of its anchors; needs 2'; Change = { param($plan) $plan.Source.events[1].anchors = @('Viipuri', 'Kotka') } }
        @{ Rule = 'fact-sheet section exists'; Pattern = "no section '## missing_section'"; Change = { param($plan) $plan.Source.events[1].factSheet = 'missing_section' } }
        @{ Rule = 'fact sheet cites a source'; Pattern = "fact sheet 'trench_line' cites no source URL"; Change = { param($plan) $plan.FactSheet['trench_line'] = '- Volunteers dug on the Karelian Isthmus in 1937.' } }
        @{ Rule = 'fact lines'; Pattern = "fact sheet 'trench_line' has no fact lines"; Change = { param($plan) $plan.FactSheet['trench_line'] = 'Volunteers dug on the Karelian Isthmus, see https://example.org/isthmus.' } }
        @{ Rule = 'no UNVERIFIED fact'; Pattern = 'holds an UNVERIFIED fact'; Change = { param($plan) $plan.FactSheet['trench_line'] = (Get-FixtureFactLine) + "`n- UNVERIFIED: the army paid them. Source: https://example.org/pay (Pay)" } }
        @{ Rule = 'quoted facts'; Pattern = 'has a fact without its source and the quote of its page'; Change = { param($plan) $plan.FactSheet['trench_line'] = (Get-FixtureFactLine -WithoutQuote) } }
        @{ Rule = 'date form'; Pattern = "date '1937-5-1' is not YYYY\.M\.D"; Change = { param($plan) $plan.Source.events[1].fire.after = '1937-5-1' } }
        @{ Rule = 'both dates'; Pattern = 'fire needs an after and a before date'; Change = { param($plan) $plan.Source.events[1].fire.before = '' } }
        @{ Rule = 'window order'; Pattern = 'the before date is not after the after date'; Change = { param($plan) $plan.Source.events[1].fire.before = '1937.4.1' } }
        @{ Rule = 'weekly chance'; Pattern = 'chance must be 1 to 100'; Change = { param($plan) $plan.Source.events[1].fire.chance = 0 } }
        @{ Rule = 'a picture'; Pattern = 'ep_tst\.2: no picture'; Change = { param($plan) $plan.Source.events[1].picture = '' } }
        @{ Rule = 'vanilla picture form'; Pattern = "'vanilla:GFX_bad' is not a vanilla event picture sprite"; Change = { param($plan) $plan.Source.events[1].picture = 'vanilla:GFX_bad' } }
        @{ Rule = 'picture fetched or planned'; Pattern = "picture 'no_such_picture' is neither in source/testland/pictures\.json nor in the plan's Pictures table"; Change = { param($plan) $plan.Source.events[1].picture = 'no_such_picture' } }
        @{ Rule = 'option count'; Pattern = '0 option\(s\), needs 1 to 4'; Change = { param($plan) $plan.Source.events[1].options = @() } }
        @{ Rule = 'option length'; Pattern = 'ep_tst\.2\.a: option text over 12 words'; Change = { param($plan) $plan.Source.events[1].options[0].name = 'One two three four five six seven eight nine ten eleven twelve thirteen.' } }
        @{ Rule = 'ai weight'; Pattern = 'ai weight below 0'; Change = { param($plan) $plan.Source.events[1].options[0].ai = -1 } }
        @{ Rule = 'ideology with popularity'; Pattern = "ideology 'fascism' without popularity"; Change = { param($plan) $plan.Source.events[1].options[1].effects = @([PSCustomObject]@{ ideology = 'fascism' }) } }
        @{ Rule = 'timed idea defined'; Pattern = "timed_idea 'no_such_idea' is not in the pack's ideas"; Change = { param($plan) $plan.Source.events[1].options[0].effects[1].timed_idea = 'no_such_idea' } }
        @{ Rule = 'timed idea days'; Pattern = 'timed idea for 365 days'; Change = { param($plan) $plan.Source.events[1].options[0].effects[1].days = 365 } }
        @{ Rule = 'known effect'; Pattern = "effect 'add_manpower' is not one of"; Change = { param($plan) $plan.Source.events[1].options[1].effects = @([PSCustomObject]@{ add_manpower = 1000 }) } }
        @{ Rule = 'effect cap'; Pattern = 'war_support 0\.5 is over the cap of 0\.1'; Change = { param($plan) $plan.Source.events[1].options[0].effects[0].war_support = 0.5 } }
        @{ Rule = 'whole manpower'; Pattern = 'manpower 500\.5 is not a whole number'; Change = { param($plan) $plan.Source.events[1].options[1].effects = @([PSCustomObject]@{ manpower = 500.5 }) } }
        @{ Rule = 'popularity ideology'; Pattern = 'popularity needs an ideology'; Change = { param($plan) $plan.Source.events[1].options[1].effects = @([PSCustomObject]@{ popularity = 0.02 }) } }
        @{ Rule = 'idea key'; Pattern = 'key missing, used twice or not lower-case'; Change = { param($plan) $plan.Source.ideas[0].key = 'Volunteer Work' } }
        @{ Rule = 'idea text'; Pattern = 'idea volunteer_work name: contains a hash sign'; Change = { param($plan) $plan.Source.ideas[0].name = 'Volunteer Work #1' } }
        @{ Rule = 'idea picture'; Pattern = "picture 'some_custom_picture' is not one of"; Change = { param($plan) $plan.Source.ideas[0].picture = 'some_custom_picture' } }
        @{ Rule = 'idea modifier count'; Pattern = '0 modifier\(s\), needs 1 to 3'; Change = { param($plan) $plan.Source.ideas[0].modifier = [PSCustomObject]@{} } }
        @{ Rule = 'idea modifier known'; Pattern = "modifier 'industrial_capacity_dockyard' is not in data/effect-caps\.json"; Change = { param($plan) $plan.Source.ideas[0].modifier = [PSCustomObject]@{ industrial_capacity_dockyard = 0.1 } } }
        @{ Rule = 'idea modifier cap'; Pattern = 'war_support_factor 0\.5 is over the cap of 0\.05'; Change = { param($plan) $plan.Source.ideas[0].modifier = [PSCustomObject]@{ war_support_factor = 0.5 } } }
        @{ Rule = 'picture row key form'; Pattern = "picture row 'Trench-Line': key must be lower-case letters, digits and underscores"; Change = { param($plan) $plan.Rows[0].Key = 'Trench-Line'; $plan.Source.events[1].picture = 'Trench-Line' } }
        @{ Rule = 'picture row once'; Pattern = "picture row 'trench_line': listed twice in the Pictures table"; Change = { param($plan) $plan.Rows.Add([ordered]@{ Key = 'trench_line'; File = 'File:Other trench.jpg'; Licence = 'CC0 (CC0), 800x600, someone'; Crop = '50'; Tone = 'none'; Event = 'trench_line' }) } }
        @{ Rule = 'picture row file'; Pattern = "picture row 'trench_line': names no Commons file"; Change = { param($plan) $plan.Rows[0].File = '' } }
        @{ Rule = 'picture row licence BY-SA'; Pattern = "licence 'CC BY-SA \(CC BY-SA 4\.0\), 800x600, someone' is not a licence the policy accepts"; Change = { param($plan) $plan.Rows[0].Licence = 'CC BY-SA (CC BY-SA 4.0), 800x600, someone' } }
        @{ Rule = 'picture row licence other'; Pattern = "licence 'Fair use' is not a licence the policy accepts"; Change = { param($plan) $plan.Rows[0].Licence = 'Fair use' } }
        @{ Rule = 'picture row size'; Pattern = '200x150 is smaller than 210x176'; Change = { param($plan) $plan.Rows[0].Licence = 'PD (Public domain), 200x150, unknown author' } }
        @{ Rule = 'picture row crop'; Pattern = "crop '150' is not 0 to 100 \(50 centres\) or fit"; Change = { param($plan) $plan.Rows[0].Crop = '150' } }
        @{ Rule = 'picture row tone'; Pattern = "tone 'sepia' is not none, grey or warm"; Change = { param($plan) $plan.Rows[0].Tone = 'sepia' } }
        @{ Rule = 'events block parses'; Pattern = 'the json events block does not parse'; Change = { param($plan) $plan.EventsText = '{ "pack": "testland", "events": [' } }
        @{ Rule = 'no event id removed'; Pattern = 'the json events block lacks event\(s\) 1 of source/testland/events\.json'; Change = { param($plan) $plan.Source.events = @(Get-FixturePlanEvent) } }
        @{ Rule = 'one pack'; Pattern = "the events block names pack 'otherland', the plan 'testland'"; Change = { param($plan) $plan.Source.pack = 'otherland' } }
        @{ Rule = 'a pack named'; Pattern = 'the plan names no pack'; Change = { param($plan) $plan.PackLine = $null; $plan.Source.PSObject.Properties.Remove('pack') } }
        @{ Rule = 'the pack exists'; Pattern = "pack 'nowhere' is not a pack of tools/HoiModBuild\.json"; Change = { param($plan) $plan.PackLine = 'Pack: nowhere (NWH, namespace ep_nwh)'; $plan.Source.pack = 'nowhere' } }
    ) {
        param($Rule, $Pattern, $Change)

        $fixtureRoot = New-EpFixtureRepo
        $plan = New-FixturePlan -Root $fixtureRoot
        & $Change $plan
        $planPath = Write-FixturePlan -Root $fixtureRoot -Plan $plan
        $errorMessages = (Get-PlanMessages -Root $fixtureRoot -PlanPath $planPath) -join "`n"
        $errorMessages | Should -Match $Pattern
        Invoke-EpPlanCheck -RepoRoot $fixtureRoot -PlanPath $planPath 6>$null | Select-Object -Last 1 | Should -Be 1
    }

    It 'warns about a fact-sheet section no event uses and a picture row no event uses' {
        $fixtureRoot = New-EpFixtureRepo
        $plan = New-FixturePlan -Root $fixtureRoot
        $plan.FactSheet['unused_section'] = Get-FixtureFactLine
        $plan.Rows.Add([ordered]@{ Key = 'spare_picture'; File = 'File:Spare.jpg'; Licence = 'CC0 (CC0), 800x600, someone'; Crop = 'fit'; Tone = 'grey'; Event = '' })
        $planPath = Write-FixturePlan -Root $fixtureRoot -Plan $plan
        Get-PlanMessages -Root $fixtureRoot -PlanPath $planPath | Should -BeNullOrEmpty
        $warnings = (Get-PlanMessages -Root $fixtureRoot -PlanPath $planPath -Level 'WARN') -join "`n"
        $warnings | Should -Match "section 'unused_section' belongs to no event"
        $warnings | Should -Match "picture row 'spare_picture': no event uses this picture"
    }

    It 'refuses a -Pack that is not a pack of the build settings, also a path out of source' {
        $fixtureRoot = New-EpFixtureRepo
        $plan = New-FixturePlan -Root $fixtureRoot
        $plan.PackLine = $null
        $plan.Source.PSObject.Properties.Remove('pack')
        $planPath = Write-FixturePlan -Root $fixtureRoot -Plan $plan
        (Get-PlanMessages -Root $fixtureRoot -PlanPath $planPath -Pack '..\..\outside') -join "`n" | Should -Match ([regex]::Escape("pack '..\..\outside' is not a pack of tools/HoiModBuild.json"))
    }

    It 'refuses a namespace another pack uses' {
        $fixtureRoot = New-EpFixtureRepo -Packs @('testland', 'otherland')
        $plan = New-FixturePlan -Root $fixtureRoot
        $plan.Source.namespace = 'ep_tsu'
        $planPath = Write-FixturePlan -Root $fixtureRoot -Plan $plan
        (Get-PlanMessages -Root $fixtureRoot -PlanPath $planPath) -join "`n" | Should -Match "namespace 'ep_tsu' is used by another pack"
    }

    It 'refuses two blocks of a kind, no block at all, a -Pack the plan contradicts, and a fact-sheets block with stray text or a section twice' {
        $fixtureRoot = New-EpFixtureRepo
        $planPath = Write-FixturePlan -Root $fixtureRoot -Plan (New-FixturePlan -Root $fixtureRoot)
        $planText = [System.IO.File]::ReadAllText($planPath)
        $eventsBlock = [regex]::Match($planText, '(?ms)^```json events\n.*?^```\n').Value
        Write-EpText -Path $planPath -Text ($planText + "`n" + $eventsBlock)
        (Get-PlanMessages -Root $fixtureRoot -PlanPath $planPath) -join "`n" | Should -Match 'the plan has 2 ```json events blocks; one is allowed'
        Write-EpText -Path $planPath -Text "# A plan`n`nPack: testland`n"
        (Get-PlanMessages -Root $fixtureRoot -PlanPath $planPath) -join "`n" | Should -Match 'the plan has no ```json events block and no ```markdown fact-sheets block'
        Write-EpText -Path $planPath -Text $planText
        (Get-PlanMessages -Root $fixtureRoot -PlanPath $planPath -Pack 'otherland') -join "`n" | Should -Match "the plan names pack 'testland', -Pack 'otherland'"
        Write-EpText -Path $planPath -Text $planText.Replace("``````markdown fact-sheets`n", "``````markdown fact-sheets`nStray line.`n`n## trench_line`n`n" + (Get-FixtureFactLine) + "`n`n")
        $errorMessages = (Get-PlanMessages -Root $fixtureRoot -PlanPath $planPath) -join "`n"
        $errorMessages | Should -Match "text before the first '## <key>' heading belongs to no section: 'Stray line\.'"
        $errorMessages | Should -Match "section 'trench_line' is in the block twice"
    }

    It 'takes the pack from -Pack when the plan names none' {
        $fixtureRoot = New-EpFixtureRepo
        $plan = New-FixturePlan -Root $fixtureRoot
        $plan.PackLine = $null
        $plan.Source.PSObject.Properties.Remove('pack')
        $planPath = Write-FixturePlan -Root $fixtureRoot -Plan $plan
        Get-PlanMessages -Root $fixtureRoot -PlanPath $planPath -Pack 'testland' | Should -BeNullOrEmpty
    }

    It 'writes nothing with -DryRun and prints what would change' {
        $fixtureRoot = New-EpFixtureRepo
        $planPath = Write-FixturePlan -Root $fixtureRoot -Plan (New-FixturePlan -Root $fixtureRoot)
        $hashesBefore = Get-FixtureHashes -Root $fixtureRoot
        $output = @(Invoke-EpApplyPlan -RepoRoot $fixtureRoot -PlanPath $planPath -DryRun 6>&1 | ForEach-Object { [string]$_ })
        $output[-1] | Should -Be '0'
        Get-FixtureHashes -Root $fixtureRoot | Should -Be $hashesBefore
        $outputText = $output -join "`n"
        $outputText | Should -Match 'source/testland/events\.json: event 2 trench_line added'
        $outputText | Should -Match "source/testland/fact-sheets\.md: section 'trench_line' added"
        $outputText | Should -Match 'Dry run: 2 file\(s\) would be written'
    }

    It 'writes the events and adds the fact-sheet section, and then finds nothing left to change' {
        $fixtureRoot = New-EpFixtureRepo
        $factSheetPath = Join-Path $fixtureRoot 'source\testland\fact-sheets.md'
        $factSheetBefore = [System.IO.File]::ReadAllText($factSheetPath)
        $planPath = Write-FixturePlan -Root $fixtureRoot -Plan (New-FixturePlan -Root $fixtureRoot)
        Invoke-EpApplyPlan -RepoRoot $fixtureRoot -PlanPath $planPath 6>$null | Select-Object -Last 1 | Should -Be 0
        $eventsPath = Join-Path $fixtureRoot 'source\testland\events.json'
        $writtenSource = Read-EpJson -Path $eventsPath
        @($writtenSource.events | ForEach-Object { $_.key }) | Should -Be @('border_fortification', 'trench_line')
        $writtenText = [System.IO.File]::ReadAllText($eventsPath)
        $writtenText.Replace("`r`n", "`n") | Should -BeExactly ((ConvertTo-EpJsonText -Value $writtenSource) + "`n")
        $writtenText | Should -Match "\r\n" -Because 'the file keeps the line ends it had (the fixture writes CRLF)'
        $eventsBytes = [System.IO.File]::ReadAllBytes($eventsPath)
        $eventsBytes[0] | Should -Be ([byte][char]'{') -Because 'events.json is UTF-8 without a BOM'
        [System.IO.File]::ReadAllText($factSheetPath) | Should -BeExactly ($factSheetBefore + "`r`n## trench_line`r`n`r`n" + (Get-FixtureFactLine) + "`r`n")
        $output = @(Invoke-EpApplyPlan -RepoRoot $fixtureRoot -PlanPath $planPath -DryRun 6>&1 | ForEach-Object { [string]$_ })
        ($output -join "`n") | Should -Match 'Dry run: 0 file\(s\) would be written'
    }

    It 'replaces a fact-sheet section by its key and leaves the others as they are' {
        $fixtureRoot = New-EpFixtureRepo
        $factSheetPath = Join-Path $fixtureRoot 'source\testland\fact-sheets.md'
        Write-FixtureFile -Root $fixtureRoot -RelativePath 'source\testland\fact-sheets.md' -Text ("# Fact sheets`n`n## border_fortification`n`n" + (Get-FixtureFactLine) + "`n`n## other_section`n`n- Kept. Source: https://example.org/kept (Kept). Quote: " + [char]0x00AB + 'Kept.' + [char]0x00BB + "`n")
        $plan = New-FixturePlan -Root $fixtureRoot
        $newLine = '- Volunteers dug near Taipale in 1937. Source: https://example.org/new (New). Quote: ' + [char]0x00AB + 'Uusi.' + [char]0x00BB
        $plan.FactSheet = [ordered]@{ border_fortification = $newLine; trench_line = (Get-FixtureFactLine) }
        $planPath = Write-FixturePlan -Root $fixtureRoot -Plan $plan
        Invoke-EpApplyPlan -RepoRoot $fixtureRoot -PlanPath $planPath 6>$null | Select-Object -Last 1 | Should -Be 0
        [System.IO.File]::ReadAllText($factSheetPath) | Should -BeExactly ("# Fact sheets`n`n## border_fortification`n`n" + $newLine + "`n`n## other_section`n`n- Kept. Source: https://example.org/kept (Kept). Quote: " + [char]0x00AB + 'Kept.' + [char]0x00BB + "`n`n## trench_line`n`n" + (Get-FixtureFactLine) + "`n")
    }

    It 'refuses to apply a plan the check fails and writes nothing' {
        $fixtureRoot = New-EpFixtureRepo
        $plan = New-FixturePlan -Root $fixtureRoot
        $plan.Source.events[1].options[0].effects[0].war_support = 0.5
        $planPath = Write-FixturePlan -Root $fixtureRoot -Plan $plan
        $hashesBefore = Get-FixtureHashes -Root $fixtureRoot
        $output = @(Invoke-EpApplyPlan -RepoRoot $fixtureRoot -PlanPath $planPath 6>&1 | ForEach-Object { [string]$_ })
        $output[-1] | Should -Be '1'
        ($output -join "`n") | Should -Match 'nothing written'
        Get-FixtureHashes -Root $fixtureRoot | Should -Be $hashesBefore
    }

    It 'gives the archived Poland audit plan the files of the audit commit, applied to the source before it' {
        $auditCommit = '135bfbd'
        $sourceFiles = @('events.json', 'fact-sheets.md', 'pictures.json')
        $beforeTexts = @{}
        foreach ($sourceFile in $sourceFiles) { $beforeTexts[$sourceFile] = Get-GitBlobText -Revision "$auditCommit~1" -Path "source/poland/$sourceFile" }
        $afterEvents = Get-GitBlobText -Revision $auditCommit -Path 'source/poland/events.json'
        $afterFactSheets = Get-GitBlobText -Revision $auditCommit -Path 'source/poland/fact-sheets.md'
        if ($null -eq $afterEvents -or @($beforeTexts.Values | Where-Object { $null -eq $_ }).Count -gt 0) {
            Set-ItResult -Skipped -Because "the clone holds no history of the Poland audit commit $auditCommit (a shallow checkout)"
            return
        }
        $afterEvents | Should -Not -Be $beforeTexts['events.json'] -Because 'the audit changed the events'
        $fixtureRoot = Join-Path $TestDrive 'poland-audit'
        New-Item -ItemType Directory -Path (Join-Path $fixtureRoot 'data') -Force | Out-Null
        Copy-Item -Path (Join-Path $script:RepoRoot 'data\*') -Destination (Join-Path $fixtureRoot 'data')
        Write-FixtureFile -Root $fixtureRoot -RelativePath 'tools\HoiModBuild.json' -Text '{ "packages": { "poland": { "root": "packs/poland", "modFolderName": "event_pack_poland" } } }'
        foreach ($sourceFile in $sourceFiles) { Write-EpText -Path (Join-Path $fixtureRoot "source\poland\$sourceFile") -Text $beforeTexts[$sourceFile] }
        $planPath = Join-Path $script:RepoRoot 'docs\plans\archive\2026-11-05-poland-audit.md'
        Invoke-EpApplyPlan -RepoRoot $fixtureRoot -PlanPath $planPath 6>$null | Select-Object -Last 1 | Should -Be 0
        [System.IO.File]::ReadAllText((Join-Path $fixtureRoot 'source\poland\events.json')) | Should -BeExactly $afterEvents
        [System.IO.File]::ReadAllText((Join-Path $fixtureRoot 'source\poland\fact-sheets.md')) | Should -BeExactly $afterFactSheets
    }

    It 'writes every events.json of this repository back unchanged' {
        foreach ($packName in @(Get-EpPackNames -RepoRoot $script:RepoRoot)) {
            $eventsPath = Join-Path $script:RepoRoot "source\$packName\events.json"
            # The layout is what is checked, not the line ends: a checkout with core.autocrlf (the CI runner) gives CRLF.
            $eventsText = [System.IO.File]::ReadAllText($eventsPath, [System.Text.Encoding]::UTF8).Replace("`r`n", "`n")
            ((ConvertTo-EpJsonText -Value (Read-EpJson -Path $eventsPath)) + "`n") | Should -BeExactly $eventsText -Because "-ApplyPlan writes source/$packName/events.json in its own format"
        }
    }

    It 'build.ps1 takes -Plan for -Check and -ApplyPlan' {
        $buildParameters = (Get-Command (Join-Path $script:RepoRoot 'build.ps1')).Parameters
        $buildParameters.Keys | Should -Contain 'Plan'
        $buildParameters.Keys | Should -Contain 'ApplyPlan'
        @($buildParameters['Plan'].ParameterSets.Keys) | Should -Contain 'Check'
        @($buildParameters['Plan'].ParameterSets.Keys) | Should -Contain 'ApplyPlan'
    }

    Context 'An audit block of the changed events only' {
        It 'merges the changed events by id and leaves the other events and their order as they are' {
            $fixtureRoot = New-ThreeEventRepo
            $eventsPath = Join-Path $fixtureRoot 'source\testland\events.json'
            $expectedSource = Read-EpJson -Path $eventsPath
            $changedEvent = Get-FixtureEvent
            $changedEvent.id = 2
            $changedEvent.key = 'second_event'
            $changedEvent.title = 'Second Work on the Line, Rewritten'
            $expectedSource.events[1] = $changedEvent
            $planPath = Write-FixturePlan -Root $fixtureRoot -Plan (New-MergePlan -Events @($changedEvent))
            $output = @(Invoke-EpApplyPlan -RepoRoot $fixtureRoot -PlanPath $planPath 6>&1 | ForEach-Object { [string]$_ })
            $output[-1] | Should -Be '0'
            ($output -join "`n") | Should -Match 'event 2 second_event changed \(title\)'
            [System.IO.File]::ReadAllText($eventsPath) | Should -BeExactly ((ConvertTo-EpJsonText -Value $expectedSource) + "`n")
            @((Read-EpJson -Path $eventsPath).events | ForEach-Object { $_.id }) | Should -Be @(1, 2, 3)
        }

        It 'merges a changed idea by key and removes factQuotesFromId when the block sets it to null' {
            $fixtureRoot = New-ThreeEventRepo
            $eventsPath = Join-Path $fixtureRoot 'source\testland\events.json'
            $startSource = Read-EpJson -Path $eventsPath
            $startSource | Add-Member -NotePropertyName 'factQuotesFromId' -NotePropertyValue 1
            Write-CanonicalEvents -Root $fixtureRoot -EventSource $startSource
            $changedIdea = [PSCustomObject][ordered]@{ key = 'volunteer_work'; name = 'Volunteer Work on the Line'; desc = 'Students dig on the Karelian Isthmus.'; picture = 'generic_morale_bonus'; modifier = [PSCustomObject]@{ war_support_factor = 0.02 } }
            $plan = New-MergePlan -Events @() -Ideas @($changedIdea)
            $plan.Source | Add-Member -NotePropertyName 'factQuotesFromId' -NotePropertyValue $null
            $planPath = Write-FixturePlan -Root $fixtureRoot -Plan $plan
            Invoke-EpApplyPlan -RepoRoot $fixtureRoot -PlanPath $planPath 6>$null | Select-Object -Last 1 | Should -Be 0
            $writtenSource = Read-EpJson -Path $eventsPath
            $writtenSource.PSObject.Properties['factQuotesFromId'] | Should -BeNullOrEmpty
            $writtenSource.ideas[0].name | Should -Be 'Volunteer Work on the Line'
            @($writtenSource.events | ForEach-Object { $_.id }) | Should -Be @(1, 2, 3)
        }

        It 'refuses an id that is not in events.json and writes nothing' {
            $fixtureRoot = New-ThreeEventRepo
            $newEvent = Get-FixtureEvent
            $newEvent.id = 4
            $newEvent.key = 'fourth_event'
            $planPath = Write-FixturePlan -Root $fixtureRoot -Plan (New-MergePlan -Events @($newEvent))
            (Get-PlanMessages -Root $fixtureRoot -PlanPath $planPath) -join "`n" | Should -Match 'event 4 \(fourth_event\) is not in source/testland/events\.json'
            $hashesBefore = Get-FixtureHashes -Root $fixtureRoot
            Invoke-EpApplyPlan -RepoRoot $fixtureRoot -PlanPath $planPath 6>$null | Select-Object -Last 1 | Should -Be 1
            Get-FixtureHashes -Root $fixtureRoot | Should -Be $hashesBefore
        }

        It 'refuses a tag or namespace other than the file''s and an event twice, and warns about a field the block event drops' {
            $fixtureRoot = New-ThreeEventRepo
            $changedEvent = Get-FixtureEvent
            $changedEvent.id = 2
            $changedEvent.key = 'second_event'
            $changedEvent.PSObject.Properties.Remove('anchors')
            $plan = New-MergePlan -Events @($changedEvent, $changedEvent)
            $plan.Source.tag = 'TSX'
            $plan.Source | Add-Member -NotePropertyName 'namespace' -NotePropertyValue 'ep_tsx'
            $planPath = Write-FixturePlan -Root $fixtureRoot -Plan $plan
            $errorMessages = (Get-PlanMessages -Root $fixtureRoot -PlanPath $planPath) -join "`n"
            $errorMessages | Should -Match ([regex]::Escape('"tag" ''TSX'' differs from source/testland/events.json (''TST'')'))
            $errorMessages | Should -Match ([regex]::Escape('"namespace" ''ep_tsx'' differs from source/testland/events.json (''ep_tst'')'))
            $errorMessages | Should -Match 'event 2 is in the block twice'
            (Get-PlanMessages -Root $fixtureRoot -PlanPath $planPath -Level 'WARN') -join "`n" | Should -Match 'event 2 \(second_event\) lacks the field\(s\) anchors of its current event'
        }

        It 'refuses a block without the pack and tag, or with a field of its own' {
            $fixtureRoot = New-ThreeEventRepo
            $changedEvent = Get-FixtureEvent
            $plan = New-MergePlan -Events @($changedEvent)
            $plan.Source.PSObject.Properties.Remove('tag')
            $plan.Source | Add-Member -NotePropertyName 'comment' -NotePropertyValue 'audit'
            $planPath = Write-FixturePlan -Root $fixtureRoot -Plan $plan
            $errorMessages = (Get-PlanMessages -Root $fixtureRoot -PlanPath $planPath) -join "`n"
            $errorMessages | Should -Match 'a "mergeById" block needs "pack" and "tag"'
            $errorMessages | Should -Match '"comment" is not a field of a "mergeById" block'
        }
    }
}

Describe 'This repository' {
    It 'every pack passes the check' {
        $packNames = @(Get-EpPackNames -RepoRoot $script:RepoRoot)
        $packNames.Count | Should -BeGreaterThan 0
        foreach ($packName in $packNames) {
            @(Test-EpPack -RepoRoot $script:RepoRoot -Pack $packName | Where-Object { $_.Level -eq 'ERROR' } | ForEach-Object { "$($_.Where): $($_.Message)" }) | Should -BeNullOrEmpty -Because "pack '$packName' must pass build.ps1 -Check"
        }
    }

    It 'every bundle passes the check and holds every pack as a member' {
        $bundleNames = @(Get-EpBundleNames -RepoRoot $script:RepoRoot)
        $bundleNames.Count | Should -BeGreaterThan 0
        foreach ($bundleName in $bundleNames) {
            @(Test-EpBundle -RepoRoot $script:RepoRoot -Bundle $bundleName | Where-Object { $_.Level -eq 'ERROR' } | ForEach-Object { "$($_.Where): $($_.Message)" }) | Should -BeNullOrEmpty -Because "bundle '$bundleName' must pass build.ps1 -Check"
        }
        foreach ($packName in @(Get-EpPackNames -RepoRoot $script:RepoRoot)) {
            @(Get-EpBundleNames -RepoRoot $script:RepoRoot -Member $packName).Count | Should -BeGreaterThan 0 -Because "pack '$packName' must be a member of a bundle"
        }
    }

    It 'every banned pattern is a valid expression' {
        { Get-EpBannedPatterns -RepoRoot $script:RepoRoot } | Should -Not -Throw
        (Get-EpBannedPatterns -RepoRoot $script:RepoRoot).Count | Should -BeGreaterThan 20
    }

    It 'every capped option effect is one the generator writes' {
        $capped = @((Get-EpCaps -RepoRoot $script:RepoRoot).optionEffects.PSObject.Properties.Name | Sort-Object)
        $written = @(@((Get-EpEffectCommands).Keys) + 'popularity' | Sort-Object)
        $capped | Should -Be $written
    }

    It 'every capped idea modifier is spelled as the game documents it' {
        $caps = Get-EpCaps -RepoRoot $script:RepoRoot
        foreach ($modifierName in @($caps.ideaModifiers.PSObject.Properties.Name)) {
            $modifierName | Should -Match '^[a-z_]+$'
        }
    }
}
