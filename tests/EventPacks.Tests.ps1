BeforeAll {
    $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
    . (Join-Path $script:RepoRoot 'tools\EventPacks.ps1')
    . (Join-Path $script:RepoRoot 'tools\EventPacksTestMod.ps1')
    $script:CommonsFixtureDir = Join-Path $PSScriptRoot 'fixtures\commons'

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
        $workshopText | Should -Match '\[url=https://github\.com/TheCreepero/event-packs/wiki/Event-Pack-Testland-1\]'
        $workshopText | Should -Match '\[\*\]\[url=https://steamcommunity\.com/sharedfiles/filedetails/\?id=2967389401\]Immersive Namelists Expanded\[/url\]'
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
        $auditText = (Invoke-EpAudit -RepoRoot $fixtureRoot -Pack 'testland' 6>&1 | Out-String)
        $auditText | Should -Match '\[WARN\].*the facts of events 1 predate quoted facts \(factQuotesFromId 2\)'
    }

    It 'writes the quoted fact format into the fact sheet of a new pack' {
        $fixtureRoot = New-EpFixtureRepo
        Invoke-EpNewPack -RepoRoot $fixtureRoot -Pack 'newland' -Tag 'NWL' -DisplayName 'Newland' 6>$null | Out-Null
        $factSheetText = [System.IO.File]::ReadAllText((Join-Path $fixtureRoot 'source\newland\fact-sheets.md'), [System.Text.Encoding]::UTF8)
        $factSheetText | Should -Match ('Quote: ' + [char]0x00AB)
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
        $allFiles = @(Get-ChildItem -LiteralPath $outputDir -File | Where-Object { $_.Extension -in @('.png', '.jpg') } | Sort-Object Name)
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
}

Describe 'This repository' {
    It 'every pack passes the check' {
        $packNames = @(Get-EpPackNames -RepoRoot $script:RepoRoot)
        $packNames.Count | Should -BeGreaterThan 0
        foreach ($packName in $packNames) {
            @(Test-EpPack -RepoRoot $script:RepoRoot -Pack $packName | Where-Object { $_.Level -eq 'ERROR' } | ForEach-Object { "$($_.Where): $($_.Message)" }) | Should -BeNullOrEmpty -Because "pack '$packName' must pass build.ps1 -Check"
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
