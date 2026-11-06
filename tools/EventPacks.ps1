. (Join-Path $PSScriptRoot 'HoiImageSources.ps1')

function Get-EpUtf8 {
    param([switch]$Bom)

    return [System.Text.UTF8Encoding]::new([bool]$Bom)
}

function Get-EpLanguages {
    return @('braz_por', 'english', 'french', 'german', 'japanese', 'korean', 'polish', 'russian', 'simp_chinese', 'spanish')
}

function Get-EpTextRules {
    return [PSCustomObject]@{
        DescMinWords   = 40
        DescMaxWords   = 170
        DescMaxChars   = 2226
        TitleMaxChars  = 60
        OptionMaxWords = 12
        MinAnchors     = 2
        MaxOptions     = 4
    }
}

function Get-EpForbiddenCharacters {
    return [ordered]@{
        ([string][char]0x2014) = 'em dash'
        ([string][char]0x2013) = 'en dash'
        ([string][char]0x2018) = 'curved quote'
        ([string][char]0x2019) = 'curved quote'
        ([string][char]0x201C) = 'curved quote'
        ([string][char]0x201D) = 'curved quote'
        ([string][char]0x2026) = 'ellipsis character'
        '"'                    = 'straight double quote (use single quotes inside a text)'
        '['                    = 'square bracket (localisation markup)'
        ']'                    = 'square bracket (localisation markup)'
        '$'                    = 'dollar sign (localisation markup)'
        ([string][char]0x00A7) = 'section sign (localisation colour code)'
        ([string][char]0x00A3) = 'pound sign (localisation icon code)'
        '#'                    = 'hash sign (localisation formatting)'
    }
}

function ConvertTo-EpArray {
    param($Value)

    $items = [System.Collections.Generic.List[object]]::new()
    foreach ($item in @($Value)) {
        if ($null -ne $item) {
            $items.Add($item)
        }
    }
    return $items.ToArray()
}

function Get-EpProperty {
    param($Object, [string]$Name, $Default = $null)

    if ($null -ne $Object -and $Object.PSObject.Properties[$Name] -and $null -ne $Object.$Name) {
        return $Object.$Name
    }
    return $Default
}

function Read-EpJson {
    param([Parameter(Mandatory = $true)][string]$Path)

    return ([System.IO.File]::ReadAllText($Path, [System.Text.Encoding]::UTF8) | ConvertFrom-Json)
}

function Write-EpText {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][AllowEmptyString()][string]$Text,
        [switch]$Bom
    )

    $parentPath = Split-Path -Parent $Path
    if (-not (Test-Path -LiteralPath $parentPath)) {
        New-Item -ItemType Directory -Path $parentPath -Force | Out-Null
    }
    [System.IO.File]::WriteAllText($Path, $Text, (Get-EpUtf8 -Bom:$Bom))
}

function Format-EpNumber {
    param([Parameter(Mandatory = $true)]$Value)

    return ([double]$Value).ToString('0.####', [System.Globalization.CultureInfo]::InvariantCulture)
}

function Get-EpPackageEntries {
    param([Parameter(Mandatory = $true)][string]$RepoRoot)

    $settingsPath = Join-Path $RepoRoot 'tools\HoiModBuild.json'
    if (-not (Test-Path -LiteralPath $settingsPath)) {
        return @()
    }
    $packages = Get-EpProperty -Object (Read-EpJson -Path $settingsPath) -Name 'packages'
    if ($null -eq $packages) {
        return @()
    }
    return @($packages.PSObject.Properties)
}

function Get-EpPackNames {
    param([Parameter(Mandatory = $true)][string]$RepoRoot)

    return @(Get-EpPackageEntries -RepoRoot $RepoRoot | Where-Object { $null -eq (Get-EpProperty -Object $_.Value -Name 'members') } | ForEach-Object { $_.Name })
}

function Get-EpBundleNames {
    param(
        [Parameter(Mandatory = $true)][string]$RepoRoot,
        [string[]]$Member
    )

    $bundleEntries = @(Get-EpPackageEntries -RepoRoot $RepoRoot | Where-Object { $null -ne (Get-EpProperty -Object $_.Value -Name 'members') })
    if ($Member) {
        $bundleEntries = @($bundleEntries | Where-Object { $holdsMember = $false; foreach ($memberName in @($_.Value.members)) { if ($Member -contains $memberName) { $holdsMember = $true } }; $holdsMember })
    }
    return @($bundleEntries | ForEach-Object { $_.Name })
}

function Get-EpBundle {
    param(
        [Parameter(Mandatory = $true)][string]$RepoRoot,
        [Parameter(Mandatory = $true)][string]$Bundle
    )

    $RepoRoot = (Get-Item -LiteralPath $RepoRoot).FullName.TrimEnd('\')
    $bundleEntry = @(Get-EpPackageEntries -RepoRoot $RepoRoot | Where-Object { $_.Name -eq $Bundle -and $null -ne (Get-EpProperty -Object $_.Value -Name 'members') })[0]
    if ($null -eq $bundleEntry) {
        throw "tools\HoiModBuild.json has no bundle '$Bundle' (a package with members)"
    }
    $packRoot = Join-Path $RepoRoot ('packs\' + $Bundle)
    $descriptorPath = Join-Path $packRoot 'descriptor.mod'
    $displayName = $Bundle
    if (Test-Path -LiteralPath $descriptorPath) {
        $nameMatch = [regex]::Match([System.IO.File]::ReadAllText($descriptorPath, [System.Text.Encoding]::UTF8), '(?m)^\s*name\s*=\s*"([^"]*)"')
        if ($nameMatch.Success) {
            $displayName = $nameMatch.Groups[1].Value
        }
    }
    $introPath = Join-Path $RepoRoot ('source\' + $Bundle + '\workshop-intro.bbcode')
    $memberNames = @($bundleEntry.Value.members | ForEach-Object { [string]$_ })
    return [PSCustomObject]@{
        Name          = $Bundle
        IsBundle      = $true
        RepoRoot      = $RepoRoot
        PackRoot      = $packRoot
        SourceDir     = Join-Path $RepoRoot ('source\' + $Bundle)
        DisplayName   = $displayName
        Members       = $memberNames
        MemberPacks   = @($memberNames | Where-Object { @(Get-EpPackNames -RepoRoot $RepoRoot) -contains $_ } | ForEach-Object { Get-EpPack -RepoRoot $RepoRoot -Pack $_ })
        WorkshopIntro = $(if (Test-Path -LiteralPath $introPath) { [System.IO.File]::ReadAllText($introPath, [System.Text.Encoding]::UTF8).Trim() } else { '' })
    }
}

function Get-EpPack {
    param(
        [Parameter(Mandatory = $true)][string]$RepoRoot,
        [Parameter(Mandatory = $true)][string]$Pack
    )

    $RepoRoot = (Get-Item -LiteralPath $RepoRoot).FullName.TrimEnd('\')
    $sourceDir = Join-Path $RepoRoot ('source\' + $Pack)
    $eventsPath = Join-Path $sourceDir 'events.json'
    if (-not (Test-Path -LiteralPath $eventsPath)) {
        throw "source\$Pack\events.json not found: create the pack with build.ps1 -NewPack"
    }
    $eventSource = Read-EpJson -Path $eventsPath
    $picturesPath = Join-Path $sourceDir 'pictures.json'
    $pictures = @()
    if (Test-Path -LiteralPath $picturesPath) {
        $pictures = @(ConvertTo-EpArray (Get-EpProperty -Object (Read-EpJson -Path $picturesPath) -Name 'pictures'))
    }
    $factSheetPath = Join-Path $sourceDir 'fact-sheets.md'
    $introPath = Join-Path $sourceDir 'workshop-intro.bbcode'
    $namespace = [string](Get-EpProperty -Object $eventSource -Name 'namespace' -Default '')
    return [PSCustomObject]@{
        Name           = $Pack
        RepoRoot       = $RepoRoot
        SourceDir      = $sourceDir
        PackRoot       = Join-Path $RepoRoot ('packs\' + $Pack)
        CacheDir       = Join-Path $RepoRoot ('sources-cache\' + $Pack)
        Tag            = [string](Get-EpProperty -Object $eventSource -Name 'tag' -Default '')
        Namespace      = $namespace
        DisplayName    = [string](Get-EpProperty -Object $eventSource -Name 'displayName' -Default $Pack)
        FactQuotesFromId = Get-EpProperty -Object $eventSource -Name 'factQuotesFromId'
        Events         = @(ConvertTo-EpArray (Get-EpProperty -Object $eventSource -Name 'events'))
        Ideas          = @(ConvertTo-EpArray (Get-EpProperty -Object $eventSource -Name 'ideas'))
        Pictures       = $pictures
        FactSheetText  = $(if (Test-Path -LiteralPath $factSheetPath) { [System.IO.File]::ReadAllText($factSheetPath, [System.Text.Encoding]::UTF8) } else { '' })
        WorkshopIntro  = $(if (Test-Path -LiteralPath $introPath) { [System.IO.File]::ReadAllText($introPath, [System.Text.Encoding]::UTF8).Trim() } else { '' })
        Workshop       = Read-EpJson -Path (Join-Path $RepoRoot 'data\workshop.json')
    }
}

function Get-EpWikiPageName {
    param($Pack)

    return 'Event-Pack-' + ($Pack.DisplayName -replace '\s+', '-')
}

function Get-EpCaps {
    param([Parameter(Mandatory = $true)][string]$RepoRoot)

    return (Read-EpJson -Path (Join-Path $RepoRoot 'data\effect-caps.json'))
}

function Get-EpPictureSprite {
    param($Pack, [string]$PictureKey)

    if ($PictureKey -like 'vanilla:*') {
        return $PictureKey.Substring(8)
    }
    return 'GFX_' + $Pack.Namespace + '_' + $PictureKey
}

function Get-EpPictureRelativePath {
    param($Pack, [string]$PictureKey)

    return 'gfx/event_pictures/' + $Pack.Namespace + '/' + $Pack.Namespace + '_' + $PictureKey + '.dds'
}

function Get-EpOptionLetter {
    param([int]$Index)

    return [string][char](97 + $Index)
}

# The source key of each plain number effect and the effect it writes; popularity and timed_idea take a second field.
function Get-EpEffectCommands {
    return [ordered]@{
        stability       = 'add_stability'
        war_support     = 'add_war_support'
        political_power = 'add_political_power'
        army_experience = 'army_experience'
        navy_experience = 'navy_experience'
        air_experience  = 'air_experience'
        command_power   = 'add_command_power'
        manpower        = 'add_manpower'
    }
}

function Get-EpEffectLines {
    param($Pack, $Effect)

    $effectLines = [System.Collections.Generic.List[string]]::new()
    $effectCommands = Get-EpEffectCommands
    foreach ($effectName in $effectCommands.Keys) {
        $effectValue = Get-EpProperty -Object $Effect -Name $effectName
        if ($null -ne $effectValue) {
            $effectLines.Add($effectCommands[$effectName] + ' = ' + (Format-EpNumber $effectValue))
        }
    }
    $popularityValue = Get-EpProperty -Object $Effect -Name 'popularity'
    if ($null -ne $popularityValue) {
        $effectLines.Add('add_popularity = { ideology = ' + (Get-EpProperty -Object $Effect -Name 'ideology') + ' popularity = ' + (Format-EpNumber $popularityValue) + ' }')
    }
    $timedIdea = Get-EpProperty -Object $Effect -Name 'timed_idea'
    if ($null -ne $timedIdea) {
        $effectLines.Add('add_timed_idea = { idea = ' + $Pack.Namespace + '_' + $timedIdea + ' days = ' + (Format-EpNumber (Get-EpProperty -Object $Effect -Name 'days' -Default 180)) + ' }')
    }
    return , $effectLines
}

function Add-EpIndentedBlock {
    param(
        [Parameter(Mandatory = $true)]$Lines,
        [AllowEmptyString()][string]$Text,
        [Parameter(Mandatory = $true)][string]$Indent
    )

    foreach ($textLine in @(([string]$Text) -split "\r?\n")) {
        if ($textLine.Trim()) {
            $Lines.Add($Indent + $textLine.Trim())
        }
    }
}

function ConvertTo-EpLocalisationText {
    param([AllowEmptyString()][string]$Text)

    return (([string]$Text).Trim() -replace "\r?\n", '\n')
}

function New-EpEventsText {
    param($Pack)

    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add('add_namespace = ' + $Pack.Namespace)
    foreach ($packEvent in @($Pack.Events | Sort-Object { [int]$_.id })) {
        $eventId = $Pack.Namespace + '.' + [int]$packEvent.id
        $lines.Add('')
        $lines.Add('country_event = {')
        $lines.Add("`tid = $eventId")
        $lines.Add("`ttitle = $eventId.t")
        $lines.Add("`tdesc = $eventId.desc")
        $lines.Add("`tpicture = " + (Get-EpPictureSprite -Pack $Pack -PictureKey ([string]$packEvent.picture)))
        $lines.Add("`tis_triggered_only = yes")
        $options = @(ConvertTo-EpArray $packEvent.options)
        for ($optionIndex = 0; $optionIndex -lt $options.Count; $optionIndex++) {
            $option = $options[$optionIndex]
            $lines.Add('')
            $lines.Add("`toption = {")
            $lines.Add("`t`tname = $eventId." + (Get-EpOptionLetter -Index $optionIndex))
            $lines.Add("`t`tai_chance = { factor = " + (Format-EpNumber (Get-EpProperty -Object $option -Name 'ai' -Default 50)) + ' }')
            foreach ($effect in (ConvertTo-EpArray (Get-EpProperty -Object $option -Name 'effects'))) {
                foreach ($effectLine in (Get-EpEffectLines -Pack $Pack -Effect $effect)) {
                    $lines.Add("`t`t" + $effectLine)
                }
            }
            $lines.Add("`t}")
        }
        $lines.Add('}')
    }
    return (($lines -join "`r`n") + "`r`n")
}

function New-EpOnActionsText {
    param($Pack)

    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add('on_actions = {')
    $lines.Add("`ton_weekly_" + $Pack.Tag + ' = {')
    $lines.Add("`t`teffect = {")
    foreach ($packEvent in @($Pack.Events | Sort-Object { [int]$_.id })) {
        $eventNumber = [int]$packEvent.id
        $guardFlag = $Pack.Namespace + '_fired_' + $eventNumber
        $fire = Get-EpProperty -Object $packEvent -Name 'fire'
        $lines.Add("`t`t`tif = {")
        $lines.Add("`t`t`t`tlimit = {")
        $lines.Add("`t`t`t`t`tNOT = { has_country_flag = $guardFlag }")
        $afterDate = [string](Get-EpProperty -Object $fire -Name 'after' -Default '')
        $beforeDate = [string](Get-EpProperty -Object $fire -Name 'before' -Default '')
        if ($afterDate) {
            $lines.Add("`t`t`t`t`tdate > $afterDate")
        }
        if ($beforeDate) {
            $lines.Add("`t`t`t`t`tdate < $beforeDate")
        }
        Add-EpIndentedBlock -Lines $lines -Text ([string](Get-EpProperty -Object $fire -Name 'trigger' -Default '')) -Indent "`t`t`t`t`t"
        $lines.Add("`t`t`t`t}")
        $lines.Add("`t`t`t`trandom = {")
        $lines.Add("`t`t`t`t`tchance = " + (Format-EpNumber (Get-EpProperty -Object $fire -Name 'chance' -Default 10)))
        $lines.Add("`t`t`t`t`tset_country_flag = $guardFlag")
        $lines.Add("`t`t`t`t`tcountry_event = { id = " + $Pack.Namespace + '.' + $eventNumber + ' }')
        $lines.Add("`t`t`t`t}")
        $lines.Add("`t`t`t}")
    }
    $lines.Add("`t`t}")
    $lines.Add("`t}")
    $lines.Add('}')
    return (($lines -join "`r`n") + "`r`n")
}

function New-EpIdeasText {
    param($Pack)

    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add('ideas = {')
    $lines.Add("`tcountry = {")
    foreach ($idea in $Pack.Ideas) {
        $lines.Add("`t`t" + $Pack.Namespace + '_' + $idea.key + ' = {')
        $lines.Add("`t`t`tremoval_cost = -1")
        $lines.Add("`t`t`tpicture = " + (Get-EpProperty -Object $idea -Name 'picture' -Default 'generic_morale_bonus'))
        $lines.Add("`t`t`tallowed = { always = no }")
        $lines.Add("`t`t`tallowed_civil_war = { always = no }")
        $lines.Add("`t`t`tmodifier = {")
        $modifier = Get-EpProperty -Object $idea -Name 'modifier'
        if ($null -ne $modifier) {
            foreach ($modifierProperty in $modifier.PSObject.Properties) {
                $lines.Add("`t`t`t`t" + $modifierProperty.Name + ' = ' + (Format-EpNumber $modifierProperty.Value))
            }
        }
        $lines.Add("`t`t`t}")
        $lines.Add("`t`t}")
    }
    $lines.Add("`t}")
    $lines.Add('}')
    return (($lines -join "`r`n") + "`r`n")
}

function Get-EpUsedPictureKeys {
    param($Pack)

    return @($Pack.Events | ForEach-Object { [string]$_.picture } | Where-Object { $_ -and $_ -notlike 'vanilla:*' } | Sort-Object -Unique)
}

function New-EpSpritesText {
    param($Pack)

    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add('spriteTypes = {')
    foreach ($pictureKey in (Get-EpUsedPictureKeys -Pack $Pack)) {
        $lines.Add("`tspriteType = {")
        $lines.Add("`t`tname = `"" + (Get-EpPictureSprite -Pack $Pack -PictureKey $pictureKey) + '"')
        $lines.Add("`t`ttexturefile = `"" + (Get-EpPictureRelativePath -Pack $Pack -PictureKey $pictureKey) + '"')
        $lines.Add("`t}")
    }
    $lines.Add('}')
    return (($lines -join "`r`n") + "`r`n")
}

function New-EpLocalisationText {
    param($Pack, [Parameter(Mandatory = $true)][string]$Language)

    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add('l_' + $Language + ':')
    foreach ($packEvent in @($Pack.Events | Sort-Object { [int]$_.id })) {
        $eventId = $Pack.Namespace + '.' + [int]$packEvent.id
        $lines.Add(' ' + $eventId + '.t:0 "' + (ConvertTo-EpLocalisationText $packEvent.title) + '"')
        $lines.Add(' ' + $eventId + '.desc:0 "' + (ConvertTo-EpLocalisationText $packEvent.desc) + '"')
        $options = @(ConvertTo-EpArray $packEvent.options)
        for ($optionIndex = 0; $optionIndex -lt $options.Count; $optionIndex++) {
            $lines.Add(' ' + $eventId + '.' + (Get-EpOptionLetter -Index $optionIndex) + ':0 "' + (ConvertTo-EpLocalisationText $options[$optionIndex].name) + '"')
        }
    }
    foreach ($idea in $Pack.Ideas) {
        $ideaId = $Pack.Namespace + '_' + $idea.key
        $lines.Add(' ' + $ideaId + ':0 "' + (ConvertTo-EpLocalisationText $idea.name) + '"')
        $lines.Add(' ' + $ideaId + '_desc:0 "' + (ConvertTo-EpLocalisationText $idea.desc) + '"')
    }
    return (($lines -join "`r`n") + "`r`n")
}

function Get-EpLicenceLabel {
    param($Picture)

    $category = [string](Get-EpProperty -Object $Picture -Name 'licenseCategory' -Default '')
    if ($category -eq 'PD') {
        $publicDomainReason = [string](Get-EpProperty -Object $Picture -Name 'publicDomainReason' -Default '')
        if ($publicDomainReason) {
            return 'Public domain (' + $publicDomainReason + ')'
        }
        return 'Public domain'
    }
    return [string](Get-EpProperty -Object $Picture -Name 'licenseShortName' -Default $category)
}

function Get-EpEventYear {
    param($PackEvent)

    $afterDate = [string](Get-EpProperty -Object (Get-EpProperty -Object $PackEvent -Name 'fire') -Name 'after' -Default '')
    if ($afterDate -match '^(\d{4})') {
        return $Matches[1]
    }
    return '-'
}

function Get-EpEventSortKey {
    param($PackEvent)

    $afterDate = [string](Get-EpProperty -Object (Get-EpProperty -Object $PackEvent -Name 'fire') -Name 'after' -Default '')
    if ($afterDate -match '^(\d{4})\.(\d{1,2})\.(\d{1,2})') {
        return ([int]$Matches[1] * 10000) + ([int]$Matches[2] * 100) + [int]$Matches[3]
    }
    return [int]::MaxValue
}

function Get-EpPictureByKey {
    param($Pack, [string]$PictureKey)

    return @($Pack.Pictures | Where-Object { $_.key -eq $PictureKey }) | Select-Object -First 1
}

function Get-EpCarriedCrossLinkLines {
    param($Pack)

    $descriptionPath = Join-Path $Pack.PackRoot 'WORKSHOP_DESCRIPTION_GUIDELINES.md'
    if (-not (Test-Path -LiteralPath $descriptionPath -PathType Leaf)) {
        return @()
    }
    $existingLines = @([regex]::Split([System.IO.File]::ReadAllText($descriptionPath, [System.Text.Encoding]::UTF8), '\r?\n'))
    $trimmedLines = @($existingLines | ForEach-Object { $_.Trim() })
    $beginIndex = [array]::IndexOf($trimmedLines, '<!-- cross-links:begin -->')
    $endIndex = [array]::IndexOf($trimmedLines, '<!-- cross-links:end -->')
    if ($beginIndex -lt 0 -or $endIndex - $beginIndex -le 1) {
        return @()
    }
    return @($existingLines[($beginIndex + 1)..($endIndex - 1)])
}

function Get-EpCarriedRegionContents {
    param($Pack)

    $carriedContents = @{}
    $descriptionPath = Join-Path $Pack.PackRoot 'WORKSHOP_DESCRIPTION_GUIDELINES.md'
    if (-not (Test-Path -LiteralPath $descriptionPath -PathType Leaf)) {
        return $carriedContents
    }
    $openHeader = $null
    $openLines = $null
    foreach ($existingLine in @([regex]::Split([System.IO.File]::ReadAllText($descriptionPath, [System.Text.Encoding]::UTF8), '\r?\n'))) {
        $trimmedLine = $existingLine.Trim()
        if ($trimmedLine -match '^<!-- region:[a-z]+:[A-Za-z0-9._,-]+ -->$') {
            $openHeader = $trimmedLine
            $openLines = [System.Collections.Generic.List[string]]::new()
        } elseif ($trimmedLine -eq '<!-- /region -->') {
            if ($openHeader) {
                $carriedContents[$openHeader] = @($openLines)
            }
            $openHeader = $null
        } elseif ($openHeader) {
            $openLines.Add($existingLine)
        }
    }
    return $carriedContents
}

function Add-EpRegion {
    param($Lines, [string]$Header)

    $Lines.Add($Header)
    $Lines.Add('<!-- /region -->')
}

function Set-EpCarriedRegionContents {
    param($Lines, $CarriedContents)

    $filledLines = [System.Collections.Generic.List[string]]::new()
    $insideRegion = $false
    foreach ($bbcodeLine in @($Lines)) {
        $trimmedLine = $bbcodeLine.Trim()
        if ($insideRegion) {
            if ($trimmedLine -eq '<!-- /region -->') {
                $insideRegion = $false
                $filledLines.Add($bbcodeLine)
            }
            continue
        }
        $filledLines.Add($bbcodeLine)
        if ($trimmedLine -match '^<!-- region:[a-z]+:[A-Za-z0-9._,-]+ -->$') {
            $insideRegion = $true
            if ($CarriedContents.ContainsKey($trimmedLine)) {
                foreach ($carriedLine in @($CarriedContents[$trimmedLine])) {
                    $filledLines.Add($carriedLine)
                }
            }
        }
    }
    return @($filledLines)
}

function New-EpWorkshopText {
    param($Pack)

    $bbcodeLines = [System.Collections.Generic.List[string]]::new()
    if ($Pack.WorkshopIntro) {
        $bbcodeLines.Add($Pack.WorkshopIntro)
        $bbcodeLines.Add('')
    }
    Add-EpRegion -Lines $bbcodeLines -Header '<!-- region:image:strip-events -->'
    $bbcodeLines.Add('[h1]Events[/h1]')
    Add-EpRegion -Lines $bbcodeLines -Header '<!-- region:image:overview -->'
    $bbcodeLines.Add('[list]')
    foreach ($packEvent in @($Pack.Events | Sort-Object { Get-EpEventSortKey -PackEvent $_ }, { [int]$_.id })) {
        $bbcodeLines.Add('[*]' + (Get-EpEventYear -PackEvent $packEvent) + ': ' + $packEvent.title)
    }
    $bbcodeLines.Add('[/list]')
    $usedPictures = @(Get-EpUsedPictureKeys -Pack $Pack | ForEach-Object { Get-EpPictureByKey -Pack $Pack -PictureKey $_ } | Where-Object { $null -ne $_ })
    if ($usedPictures.Count -gt 0) {
        $licenceNames = @($usedPictures | ForEach-Object { ([string]$_.licenseShortName) -replace '^Public domain$', 'public domain' } | Sort-Object -Unique -Descending)
        if ($licenceNames.Count -gt 1) {
            $licenceNames = @((($licenceNames[0..($licenceNames.Count - 2)]) -join ', ') + ' and ' + $licenceNames[-1])
        }
        $bbcodeLines.Add('')
        Add-EpRegion -Lines $bbcodeLines -Header '<!-- region:image:strip-picture-credits -->'
        $bbcodeLines.Add('[h1]Picture credits[/h1]')
        $bbcodeLines.Add('The pictures come from Wikimedia Commons, under licences that allow their use here (' + ($licenceNames -join ', ') + '). They are cropped, resized and converted for the game; some are toned to grey or sepia.')
    }
    $bbcodeLines.Add('')
    $bbcodeLines.Add('<!-- cross-links:begin -->')
    foreach ($crossLinkLine in @(Get-EpCarriedCrossLinkLines -Pack $Pack)) {
        $bbcodeLines.Add($crossLinkLine)
    }
    $bbcodeLines.Add('<!-- cross-links:end -->')

    $flatBbcodeLines = @(([string]::Join("`n", @($bbcodeLines))) -split '\r?\n')
    $filledBbcodeLines = @(Set-EpCarriedRegionContents -Lines $flatBbcodeLines -CarriedContents (Get-EpCarriedRegionContents -Pack $Pack))

    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add('# Event Pack: ' + $Pack.DisplayName + ' - Workshop description')
    $lines.Add('')
    $lines.Add('Generated by `build.ps1 -Generate` from `source/' + $Pack.Name + '/workshop-intro.bbcode`, `events.json` and `pictures.json`. Do not edit this file: change the sources and generate again. The lines between the cross-links markers are written by `Scripts/Workshop/Sync-WorkshopCrossLinks.ps1` of the Modding Manager, and those between the region markers by `Scripts/Workshop/Sync-WorkshopRegions.ps1`; `-Generate` keeps both.')
    $lines.Add('')
    $lines.Add('```bbcode')
    foreach ($bbcodeLine in $filledBbcodeLines) {
        $lines.Add($bbcodeLine)
    }
    $lines.Add('```')
    return (($lines -join "`r`n") + "`r`n")
}

function New-EpBundleWorkshopText {
    param($Bundle)

    $bbcodeLines = [System.Collections.Generic.List[string]]::new()
    if ($Bundle.WorkshopIntro) {
        $bbcodeLines.Add($Bundle.WorkshopIntro)
        $bbcodeLines.Add('')
    }
    Add-EpRegion -Lines $bbcodeLines -Header '<!-- region:image:strip-countries -->'
    $bbcodeLines.Add('[h1]Countries[/h1]')
    $bbcodeLines.Add('[list]')
    foreach ($memberPack in @($Bundle.MemberPacks)) {
        $eventCount = @($memberPack.Events).Count
        $bbcodeLines.Add('[*]' + $memberPack.DisplayName + ': ' + $eventCount + $(if ($eventCount -eq 1) { ' event' } else { ' events' }))
    }
    $bbcodeLines.Add('[/list]')
    $bbcodeLines.Add('')
    $bbcodeLines.Add('<!-- cross-links:begin -->')
    foreach ($crossLinkLine in @(Get-EpCarriedCrossLinkLines -Pack $Bundle)) {
        $bbcodeLines.Add($crossLinkLine)
    }
    $bbcodeLines.Add('<!-- cross-links:end -->')

    $flatBbcodeLines = @(([string]::Join("`n", @($bbcodeLines))) -split '\r?\n')
    $filledBbcodeLines = @(Set-EpCarriedRegionContents -Lines $flatBbcodeLines -CarriedContents (Get-EpCarriedRegionContents -Pack $Bundle))

    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add('# ' + $Bundle.DisplayName + ' - Workshop description')
    $lines.Add('')
    $lines.Add('Generated by `build.ps1 -Generate` from `source/' + $Bundle.Name + '/workshop-intro.bbcode` and the events of its members. Do not edit this file: change the sources and generate again. The lines between the cross-links markers are written by `Scripts/Workshop/Sync-WorkshopCrossLinks.ps1` of the Modding Manager, and those between the region markers by `Scripts/Workshop/Sync-WorkshopRegions.ps1`; `-Generate` keeps both.')
    $lines.Add('')
    $lines.Add('```bbcode')
    foreach ($bbcodeLine in $filledBbcodeLines) {
        $lines.Add($bbcodeLine)
    }
    $lines.Add('```')
    return (($lines -join "`r`n") + "`r`n")
}

function Get-EpBundleGeneratedFiles {
    param($Bundle)

    $generatedFiles = [ordered]@{}
    $generatedFiles['packs/' + $Bundle.Name + '/WORKSHOP_DESCRIPTION_GUIDELINES.md'] = @{ Text = (New-EpBundleWorkshopText -Bundle $Bundle); Bom = $false }
    return $generatedFiles
}

function Get-EpBundleDelta {
    param($Bundle)

    $generatedFiles = Get-EpBundleGeneratedFiles -Bundle $Bundle
    $changedPaths = [System.Collections.Generic.List[string]]::new()
    foreach ($relativePath in @($generatedFiles.Keys)) {
        $fullPath = Join-Path $Bundle.RepoRoot $relativePath
        $expectedBytes = [byte[]]@((Get-EpUtf8 -Bom:$generatedFiles[$relativePath].Bom).GetPreamble()) + (Get-EpUtf8).GetBytes($generatedFiles[$relativePath].Text)
        if (-not (Test-Path -LiteralPath $fullPath) -or [System.Convert]::ToBase64String($expectedBytes) -cne [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($fullPath))) {
            $changedPaths.Add($relativePath)
        }
    }
    return [PSCustomObject]@{ Files = $generatedFiles; Changed = $changedPaths }
}

function Invoke-EpGenerateBundle {
    param(
        [Parameter(Mandatory = $true)][string]$RepoRoot,
        [Parameter(Mandatory = $true)][string]$Bundle,
        [switch]$DryRun
    )

    $bundleData = Get-EpBundle -RepoRoot $RepoRoot -Bundle $Bundle
    $delta = Get-EpBundleDelta -Bundle $bundleData
    foreach ($changedPath in $delta.Changed) {
        if ($DryRun) {
            Write-Host "  would write $changedPath" -ForegroundColor Gray
        } else {
            Write-EpText -Path (Join-Path $RepoRoot $changedPath) -Text $delta.Files[$changedPath].Text -Bom:$delta.Files[$changedPath].Bom
            Write-Host "  wrote $changedPath" -ForegroundColor Gray
        }
    }
    $verb = if ($DryRun) { 'to write' } else { 'written' }
    Write-Host "Bundle '$Bundle': $(@($bundleData.Members).Count) member(s), $($delta.Changed.Count) file(s) $verb." -ForegroundColor Green
    return 0
}

function Test-EpBundle {
    param(
        [Parameter(Mandatory = $true)][string]$RepoRoot,
        [Parameter(Mandatory = $true)][string]$Bundle
    )

    $problems = [System.Collections.Generic.List[PSObject]]::new()
    $bundleData = Get-EpBundle -RepoRoot $RepoRoot -Bundle $Bundle
    foreach ($packName in @(Get-EpPackNames -RepoRoot $RepoRoot)) {
        if ($bundleData.Members -notcontains $packName) {
            $problems.Add((New-EpProblem -Level 'ERROR' -Where 'tools/HoiModBuild.json' -Message "pack '$packName' is not a member of bundle '$Bundle': add it to the members list, or its release would leave it out of the bundle"))
        }
    }
    foreach ($memberName in $bundleData.Members) {
        if (@(Get-EpPackNames -RepoRoot $RepoRoot) -notcontains $memberName) {
            $problems.Add((New-EpProblem -Level 'ERROR' -Where 'tools/HoiModBuild.json' -Message "member '$memberName' of bundle '$Bundle' is not an event pack"))
        }
    }
    $bundleVersion = [regex]::Match([System.IO.File]::ReadAllText((Join-Path $bundleData.PackRoot 'descriptor.mod'), [System.Text.Encoding]::UTF8), '(?m)^\s*supported_version\s*=\s*"([^"]*)"').Groups[1].Value
    foreach ($memberName in $bundleData.Members) {
        $memberDescriptorPath = Join-Path $RepoRoot ('packs\' + $memberName + '\descriptor.mod')
        if (Test-Path -LiteralPath $memberDescriptorPath) {
            $memberVersion = [regex]::Match([System.IO.File]::ReadAllText($memberDescriptorPath, [System.Text.Encoding]::UTF8), '(?m)^\s*supported_version\s*=\s*"([^"]*)"').Groups[1].Value
            if ($memberVersion -ne $bundleVersion) {
                $problems.Add((New-EpProblem -Level 'ERROR' -Where "packs/$Bundle/descriptor.mod" -Message "supported_version '$bundleVersion' differs from '$memberVersion' of member '$memberName'"))
            }
        }
    }
    foreach ($memberPack in @($bundleData.MemberPacks)) {
        if ($bundleData.WorkshopIntro -notlike ('*' + $memberPack.DisplayName + '*')) {
            $problems.Add((New-EpProblem -Level 'ERROR' -Where "source/$Bundle/workshop-intro.bbcode" -Message "the intro does not name '$($memberPack.DisplayName)', a member of the bundle"))
        }
    }
    $delta = Get-EpBundleDelta -Bundle $bundleData
    foreach ($changedPath in $delta.Changed) {
        $problems.Add((New-EpProblem -Level 'ERROR' -Where $changedPath -Message 'differs from what the source generates: run build.ps1 -Generate (never edit it by hand)'))
    }
    $knownBundleFiles = @('descriptor.mod', 'thumbnail.png', 'WORKSHOP_DESCRIPTION_GUIDELINES.md')
    if (Test-Path -LiteralPath $bundleData.PackRoot) {
        foreach ($bundleFile in @(Get-ChildItem -LiteralPath $bundleData.PackRoot -Recurse -File -Force)) {
            $relativePath = $bundleFile.FullName.Substring($bundleData.PackRoot.Length + 1).Replace('\', '/')
            if ($knownBundleFiles -notcontains $relativePath) {
                $problems.Add((New-EpProblem -Level 'ERROR' -Where "packs/$Bundle/$relativePath" -Message 'a bundle holds only its descriptor, thumbnail and description: its content comes from the members at build time'))
            }
        }
    }
    return $problems.ToArray()
}

function New-EpWikiText {
    param($Pack)

    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add('# Event Pack: ' + $Pack.DisplayName)
    $lines.Add('')
    $lines.Add('Generated by `build.ps1 -Generate` from `source/' + $Pack.Name + '/`. Do not edit: change the sources and generate again.')
    $lines.Add('')
    $lines.Add('The pictures come from Wikimedia Commons. They are cropped, resized and converted for the game; some are toned to grey or sepia. The Licence column names each picture''s licence and author.')
    $lines.Add('')
    $lines.Add('| Event | Title | Fires | Picture | Licence |')
    $lines.Add('|---|---|---|---|---|')
    foreach ($packEvent in @($Pack.Events | Sort-Object { [int]$_.id })) {
        $fire = Get-EpProperty -Object $packEvent -Name 'fire'
        $window = ([string](Get-EpProperty -Object $fire -Name 'after' -Default '')) + ' to ' + ([string](Get-EpProperty -Object $fire -Name 'before' -Default ''))
        $pictureCell = [string]$packEvent.picture
        $licenceCell = 'vanilla'
        $picture = Get-EpPictureByKey -Pack $Pack -PictureKey ([string]$packEvent.picture)
        if ($null -ne $picture) {
            $pictureCell = '[' + ($picture.commonsTitle -replace '^File:', '') + '](' + $picture.pageUrl + ')'
            $licenceCell = Get-EpLicenceLabel -Picture $picture
            if ($picture.licenseCategory -eq 'CC BY' -and $picture.licenseUrl) {
                $licenceCell = '[' + $licenceCell + '](' + $picture.licenseUrl + ')'
            }
            if ($picture.author) {
                $licenceCell += ', ' + $picture.author
            }
        }
        $lines.Add('| `' + $Pack.Namespace + '.' + [int]$packEvent.id + '` | ' + $packEvent.title + ' | ' + $window + ' | ' + $pictureCell + ' | ' + $licenceCell + ' |')
    }
    return (($lines -join "`r`n") + "`r`n")
}

function Get-EpGeneratedFiles {
    param($Pack)

    $generatedFiles = [ordered]@{}
    $packPrefix = 'packs/' + $Pack.Name + '/'
    $generatedFiles[$packPrefix + 'events/' + $Pack.Namespace + '_events.txt'] = @{ Text = (New-EpEventsText -Pack $Pack); Bom = $false }
    $generatedFiles[$packPrefix + 'common/on_actions/' + $Pack.Namespace + '_on_actions.txt'] = @{ Text = (New-EpOnActionsText -Pack $Pack); Bom = $false }
    if ($Pack.Ideas.Count -gt 0) {
        $generatedFiles[$packPrefix + 'common/ideas/' + $Pack.Namespace + '_ideas.txt'] = @{ Text = (New-EpIdeasText -Pack $Pack); Bom = $false }
    }
    if (@(Get-EpUsedPictureKeys -Pack $Pack).Count -gt 0) {
        $generatedFiles[$packPrefix + 'interface/' + $Pack.Namespace + '_event_pictures.gfx'] = @{ Text = (New-EpSpritesText -Pack $Pack); Bom = $false }
    }
    foreach ($language in (Get-EpLanguages)) {
        $generatedFiles[$packPrefix + 'localisation/' + $language + '/' + $Pack.Namespace + '_l_' + $language + '.yml'] = @{ Text = (New-EpLocalisationText -Pack $Pack -Language $language); Bom = $true }
    }
    $generatedFiles[$packPrefix + 'WORKSHOP_DESCRIPTION_GUIDELINES.md'] = @{ Text = (New-EpWorkshopText -Pack $Pack); Bom = $false }
    $generatedFiles['wiki/' + (Get-EpWikiPageName -Pack $Pack) + '.md'] = @{ Text = (New-EpWikiText -Pack $Pack); Bom = $false }
    return $generatedFiles
}

function Get-EpManagedFiles {
    param($Pack)

    $packRoot = $Pack.PackRoot
    $managedFiles = [System.Collections.Generic.List[string]]::new()
    foreach ($managedFolder in @('events', 'common\on_actions', 'common\ideas', 'interface', 'localisation')) {
        $folderPath = Join-Path $packRoot $managedFolder
        if (Test-Path -LiteralPath $folderPath) {
            foreach ($managedFile in @(Get-ChildItem -LiteralPath $folderPath -Recurse -File)) {
                $managedFiles.Add(('packs/' + $Pack.Name + '/' + $managedFile.FullName.Substring($packRoot.Length + 1)).Replace('\', '/'))
            }
        }
    }
    return , $managedFiles
}

function Get-EpGenerationDelta {
    param($Pack)

    $generatedFiles = Get-EpGeneratedFiles -Pack $Pack
    $changedPaths = [System.Collections.Generic.List[string]]::new()
    $stalePaths = [System.Collections.Generic.List[string]]::new()
    foreach ($relativePath in @($generatedFiles.Keys)) {
        $fullPath = Join-Path $Pack.RepoRoot $relativePath
        $expected = $generatedFiles[$relativePath]
        if (-not (Test-Path -LiteralPath $fullPath)) {
            $changedPaths.Add($relativePath)
            continue
        }
        $expectedBytes = [byte[]]@((Get-EpUtf8 -Bom:$expected.Bom).GetPreamble()) + (Get-EpUtf8).GetBytes($expected.Text)
        $actualBytes = [System.IO.File]::ReadAllBytes($fullPath)
        if ([System.Convert]::ToBase64String($expectedBytes) -cne [System.Convert]::ToBase64String($actualBytes)) {
            $changedPaths.Add($relativePath)
        }
    }
    foreach ($managedPath in (Get-EpManagedFiles -Pack $Pack)) {
        if (-not $generatedFiles.Contains($managedPath)) {
            $stalePaths.Add($managedPath)
        }
    }
    return [PSCustomObject]@{ Files = $generatedFiles; Changed = $changedPaths; Stale = $stalePaths }
}

function Invoke-EpGenerate {
    param(
        [Parameter(Mandatory = $true)][string]$RepoRoot,
        [Parameter(Mandatory = $true)][string]$Pack,
        [switch]$DryRun
    )

    if (@(Get-EpBundleNames -RepoRoot $RepoRoot) -contains $Pack) {
        return (Invoke-EpGenerateBundle -RepoRoot $RepoRoot -Bundle $Pack -DryRun:$DryRun)
    }
    $packData = Get-EpPack -RepoRoot $RepoRoot -Pack $Pack
    $problems = @(Test-EpPackSource -Pack $packData)
    $errors = @($problems | Where-Object { $_.Level -eq 'ERROR' })
    Write-EpProblems -Problems $problems
    if ($errors.Count -gt 0) {
        Write-Host "Generate refused: $($errors.Count) error(s) in source\$Pack." -ForegroundColor Red
        return 1
    }
    $delta = Get-EpGenerationDelta -Pack $packData
    if ($DryRun) {
        foreach ($changedPath in $delta.Changed) {
            Write-Host "  would write $changedPath" -ForegroundColor Gray
        }
        foreach ($stalePath in $delta.Stale) {
            Write-Host "  would remove $stalePath" -ForegroundColor Gray
        }
        Write-Host "Dry run OK: $($packData.Events.Count) event(s), $($delta.Changed.Count) file(s) to write, $($delta.Stale.Count) to remove." -ForegroundColor Green
        foreach ($bundleName in @(Get-EpBundleNames -RepoRoot $RepoRoot -Member $Pack)) {
            Invoke-EpGenerateBundle -RepoRoot $RepoRoot -Bundle $bundleName -DryRun | Out-Null
        }
        return 0
    }
    foreach ($changedPath in $delta.Changed) {
        $generatedFile = $delta.Files[$changedPath]
        Write-EpText -Path (Join-Path $RepoRoot $changedPath) -Text $generatedFile.Text -Bom:$generatedFile.Bom
        Write-Host "  wrote $changedPath" -ForegroundColor Gray
    }
    foreach ($stalePath in $delta.Stale) {
        Remove-Item -LiteralPath (Join-Path $RepoRoot $stalePath) -Force
        Write-Host "  removed $stalePath" -ForegroundColor Gray
    }
    Write-Host "Generated pack '$Pack': $($packData.Events.Count) event(s), $($delta.Changed.Count) file(s) written, $($delta.Stale.Count) removed." -ForegroundColor Green
    foreach ($bundleName in @(Get-EpBundleNames -RepoRoot $RepoRoot -Member $Pack)) {
        Invoke-EpGenerateBundle -RepoRoot $RepoRoot -Bundle $bundleName | Out-Null
    }
    return 0
}

function New-EpProblem {
    param([string]$Level, [string]$Where, [string]$Message)

    return [PSCustomObject]@{ Level = $Level; Where = $Where; Message = $Message }
}

function Write-EpProblems {
    param([AllowEmptyCollection()]$Problems)

    foreach ($problem in @($Problems)) {
        $color = if ($problem.Level -eq 'ERROR') { 'Red' } else { 'Yellow' }
        Write-Host ('  [{0}] {1}: {2}' -f $problem.Level, $problem.Where, $problem.Message) -ForegroundColor $color
    }
}

function Get-EpBannedPatterns {
    param([Parameter(Mandatory = $true)][string]$RepoRoot)

    $patterns = [System.Collections.Generic.List[PSObject]]::new()
    foreach ($patternLine in @([System.IO.File]::ReadAllLines((Join-Path $RepoRoot 'data\banned-phrases.txt'), [System.Text.Encoding]::UTF8))) {
        $trimmedLine = $patternLine.Trim()
        if (-not $trimmedLine -or $trimmedLine.StartsWith('#')) {
            continue
        }
        if ($trimmedLine.StartsWith('re:')) {
            $patterns.Add([PSCustomObject]@{ Label = $trimmedLine; Regex = [regex]::new($trimmedLine.Substring(3), 'IgnoreCase') })
        } else {
            $patterns.Add([PSCustomObject]@{ Label = $trimmedLine; Regex = [regex]::new('\b' + [regex]::Escape($trimmedLine) + '\b', 'IgnoreCase') })
        }
    }
    return , $patterns
}

function Get-EpWordCount {
    param([AllowEmptyString()][string]$Text)

    return @([regex]::Matches([string]$Text, "[\p{L}\p{N}][\p{L}\p{N}'\-]*")).Count
}

function Test-EpText {
    param(
        [Parameter(Mandatory = $true)][string]$Where,
        [AllowEmptyString()][string]$Text,
        [Parameter(Mandatory = $true)]$BannedPatterns
    )

    $problems = [System.Collections.Generic.List[PSObject]]::new()
    if (-not ([string]$Text).Trim()) {
        $problems.Add((New-EpProblem -Level 'ERROR' -Where $Where -Message 'empty text'))
        return $problems.ToArray()
    }
    $forbiddenCharacters = Get-EpForbiddenCharacters
    foreach ($forbiddenCharacter in @($forbiddenCharacters.Keys)) {
        if ($Text.Contains($forbiddenCharacter)) {
            $problems.Add((New-EpProblem -Level 'ERROR' -Where $Where -Message ('contains a ' + $forbiddenCharacters[$forbiddenCharacter])))
        }
    }
    foreach ($bannedPattern in $BannedPatterns) {
        $bannedMatch = $bannedPattern.Regex.Match($Text)
        if ($bannedMatch.Success) {
            $problems.Add((New-EpProblem -Level 'ERROR' -Where $Where -Message ("banned phrase '" + $bannedMatch.Value + "' (data/banned-phrases.txt: " + $bannedPattern.Label + ')')))
        }
    }
    return $problems.ToArray()
}

function Get-EpFactQuotesFromId {
    param($Pack)

    $factQuotesFromId = 0
    if ($null -eq $Pack.FactQuotesFromId) {
        return 1
    }
    if (-not [int]::TryParse([string]$Pack.FactQuotesFromId, [ref]$factQuotesFromId) -or $factQuotesFromId -lt 1) {
        return $null
    }
    return $factQuotesFromId
}

function Get-EpFactLines {
    param([AllowEmptyString()][string]$SectionText)

    return @([regex]::Matches([string]$SectionText, '(?m)^-\s.*$') | ForEach-Object { $_.Value.TrimEnd() })
}

function Test-EpQuotedFact {
    param([AllowEmptyString()][string]$FactLine)

    $openQuote = [string][char]0x00AB
    $closeQuote = [string][char]0x00BB
    return ([string]$FactLine -match ('Source:\s*https?://\S+.*\bQuote:\s*' + $openQuote + '[^' + $closeQuote + ']+' + $closeQuote))
}

function Get-EpFactLineStart {
    param([AllowEmptyString()][string]$FactLine)

    $factText = ([string]$FactLine).Substring(1).Trim()
    if ($factText.Length -le 60) {
        return $factText
    }
    return $factText.Substring(0, 60) + '...'
}

function Get-EpImagePolicy {
    return New-HoiImagePolicy -AcceptedCategories @('PD', 'CC0', 'CC BY') -AcceptedSources @('commons') -MinWidth 210 -MinHeight 176 -MinSizeText 'the 210x176 event picture [SPR-028]' -BotName 'EventPacksBot' -ContactUrl 'https://github.com/TheCreepero/event-packs' -FetchCommand 'build.ps1 -FetchPicture' -ItemNounPlural 'pictures'
}

function Get-EpPictureYear {
    param([AllowEmptyCollection()][AllowEmptyString()][string[]]$Texts)

    return Get-HoiPictureYear -Texts $Texts
}

function Test-EpPackSource {
    param($Pack)

    $problems = [System.Collections.Generic.List[PSObject]]::new()
    $rules = Get-EpTextRules
    $caps = Get-EpCaps -RepoRoot $Pack.RepoRoot
    $bannedPatterns = Get-EpBannedPatterns -RepoRoot $Pack.RepoRoot
    $sourceWhere = 'source/' + $Pack.Name
    $factQuotesFromId = Get-EpFactQuotesFromId -Pack $Pack
    if ($null -eq $factQuotesFromId) {
        $problems.Add((New-EpProblem -Level 'ERROR' -Where "$sourceWhere/events.json" -Message "factQuotesFromId '$($Pack.FactQuotesFromId)' must be a whole number from 1"))
        $factQuotesFromId = 1
    }

    if ($Pack.Tag -cnotmatch '^[A-Z][A-Z0-9]{2}$') {
        $problems.Add((New-EpProblem -Level 'ERROR' -Where "$sourceWhere/events.json" -Message "tag '$($Pack.Tag)' is not a country tag"))
    }
    if ($Pack.Namespace -cnotmatch '^ep_[a-z0-9]+$') {
        $problems.Add((New-EpProblem -Level 'ERROR' -Where "$sourceWhere/events.json" -Message "namespace '$($Pack.Namespace)' must be ep_ and lower-case letters or digits"))
    }

    $ideaKeys = @($Pack.Ideas | ForEach-Object { [string]$_.key })
    $seenIds = @{}
    $seenKeys = @{}
    foreach ($packEvent in $Pack.Events) {
        $eventWhere = $Pack.Namespace + '.' + [string]$packEvent.id
        $eventNumber = 0
        if (-not [int]::TryParse([string]$packEvent.id, [ref]$eventNumber) -or $eventNumber -lt 1) {
            $problems.Add((New-EpProblem -Level 'ERROR' -Where $eventWhere -Message 'id must be a whole number from 1'))
        } elseif ($seenIds.ContainsKey($eventNumber)) {
            $problems.Add((New-EpProblem -Level 'ERROR' -Where $eventWhere -Message 'id used twice'))
        }
        $seenIds[$eventNumber] = $true
        $eventKey = [string](Get-EpProperty -Object $packEvent -Name 'key' -Default '')
        if ($eventKey -cnotmatch '^[a-z0-9_]+$') {
            $problems.Add((New-EpProblem -Level 'ERROR' -Where $eventWhere -Message "key '$eventKey' must be lower-case letters, digits and underscores"))
        } elseif ($seenKeys.ContainsKey($eventKey)) {
            $problems.Add((New-EpProblem -Level 'ERROR' -Where $eventWhere -Message "key '$eventKey' used twice"))
        }
        $seenKeys[$eventKey] = $true

        $title = [string](Get-EpProperty -Object $packEvent -Name 'title' -Default '')
        $desc = [string](Get-EpProperty -Object $packEvent -Name 'desc' -Default '')
        foreach ($textProblem in (Test-EpText -Where "$eventWhere title" -Text $title -BannedPatterns $bannedPatterns)) { $problems.Add($textProblem) }
        foreach ($textProblem in (Test-EpText -Where "$eventWhere desc" -Text $desc -BannedPatterns $bannedPatterns)) { $problems.Add($textProblem) }
        if ($title.Length -gt $rules.TitleMaxChars) {
            $problems.Add((New-EpProblem -Level 'ERROR' -Where "$eventWhere title" -Message "$($title.Length) characters, at most $($rules.TitleMaxChars)"))
        }
        $descWords = Get-EpWordCount -Text $desc
        if ($descWords -lt $rules.DescMinWords -or $descWords -gt $rules.DescMaxWords) {
            $problems.Add((New-EpProblem -Level 'ERROR' -Where "$eventWhere desc" -Message "$descWords words, needs $($rules.DescMinWords) to $($rules.DescMaxWords)"))
        }
        if ($desc.Length -gt $rules.DescMaxChars) {
            $problems.Add((New-EpProblem -Level 'ERROR' -Where "$eventWhere desc" -Message "$($desc.Length) characters, the event window shows $($rules.DescMaxChars) [GUW-046]"))
        }

        $anchors = @(ConvertTo-EpArray (Get-EpProperty -Object $packEvent -Name 'anchors') | ForEach-Object { [string]$_ } | Where-Object { $_.Trim() })
        $presentAnchors = @($anchors | Where-Object { $desc.Contains($_) })
        if ($anchors.Count -lt $rules.MinAnchors) {
            $problems.Add((New-EpProblem -Level 'ERROR' -Where $eventWhere -Message "lists $($anchors.Count) anchor(s) from its fact sheet; needs $($rules.MinAnchors)"))
        } elseif ($presentAnchors.Count -lt $rules.MinAnchors) {
            $missingAnchors = @($anchors | Where-Object { -not $desc.Contains($_) })
            $problems.Add((New-EpProblem -Level 'ERROR' -Where "$eventWhere desc" -Message ("uses $($presentAnchors.Count) of its anchors; needs $($rules.MinAnchors). Missing: " + ($missingAnchors -join ', '))))
        }

        $factSheetKey = [string](Get-EpProperty -Object $packEvent -Name 'factSheet' -Default $eventKey)
        $factSheetMatch = [regex]::Match($Pack.FactSheetText, '(?ms)^##\s+' + [regex]::Escape($factSheetKey) + '\s*$(.*?)(?=^##\s|\z)')
        if (-not $factSheetMatch.Success) {
            $problems.Add((New-EpProblem -Level 'ERROR' -Where $eventWhere -Message "no section '## $factSheetKey' in $sourceWhere/fact-sheets.md"))
        } elseif ($factSheetMatch.Groups[1].Value -notmatch 'https?://') {
            $problems.Add((New-EpProblem -Level 'ERROR' -Where $eventWhere -Message "fact sheet '$factSheetKey' cites no source URL"))
        } else {
            $factLines = @(Get-EpFactLines -SectionText $factSheetMatch.Groups[1].Value)
            if ($factLines.Count -eq 0 -and $eventNumber -ge $factQuotesFromId) {
                $problems.Add((New-EpProblem -Level 'ERROR' -Where $eventWhere -Message "fact sheet '$factSheetKey' has no fact lines: one fact per line, each starting '- '"))
            }
            foreach ($factLine in $factLines) {
                if ($factLine -match '\bUNVERIFIED\b') {
                    $problems.Add((New-EpProblem -Level 'ERROR' -Where $eventWhere -Message ("fact sheet '$factSheetKey' holds an UNVERIFIED fact; only facts read on their page belong there: " + (Get-EpFactLineStart -FactLine $factLine))))
                } elseif ($eventNumber -ge $factQuotesFromId -and -not (Test-EpQuotedFact -FactLine $factLine)) {
                    $problems.Add((New-EpProblem -Level 'ERROR' -Where $eventWhere -Message ("fact sheet '$factSheetKey' has a fact without its source and the quote of its page (Source: <URL> (<title>). Quote: <<...>>): " + (Get-EpFactLineStart -FactLine $factLine))))
                }
            }
        }

        $fire = Get-EpProperty -Object $packEvent -Name 'fire'
        $afterDate = [string](Get-EpProperty -Object $fire -Name 'after' -Default '')
        $beforeDate = [string](Get-EpProperty -Object $fire -Name 'before' -Default '')
        foreach ($fireDate in @($afterDate, $beforeDate)) {
            if ($fireDate -and $fireDate -notmatch '^\d{4}\.\d{1,2}\.\d{1,2}$') {
                $problems.Add((New-EpProblem -Level 'ERROR' -Where $eventWhere -Message "date '$fireDate' is not YYYY.M.D"))
            }
        }
        if (-not $afterDate -or -not $beforeDate) {
            $problems.Add((New-EpProblem -Level 'ERROR' -Where $eventWhere -Message 'fire needs an after and a before date'))
        } elseif ($afterDate -match '^\d{4}\.\d{1,2}\.\d{1,2}$' -and $beforeDate -match '^\d{4}\.\d{1,2}\.\d{1,2}$') {
            $afterValue = [datetime]::ParseExact($afterDate, 'yyyy.M.d', [System.Globalization.CultureInfo]::InvariantCulture)
            $beforeValue = [datetime]::ParseExact($beforeDate, 'yyyy.M.d', [System.Globalization.CultureInfo]::InvariantCulture)
            if ($beforeValue -le $afterValue) {
                $problems.Add((New-EpProblem -Level 'ERROR' -Where $eventWhere -Message 'the before date is not after the after date'))
            }
        }
        $chanceValue = [double](Get-EpProperty -Object $fire -Name 'chance' -Default 10)
        if ($chanceValue -lt 1 -or $chanceValue -gt 100) {
            $problems.Add((New-EpProblem -Level 'ERROR' -Where $eventWhere -Message 'chance must be 1 to 100 (percent per week) [SCR-089]'))
        }

        $pictureKey = [string](Get-EpProperty -Object $packEvent -Name 'picture' -Default '')
        if (-not $pictureKey) {
            $problems.Add((New-EpProblem -Level 'ERROR' -Where $eventWhere -Message 'no picture'))
        } elseif ($pictureKey -like 'vanilla:*') {
            if ($pictureKey -notmatch '^vanilla:GFX_report_event_\w+$') {
                $problems.Add((New-EpProblem -Level 'ERROR' -Where $eventWhere -Message "'$pictureKey' is not a vanilla event picture sprite [SPR-028]"))
            }
        } elseif ($null -eq (Get-EpPictureByKey -Pack $Pack -PictureKey $pictureKey)) {
            $problems.Add((New-EpProblem -Level 'ERROR' -Where $eventWhere -Message "picture '$pictureKey' is not in $sourceWhere/pictures.json: fetch it with build.ps1 -FetchPicture"))
        }

        $options = @(ConvertTo-EpArray (Get-EpProperty -Object $packEvent -Name 'options'))
        if ($options.Count -lt 1 -or $options.Count -gt $rules.MaxOptions) {
            $problems.Add((New-EpProblem -Level 'ERROR' -Where $eventWhere -Message "$($options.Count) option(s), needs 1 to $($rules.MaxOptions)"))
        }
        for ($optionIndex = 0; $optionIndex -lt $options.Count; $optionIndex++) {
            $option = $options[$optionIndex]
            $optionWhere = $eventWhere + '.' + (Get-EpOptionLetter -Index $optionIndex)
            $optionName = [string](Get-EpProperty -Object $option -Name 'name' -Default '')
            foreach ($textProblem in (Test-EpText -Where $optionWhere -Text $optionName -BannedPatterns $bannedPatterns)) { $problems.Add($textProblem) }
            if ((Get-EpWordCount -Text $optionName) -gt $rules.OptionMaxWords) {
                $problems.Add((New-EpProblem -Level 'ERROR' -Where $optionWhere -Message "option text over $($rules.OptionMaxWords) words"))
            }
            if ([double](Get-EpProperty -Object $option -Name 'ai' -Default 50) -lt 0) {
                $problems.Add((New-EpProblem -Level 'ERROR' -Where $optionWhere -Message 'ai weight below 0'))
            }
            foreach ($effect in (ConvertTo-EpArray (Get-EpProperty -Object $option -Name 'effects'))) {
                foreach ($effectProperty in $effect.PSObject.Properties) {
                    $effectName = $effectProperty.Name
                    if ($effectName -eq 'days') {
                        continue
                    }
                    if ($effectName -eq 'ideology') {
                        if ($null -eq (Get-EpProperty -Object $effect -Name 'popularity')) {
                            $problems.Add((New-EpProblem -Level 'ERROR' -Where $optionWhere -Message "ideology '$($effectProperty.Value)' without popularity"))
                        }
                        continue
                    }
                    if ($effectName -eq 'timed_idea') {
                        if ($ideaKeys -notcontains [string]$effectProperty.Value) {
                            $problems.Add((New-EpProblem -Level 'ERROR' -Where $optionWhere -Message "timed_idea '$($effectProperty.Value)' is not in the pack's ideas"))
                        }
                        $ideaDays = [double](Get-EpProperty -Object $effect -Name 'days' -Default 180)
                        if ($ideaDays -lt 1 -or $ideaDays -gt [double]$caps.ideaMaxDays) {
                            $problems.Add((New-EpProblem -Level 'ERROR' -Where $optionWhere -Message "timed idea for $ideaDays days; the cap is $($caps.ideaMaxDays) [SCR-090]"))
                        }
                        continue
                    }
                    $effectCap = Get-EpProperty -Object $caps.optionEffects -Name $effectName
                    if ($null -eq $effectCap) {
                        $problems.Add((New-EpProblem -Level 'ERROR' -Where $optionWhere -Message "effect '$effectName' is not one of: $(@($caps.optionEffects.PSObject.Properties.Name) -join ', '), timed_idea"))
                        continue
                    }
                    $capCitation = switch ($effectName) {
                        { $_ -in 'stability', 'war_support' } { ' [SCR-088]' }
                        'popularity' { ' [SCR-104]' }
                        default { '' }
                    }
                    if ([Math]::Abs([double]$effectProperty.Value) -gt [double]$effectCap) {
                        $problems.Add((New-EpProblem -Level 'ERROR' -Where $optionWhere -Message "$effectName $($effectProperty.Value) is over the cap of $effectCap$capCitation"))
                    }
                    if ($effectName -in 'manpower', 'army_experience', 'navy_experience', 'air_experience' -and [double]$effectProperty.Value -ne [Math]::Truncate([double]$effectProperty.Value)) {
                        $problems.Add((New-EpProblem -Level 'ERROR' -Where $optionWhere -Message "$effectName $($effectProperty.Value) is not a whole number"))
                    }
                    if ($effectName -eq 'popularity') {
                        $ideology = [string](Get-EpProperty -Object $effect -Name 'ideology' -Default '')
                        if (@($caps.ideologies) -cnotcontains $ideology) {
                            $problems.Add((New-EpProblem -Level 'ERROR' -Where $optionWhere -Message "popularity needs an ideology, one of: $(@($caps.ideologies) -join ', ') [SCR-104]"))
                        }
                    }
                }
            }
        }
    }

    $seenIdeas = @{}
    foreach ($idea in $Pack.Ideas) {
        $ideaWhere = 'idea ' + [string]$idea.key
        if ([string]$idea.key -cnotmatch '^[a-z0-9_]+$' -or $seenIdeas.ContainsKey([string]$idea.key)) {
            $problems.Add((New-EpProblem -Level 'ERROR' -Where $ideaWhere -Message 'key missing, used twice or not lower-case letters, digits and underscores'))
        }
        $seenIdeas[[string]$idea.key] = $true
        foreach ($textProblem in (Test-EpText -Where "$ideaWhere name" -Text ([string](Get-EpProperty -Object $idea -Name 'name' -Default '')) -BannedPatterns $bannedPatterns)) { $problems.Add($textProblem) }
        foreach ($textProblem in (Test-EpText -Where "$ideaWhere desc" -Text ([string](Get-EpProperty -Object $idea -Name 'desc' -Default '')) -BannedPatterns $bannedPatterns)) { $problems.Add($textProblem) }
        $ideaPicture = [string](Get-EpProperty -Object $idea -Name 'picture' -Default 'generic_morale_bonus')
        if (@($caps.ideaPictures) -notcontains $ideaPicture) {
            $problems.Add((New-EpProblem -Level 'ERROR' -Where $ideaWhere -Message "picture '$ideaPicture' is not one of: $(@($caps.ideaPictures) -join ', ')"))
        }
        $modifierProperties = @()
        $modifier = Get-EpProperty -Object $idea -Name 'modifier'
        if ($null -ne $modifier) {
            $modifierProperties = @($modifier.PSObject.Properties)
        }
        if ($modifierProperties.Count -lt 1 -or $modifierProperties.Count -gt [int]$caps.ideaMaxModifiers) {
            $problems.Add((New-EpProblem -Level 'ERROR' -Where $ideaWhere -Message "$($modifierProperties.Count) modifier(s), needs 1 to $($caps.ideaMaxModifiers)"))
        }
        foreach ($modifierProperty in $modifierProperties) {
            $modifierCap = Get-EpProperty -Object $caps.ideaModifiers -Name $modifierProperty.Name
            if ($null -eq $modifierCap) {
                $problems.Add((New-EpProblem -Level 'ERROR' -Where $ideaWhere -Message "modifier '$($modifierProperty.Name)' is not in data/effect-caps.json"))
            } elseif ([Math]::Abs([double]$modifierProperty.Value) -gt [double]$modifierCap) {
                $problems.Add((New-EpProblem -Level 'ERROR' -Where $ideaWhere -Message "$($modifierProperty.Name) $($modifierProperty.Value) is over the cap of $modifierCap"))
            }
        }
        $usedByEvent = @($Pack.Events | ForEach-Object { ConvertTo-EpArray $_.options } | ForEach-Object { ConvertTo-EpArray (Get-EpProperty -Object $_ -Name 'effects') } | Where-Object { [string](Get-EpProperty -Object $_ -Name 'timed_idea' -Default '') -eq [string]$idea.key }).Count
        if ($usedByEvent -eq 0) {
            $problems.Add((New-EpProblem -Level 'WARN' -Where $ideaWhere -Message 'no option adds this idea'))
        }
    }

    $usedPictureKeys = Get-EpUsedPictureKeys -Pack $Pack
    $imagePolicy = Get-EpImagePolicy
    foreach ($picture in $Pack.Pictures) {
        $pictureWhere = 'picture ' + [string]$picture.key
        $pictureIsUsed = $usedPictureKeys -contains [string]$picture.key
        foreach ($imageProblem in @(Test-HoiImageRecord -Record $picture -Policy $imagePolicy -Used $pictureIsUsed -CacheDir $Pack.CacheDir)) {
            $problems.Add((New-EpProblem -Level $imageProblem.Level -Where $pictureWhere -Message $imageProblem.Message))
        }
        if (-not $pictureIsUsed) {
            $problems.Add((New-EpProblem -Level 'WARN' -Where $pictureWhere -Message 'no event uses this picture'))
        }
    }
    return $problems.ToArray()
}

function Get-EpDdsSize {
    param([Parameter(Mandatory = $true)][string]$Path)

    $headerBytes = New-Object byte[] 20
    $fileStream = [System.IO.File]::OpenRead($Path)
    try {
        [void]$fileStream.Read($headerBytes, 0, 20)
    } finally {
        $fileStream.Dispose()
    }
    if ([System.Text.Encoding]::ASCII.GetString($headerBytes, 0, 4) -ne 'DDS ') {
        return $null
    }
    return [PSCustomObject]@{ Height = [System.BitConverter]::ToInt32($headerBytes, 12); Width = [System.BitConverter]::ToInt32($headerBytes, 16) }
}

function Test-EpPack {
    param(
        [Parameter(Mandatory = $true)][string]$RepoRoot,
        [Parameter(Mandatory = $true)][string]$Pack
    )

    $packData = Get-EpPack -RepoRoot $RepoRoot -Pack $Pack
    $problems = [System.Collections.Generic.List[PSObject]]::new()
    foreach ($sourceProblem in @(Test-EpPackSource -Pack $packData)) {
        $problems.Add($sourceProblem)
    }
    foreach ($pictureKey in (Get-EpUsedPictureKeys -Pack $packData)) {
        $ddsPath = Join-Path $packData.PackRoot ((Get-EpPictureRelativePath -Pack $packData -PictureKey $pictureKey).Replace('/', '\'))
        if (-not (Test-Path -LiteralPath $ddsPath)) {
            $problems.Add((New-EpProblem -Level 'ERROR' -Where "picture $pictureKey" -Message 'no DDS in the pack: run build.ps1 -ConvertPictures'))
            continue
        }
        $ddsSize = Get-EpDdsSize -Path $ddsPath
        if ($null -eq $ddsSize -or $ddsSize.Width -ne 210 -or $ddsSize.Height -ne 176) {
            $problems.Add((New-EpProblem -Level 'ERROR' -Where "picture $pictureKey" -Message 'the DDS is not 210x176 [SPR-028]'))
        }
    }
    $delta = Get-EpGenerationDelta -Pack $packData
    foreach ($changedPath in $delta.Changed) {
        $problems.Add((New-EpProblem -Level 'ERROR' -Where $changedPath -Message 'differs from what the source generates: run build.ps1 -Generate (never edit it by hand)'))
    }
    foreach ($stalePath in $delta.Stale) {
        $problems.Add((New-EpProblem -Level 'ERROR' -Where $stalePath -Message 'not generated from the source: run build.ps1 -Generate to remove it'))
    }
    $packPrefix = 'packs/' + $Pack + '/'
    $knownPackFiles = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($knownPath in @(@($delta.Files.Keys) + @($delta.Stale) + @(($packPrefix + 'descriptor.mod'), ($packPrefix + 'thumbnail.png')))) {
        [void]$knownPackFiles.Add([string]$knownPath)
    }
    foreach ($pictureKey in (Get-EpUsedPictureKeys -Pack $packData)) {
        [void]$knownPackFiles.Add($packPrefix + (Get-EpPictureRelativePath -Pack $packData -PictureKey $pictureKey))
    }
    if (Test-Path -LiteralPath $packData.PackRoot) {
        foreach ($packFile in @(Get-ChildItem -LiteralPath $packData.PackRoot -Recurse -File -Force)) {
            $packRelativePath = $packPrefix + $packFile.FullName.Substring($packData.PackRoot.Length + 1).Replace('\', '/')
            if (-not $knownPackFiles.Contains($packRelativePath)) {
                $problems.Add((New-EpProblem -Level 'ERROR' -Where $packRelativePath -Message 'is not generated from the source nor a picture of pictures.json, so it would ship unchecked: remove it (build.ps1 -ConvertPictures removes unused pictures)'))
            }
        }
    }
    $otherNamespaces = @(Get-EpPackNames -RepoRoot $RepoRoot | Where-Object { $_ -ne $Pack } | ForEach-Object {
            $otherEventsPath = Join-Path $RepoRoot ('source\' + $_ + '\events.json')
            if (Test-Path -LiteralPath $otherEventsPath) { [string](Get-EpProperty -Object (Read-EpJson -Path $otherEventsPath) -Name 'namespace' -Default '') }
        } | Where-Object { $_ })
    if ($otherNamespaces -contains $packData.Namespace) {
        $problems.Add((New-EpProblem -Level 'ERROR' -Where "source/$Pack/events.json" -Message "namespace '$($packData.Namespace)' is used by another pack"))
    }
    foreach ($relativePath in @($delta.Files.Keys | Where-Object { $_ -like 'packs/*' })) {
        foreach ($otherNamespace in $otherNamespaces) {
            if ($otherNamespace -ne $packData.Namespace -and [regex]::IsMatch($delta.Files[$relativePath].Text, '\b' + [regex]::Escape($otherNamespace) + '[._]')) {
                $problems.Add((New-EpProblem -Level 'ERROR' -Where $relativePath -Message "names '$otherNamespace' of another pack: every pack stands alone"))
            }
        }
    }
    return $problems.ToArray()
}

function Invoke-EpCheck {
    param(
        [Parameter(Mandatory = $true)][string]$RepoRoot,
        [string[]]$Pack
    )

    $allBundleNames = @(Get-EpBundleNames -RepoRoot $RepoRoot)
    $packNames = if ($Pack) { @($Pack | Where-Object { $allBundleNames -notcontains $_ }) } else { @(Get-EpPackNames -RepoRoot $RepoRoot) }
    $bundleNames = if ($Pack) { @($allBundleNames | Where-Object { $Pack -contains $_ -or @(Get-EpBundleNames -RepoRoot $RepoRoot -Member $Pack) -contains $_ }) } else { $allBundleNames }
    $errorCount = 0
    $warningCount = 0
    foreach ($bundleName in $bundleNames) {
        $bundleProblems = @(Test-EpBundle -RepoRoot $RepoRoot -Bundle $bundleName)
        Write-EpProblems -Problems $bundleProblems
        $bundleErrors = @($bundleProblems | Where-Object { $_.Level -eq 'ERROR' }).Count
        $errorCount += $bundleErrors
        Write-Host ("Bundle '{0}': {1} member(s), {2} error(s)" -f $bundleName, @((Get-EpBundle -RepoRoot $RepoRoot -Bundle $bundleName).Members).Count, $bundleErrors) -ForegroundColor $(if ($bundleErrors -gt 0) { 'Red' } else { 'Green' })
    }
    foreach ($packName in $packNames) {
        $problems = @(Test-EpPack -RepoRoot $RepoRoot -Pack $packName)
        Write-EpProblems -Problems $problems
        $packErrors = @($problems | Where-Object { $_.Level -eq 'ERROR' }).Count
        $errorCount += $packErrors
        $warningCount += @($problems | Where-Object { $_.Level -eq 'WARN' }).Count
        $packData = Get-EpPack -RepoRoot $RepoRoot -Pack $packName
        Write-Host ("Pack '{0}': {1} event(s), {2} picture(s), {3} error(s)" -f $packName, $packData.Events.Count, $packData.Pictures.Count, $packErrors) -ForegroundColor $(if ($packErrors -gt 0) { 'Red' } else { 'Green' })
    }
    if ($errorCount -gt 0) {
        Write-Host "Check FAILED: $errorCount error(s), $warningCount warning(s)." -ForegroundColor Red
        return 1
    }
    Write-Host "Check OK: $($packNames.Count) pack(s), $(@($bundleNames).Count) bundle(s), $warningCount warning(s)." -ForegroundColor Green
    return 0
}

function Invoke-EpAudit {
    param(
        [Parameter(Mandatory = $true)][string]$RepoRoot,
        [Parameter(Mandatory = $true)][string]$Pack
    )

    $packData = Get-EpPack -RepoRoot $RepoRoot -Pack $Pack
    $problems = @(Test-EpPack -RepoRoot $RepoRoot -Pack $Pack)
    Write-Host "Audit of pack '$Pack' ($($packData.Tag), namespace $($packData.Namespace))" -ForegroundColor Cyan
    Write-Host ''
    Write-Host '| Event | Year | Words | Anchors used | Options | Effects | Picture licence |'
    Write-Host '|---|---|---|---|---|---|---|'
    foreach ($packEvent in @($packData.Events | Sort-Object { [int]$_.id })) {
        $anchors = @(ConvertTo-EpArray $packEvent.anchors | ForEach-Object { [string]$_ })
        $usedAnchors = @($anchors | Where-Object { ([string]$packEvent.desc).Contains($_) }).Count
        $options = @(ConvertTo-EpArray $packEvent.options)
        $effectCount = @($options | ForEach-Object { ConvertTo-EpArray (Get-EpProperty -Object $_ -Name 'effects') }).Count
        $picture = Get-EpPictureByKey -Pack $packData -PictureKey ([string]$packEvent.picture)
        $licence = if ($null -ne $picture) { Get-EpLicenceLabel -Picture $picture } elseif ([string]$packEvent.picture -like 'vanilla:*') { 'vanilla' } else { 'missing' }
        Write-Host ('| {0}.{1} | {2} | {3} | {4}/{5} | {6} | {7} | {8} |' -f $packData.Namespace, $packEvent.id, (Get-EpEventYear -PackEvent $packEvent), (Get-EpWordCount -Text ([string]$packEvent.desc)), $usedAnchors, $anchors.Count, $options.Count, $effectCount, $licence)
    }
    Write-Host ''
    $licenceCounts = @($packData.Pictures | Group-Object { Get-EpLicenceLabel -Picture $_ } | ForEach-Object { "$($_.Name) $($_.Count)" })
    Write-Host ('Pictures: ' + $(if ($licenceCounts.Count -gt 0) { $licenceCounts -join ', ' } else { 'none' }))
    $oldestFetch = @($packData.Pictures | ForEach-Object { [string]$_.fetched } | Where-Object { $_ } | Sort-Object | Select-Object -First 1)
    if ($oldestFetch.Count -gt 0) {
        Write-Host "Oldest licence check: $($oldestFetch[0]) (the audit researcher rechecks Commons for deletions and licence changes)"
    }
    $factQuotesFromId = Get-EpFactQuotesFromId -Pack $packData
    $unquotedEventIds = @($packData.Events | Where-Object { $null -ne $factQuotesFromId -and [int]$_.id -lt $factQuotesFromId } | ForEach-Object { [int]$_.id } | Sort-Object)
    if ($unquotedEventIds.Count -gt 0) {
        $problems += New-EpProblem -Level 'WARN' -Where "source/$Pack/fact-sheets.md" -Message ("the facts of events $($unquotedEventIds -join ', ') predate quoted facts (factQuotesFromId $factQuotesFromId): recheck them through event-pack-audit, which adds the quotes and removes factQuotesFromId")
    }
    $refreshCutoff = (Get-Date).AddDays(-180).ToString('yyyy-MM-dd')
    foreach ($stalePicture in @($packData.Pictures | Where-Object { [string]$_.fetched -and [string]$_.fetched -lt $refreshCutoff })) {
        $problems += New-EpProblem -Level 'WARN' -Where ('picture ' + $stalePicture.key) -Message "licence last read from Commons on $($stalePicture.fetched), over 180 days ago: fetch it again (build.ps1 -FetchPicture keeps its crop and tone)"
    }
    Write-Host ''
    Write-EpProblems -Problems $problems
    $errorCount = @($problems | Where-Object { $_.Level -eq 'ERROR' }).Count
    Write-Host ("Audit: {0} error(s), {1} warning(s)" -f $errorCount, @($problems | Where-Object { $_.Level -eq 'WARN' }).Count) -ForegroundColor $(if ($errorCount -gt 0) { 'Red' } else { 'Green' })
    return $(if ($errorCount -gt 0) { 1 } else { 0 })
}

function Get-EpCommonsQueryUrl {
    param([Parameter(Mandatory = $true)][string]$FileTitle)

    return Get-HoiCommonsQueryUrl -FileTitle $FileTitle
}

function ConvertTo-EpPicture {
    param([Parameter(Mandatory = $true)]$Record)

    $picture = [ordered]@{}
    foreach ($recordProperty in $Record.PSObject.Properties) {
        $picture[$recordProperty.Name] = $recordProperty.Value
        if ($recordProperty.Name -eq 'height') {
            $picture['crop'] = '50'
            $picture['tone'] = 'none'
        }
    }
    return [PSCustomObject]$picture
}

function Get-EpCommonsVerdict {
    param([Parameter(Mandatory = $true)]$Response)

    $verdict = Get-HoiImageVerdict -Candidate (ConvertFrom-HoiCommonsResponse -Response $Response) -Policy (Get-EpImagePolicy)
    $picture = if ($null -ne $verdict.Record) { ConvertTo-EpPicture -Record $verdict.Record } else { $null }
    return [PSCustomObject]@{ Accepted = $verdict.Accepted; Reason = $verdict.Reason; Picture = $picture }
}

function Invoke-EpCommonsRequest {
    param(
        [Parameter(Mandatory = $true)][string]$Uri,
        [string]$OutFile,
        [int]$MaxAttempts = 5
    )

    return (Invoke-HoiImageRequest -Uri $Uri -Policy (Get-EpImagePolicy) -OutFile $OutFile -MaxAttempts $MaxAttempts)
}

function Get-EpCacheFilePath {
    param($Pack, $Picture)

    return Get-HoiImageCachePath -CacheDir $Pack.CacheDir -Record $Picture
}

function Save-EpPictures {
    param($Pack, [Parameter(Mandatory = $true)][AllowEmptyCollection()]$Pictures)

    $picturesPath = Join-Path $Pack.SourceDir 'pictures.json'
    $sortedPictures = [System.Collections.Generic.List[PSObject]]::new()
    foreach ($picture in @($Pictures | Sort-Object { [string]$_.key })) {
        $sortedPictures.Add($picture)
    }
    $jsonText = ConvertTo-Json -InputObject ([PSCustomObject]@{ pictures = @($sortedPictures) }) -Depth 5
    Write-EpText -Path $picturesPath -Text ($jsonText + "`r`n")
}

function Invoke-EpFetchPicture {
    param(
        [Parameter(Mandatory = $true)][string]$RepoRoot,
        [Parameter(Mandatory = $true)][string]$Pack,
        [Parameter(Mandatory = $true)][string]$File,
        [Parameter(Mandatory = $true)][string]$Key,
        [string]$Crop,
        [string]$Tone,
        [switch]$DryRun
    )

    if ($Key -cnotmatch '^[a-z0-9_]+$') {
        Write-Host "-Key '$Key' must be lower-case letters, digits and underscores" -ForegroundColor Red
        return 1
    }
    $existingPicture = Get-EpPictureByKey -Pack (Get-EpPack -RepoRoot $RepoRoot -Pack $Pack) -PictureKey $Key
    if (-not $Crop) {
        $Crop = if ($null -ne $existingPicture -and $existingPicture.crop) { [string]$existingPicture.crop } else { '50' }
    }
    if (-not $Tone) {
        $Tone = if ($null -ne $existingPicture -and $existingPicture.tone) { [string]$existingPicture.tone } else { 'none' }
    }
    if ($Crop -ne 'fit' -and ($Crop -notmatch '^\d{1,3}$' -or [int]$Crop -gt 100)) {
        Write-Host "-Crop is 0 to 100 (50 centres) or fit" -ForegroundColor Red
        return 1
    }
    if (@('none', 'grey', 'warm') -notcontains $Tone) {
        Write-Host "-Tone is none, grey or warm" -ForegroundColor Red
        return 1
    }
    $packData = Get-EpPack -RepoRoot $RepoRoot -Pack $Pack
    $fileTitle = if ($File -like 'File:*') { $File } else { 'File:' + $File }
    $response = Invoke-EpCommonsRequest -Uri (Get-EpCommonsQueryUrl -FileTitle $fileTitle)
    $verdict = Get-EpCommonsVerdict -Response $response
    if (-not $verdict.Accepted) {
        Write-Host "REJECTED $fileTitle : $($verdict.Reason)" -ForegroundColor Red
        return 1
    }
    $picture = $verdict.Picture
    $picture.key = $Key
    $picture.crop = $Crop
    $picture.tone = $Tone
    $picture.fetched = (Get-Date).ToString('yyyy-MM-dd')
    Write-Host "ACCEPTED $fileTitle : $($verdict.Reason), $($picture.width)x$($picture.height), author: $(if ($picture.author) { $picture.author } else { 'not given' })" -ForegroundColor Green
    if ($picture.restrictions) {
        Write-Host "  Commons lists restrictions: $($picture.restrictions)" -ForegroundColor Yellow
    }
    if ($DryRun) {
        Write-Host '  Dry run: nothing downloaded or recorded.' -ForegroundColor Gray
        return 0
    }
    $cachePath = Get-EpCacheFilePath -Pack $packData -Picture $picture
    if (-not (Test-Path -LiteralPath $packData.CacheDir)) {
        New-Item -ItemType Directory -Path $packData.CacheDir -Force | Out-Null
    }
    Invoke-EpCommonsRequest -Uri $picture.downloadUrl -OutFile $cachePath
    $picture.downloadSha256 = (Get-FileHash -LiteralPath $cachePath -Algorithm SHA256).Hash.ToLowerInvariant()
    $keptPictures = [System.Collections.Generic.List[PSObject]]::new()
    foreach ($existingPicture in $packData.Pictures) {
        if ($existingPicture.key -ne $Key) {
            $keptPictures.Add($existingPicture)
        }
    }
    $keptPictures.Add($picture)
    Save-EpPictures -Pack $packData -Pictures $keptPictures
    Write-Host "  recorded '$Key' in source\$Pack\pictures.json; downloaded to $cachePath" -ForegroundColor Gray
    return 0
}

function Invoke-EpRemovePicture {
    param(
        [Parameter(Mandatory = $true)][string]$RepoRoot,
        [Parameter(Mandatory = $true)][string]$Pack,
        [Parameter(Mandatory = $true)][string]$Key,
        [switch]$DryRun
    )

    $packData = Get-EpPack -RepoRoot $RepoRoot -Pack $Pack
    $picture = Get-EpPictureByKey -Pack $packData -PictureKey $Key
    if ($null -eq $picture) {
        Write-Host "picture '$Key' is not in source\$Pack\pictures.json" -ForegroundColor Red
        return 1
    }
    $usingEvents = @($packData.Events | Where-Object { [string](Get-EpProperty -Object $_ -Name 'picture' -Default '') -eq $Key } | ForEach-Object { $packData.Namespace + '.' + [string]$_.id })
    if ($usingEvents.Count -gt 0) {
        Write-Host "picture '$Key' is used by $($usingEvents -join ', '): give the event another picture first" -ForegroundColor Red
        return 1
    }
    $cachePath = Get-EpCacheFilePath -Pack $packData -Picture $picture
    $ddsPath = Join-Path $packData.PackRoot ((Get-EpPictureRelativePath -Pack $packData -PictureKey $Key).Replace('/', '\'))
    $filesToRemove = @(@($cachePath, $ddsPath) | Where-Object { Test-Path -LiteralPath $_ })
    if ($DryRun) {
        Write-Host "Dry run: would remove '$Key' ($($picture.commonsTitle)) from source\$Pack\pictures.json" -ForegroundColor Gray
        foreach ($fileToRemove in $filesToRemove) {
            Write-Host "  would delete $fileToRemove" -ForegroundColor Gray
        }
        return 0
    }
    $keptPictures = [System.Collections.Generic.List[PSObject]]::new()
    foreach ($existingPicture in $packData.Pictures) {
        if ($existingPicture.key -ne $Key) {
            $keptPictures.Add($existingPicture)
        }
    }
    Save-EpPictures -Pack $packData -Pictures $keptPictures
    foreach ($fileToRemove in $filesToRemove) {
        Remove-Item -LiteralPath $fileToRemove -Force
    }
    Write-Host "Removed '$Key' ($($picture.commonsTitle)) from source\$Pack\pictures.json" -ForegroundColor Green
    foreach ($fileToRemove in $filesToRemove) {
        Write-Host "  deleted $fileToRemove" -ForegroundColor Gray
    }
    return 0
}

function Get-EpPythonExecutable {
    foreach ($pythonName in @('python', 'py')) {
        if (Get-Command -Name $pythonName -ErrorAction SilentlyContinue) {
            return $pythonName
        }
    }
    return $null
}

function Invoke-EpConvertPictures {
    param(
        [Parameter(Mandatory = $true)][string]$RepoRoot,
        [Parameter(Mandatory = $true)][string]$Pack,
        [switch]$Force
    )

    $packData = Get-EpPack -RepoRoot $RepoRoot -Pack $Pack
    $pythonExecutable = Get-EpPythonExecutable
    if (-not $pythonExecutable) {
        Write-Host 'Python 3 with Pillow is needed to convert pictures.' -ForegroundColor Red
        return 1
    }
    $manifestLines = [System.Collections.Generic.List[string]]::new()
    foreach ($pictureKey in (Get-EpUsedPictureKeys -Pack $packData)) {
        $picture = Get-EpPictureByKey -Pack $packData -PictureKey $pictureKey
        if ($null -eq $picture) {
            Write-Host "picture '$pictureKey' is not in pictures.json" -ForegroundColor Red
            return 1
        }
        $cachePath = Get-EpCacheFilePath -Pack $packData -Picture $picture
        if (-not (Test-HoiCommonsDownloadUrl -Url ([string]$picture.downloadUrl))) {
            Write-Host "picture '$pictureKey' has a download URL outside Wikimedia's upload servers: fetch it again with build.ps1 -FetchPicture" -ForegroundColor Red
            return 1
        }
        if (-not (Test-Path -LiteralPath $cachePath)) {
            if (-not (Test-Path -LiteralPath $packData.CacheDir)) {
                New-Item -ItemType Directory -Path $packData.CacheDir -Force | Out-Null
            }
            Invoke-EpCommonsRequest -Uri $picture.downloadUrl -OutFile $cachePath
            $downloadedHash = (Get-FileHash -LiteralPath $cachePath -Algorithm SHA256).Hash.ToLowerInvariant()
            if ($picture.downloadSha256 -and $downloadedHash -ne $picture.downloadSha256) {
                Write-Host "  [WARN] $pictureKey downloaded again with other bytes than recorded; Commons may have re-rendered the thumbnail" -ForegroundColor Yellow
            }
        }
        $ddsPath = Join-Path $packData.PackRoot ((Get-EpPictureRelativePath -Pack $packData -PictureKey $pictureKey).Replace('/', '\'))
        $manifestLines.Add(($cachePath, $ddsPath, [string]$picture.crop, [string]$picture.tone) -join "`t")
    }
    if ($manifestLines.Count -eq 0) {
        Write-Host "Pack '$Pack' uses no pictures of its own." -ForegroundColor Green
        return 0
    }
    $artifactsDir = Join-Path $RepoRoot 'artifacts'
    if (-not (Test-Path -LiteralPath $artifactsDir)) {
        New-Item -ItemType Directory -Path $artifactsDir -Force | Out-Null
    }
    $manifestPath = Join-Path $artifactsDir "picture-manifest-$Pack.tsv"
    Write-EpText -Path $manifestPath -Text (($manifestLines -join "`n") + "`n")
    $converterArguments = @('-I', (Join-Path $RepoRoot 'tools\convert_event_pictures.py'), '--manifest', $manifestPath, '--applied', (Join-Path $artifactsDir "picture-applied-$Pack.tsv"))
    if ($Force) {
        $converterArguments += '--force'
    }
    & $pythonExecutable @converterArguments | Out-Host
    $converterExitCode = $LASTEXITCODE
    $usedDdsPaths = @($manifestLines | ForEach-Object { ($_ -split "`t")[1] })
    $pictureFolder = Join-Path $packData.PackRoot ('gfx\event_pictures\' + $packData.Namespace)
    if (Test-Path -LiteralPath $pictureFolder) {
        foreach ($existingDds in @(Get-ChildItem -LiteralPath $pictureFolder -Filter '*.dds' -File)) {
            if ($usedDdsPaths -notcontains $existingDds.FullName) {
                Remove-Item -LiteralPath $existingDds.FullName -Force
                Write-Host "  removed unused $($existingDds.Name)" -ForegroundColor Gray
            }
        }
    }
    return $converterExitCode
}

function Add-EpPackageSettingText {
    param(
        [Parameter(Mandatory = $true)][string]$Text,
        [Parameter(Mandatory = $true)][string]$Pack
    )

    $unitMatch = [regex]::Match($Text, '(?m)^([ \t]+)\S')
    $unit = if ($unitMatch.Success) { $unitMatch.Groups[1].Value } else { '    ' }
    $entryLines = @(('"{0}": {{' -f $Pack), ($unit + ('"root": "packs/{0}",' -f $Pack)), ($unit + ('"modFolderName": "event_pack_{0}"' -f $Pack)), '}')
    $packagesMatch = [regex]::Match($Text, '"packages"\s*:\s*\{')
    if ($packagesMatch.Success) {
        $openIndex = $packagesMatch.Index + $packagesMatch.Length - 1
    } else {
        $openIndex = $Text.IndexOf([char]'{')
        $entryLines = @('"packages": {') + @($entryLines | ForEach-Object { $unit + $_ }) + @('}')
    }
    $depth = 0
    $inString = $false
    $closeIndex = -1
    for ($index = $openIndex; $index -lt $Text.Length -and $closeIndex -lt 0; $index++) {
        $character = $Text[$index]
        if ($inString) {
            if ($character -eq [char]'\') { $index++ } elseif ($character -eq [char]'"') { $inString = $false }
        } elseif ($character -eq [char]'"') {
            $inString = $true
        } elseif ($character -eq [char]'{' -or $character -eq [char]'[') {
            $depth++
        } elseif ($character -eq [char]'}' -or $character -eq [char]']') {
            $depth--
            if ($depth -eq 0) { $closeIndex = $index }
        }
    }
    $newline = if ($Text.Contains("`r`n")) { "`r`n" } else { "`n" }
    $lineStart = $Text.LastIndexOf([char]10, $openIndex) + 1
    $indent = [regex]::Match($Text.Substring($lineStart), '^[ \t]*').Value
    $insertIndex = $closeIndex
    while ([char]::IsWhiteSpace($Text[$insertIndex - 1])) { $insertIndex-- }
    $insertText = if ($insertIndex -gt $openIndex + 1) { ',' } else { '' }
    $insertText += -join @($entryLines | ForEach-Object { $newline + $indent + $unit + $_ })
    if ($Text.IndexOf([char]10, $insertIndex, $closeIndex - $insertIndex) -lt 0) {
        $insertText += $newline + $indent
    }
    $newText = $Text.Substring(0, $insertIndex) + $insertText + $Text.Substring($insertIndex)
    $packages = Get-EpProperty -Object ($newText | ConvertFrom-Json) -Name 'packages'
    if ($null -eq $packages -or $null -eq (Get-EpProperty -Object $packages -Name $Pack)) {
        throw "tools\HoiModBuild.json: package '$Pack' did not land in the top-level packages object; add it by hand."
    }
    return $newText
}

function Add-EpBundleMemberText {
    param(
        [Parameter(Mandatory = $true)][string]$Text,
        [Parameter(Mandatory = $true)][string]$Bundle,
        [Parameter(Mandatory = $true)][string]$Pack
    )

    $membersPattern = '("' + [regex]::Escape($Bundle) + '"\s*:\s*\{[^{}]*?"members"\s*:\s*\[)([^\]]*)(\])'
    $membersMatch = [regex]::Match($Text, $membersPattern)
    if (-not $membersMatch.Success) {
        throw "tools\HoiModBuild.json: the members list of bundle '$Bundle' was not found; add '$Pack' to it by hand."
    }
    $existingMembers = $membersMatch.Groups[2].Value.TrimEnd()
    $separator = if ($existingMembers.Trim()) { ', ' } else { '' }
    $newText = $Text.Substring(0, $membersMatch.Groups[2].Index) + $existingMembers + $separator + '"' + $Pack + '"' + $Text.Substring($membersMatch.Groups[3].Index)
    $bundleEntry = Get-EpProperty -Object (Get-EpProperty -Object ($newText | ConvertFrom-Json) -Name 'packages') -Name $Bundle
    if (@(Get-EpProperty -Object $bundleEntry -Name 'members' -Default @()) -notcontains $Pack) {
        throw "tools\HoiModBuild.json: '$Pack' did not land in the members of bundle '$Bundle'; add it by hand."
    }
    return $newText
}

function Invoke-EpNewPack {
    param(
        [Parameter(Mandatory = $true)][string]$RepoRoot,
        [Parameter(Mandatory = $true)][string]$Pack,
        [Parameter(Mandatory = $true)][string]$Tag,
        [Parameter(Mandatory = $true)][string]$DisplayName,
        [string]$SupportedVersion = '1.19.*'
    )

    if ($Pack -cnotmatch '^[a-z][a-z0-9_]*$') {
        Write-Host "-Pack '$Pack' must be lower-case letters, digits and underscores, such as finland" -ForegroundColor Red
        return 1
    }
    if ($Tag -cnotmatch '^[A-Z][A-Z0-9]{2}$') {
        Write-Host "-Tag '$Tag' is not a country tag" -ForegroundColor Red
        return 1
    }
    if (@(Get-EpPackNames -RepoRoot $RepoRoot) -contains $Pack) {
        Write-Host "Pack '$Pack' exists already." -ForegroundColor Red
        return 1
    }
    $namespace = 'ep_' + $Tag.ToLowerInvariant()
    $sourceDir = Join-Path $RepoRoot ('source\' + $Pack)
    $packRoot = Join-Path $RepoRoot ('packs\' + $Pack)
    $eventSource = [PSCustomObject][ordered]@{ pack = $Pack; tag = $Tag; namespace = $namespace; displayName = $DisplayName; events = @(); ideas = @() }
    Write-EpText -Path (Join-Path $sourceDir 'events.json') -Text ((ConvertTo-Json -InputObject $eventSource -Depth 8) + "`r`n")
    Write-EpText -Path (Join-Path $sourceDir 'pictures.json') -Text ((ConvertTo-Json -InputObject ([PSCustomObject]@{ pictures = @() }) -Depth 3) + "`r`n")
    $quotedFactFormat = '- <fact>. Source: <URL> (<page title>). Quote: ' + [char]0x00AB + '<line from the page>' + [char]0x00BB
    Write-EpText -Path (Join-Path $sourceDir 'fact-sheets.md') -Text ("# Fact sheets: $DisplayName`r`n`r`nOne section per event, headed ``## <event key>``: the facts the text may use, each checked on its page, one per line as ``$quotedFactFormat``. The text of an event uses nothing that is not here.`r`n")
    Write-EpText -Path (Join-Path $sourceDir 'workshop-intro.bbcode') -Text ("<!-- region:image:hero -->`r`n<!-- /region -->`r`nHistorical flavor events for $DisplayName, with period photographs.`r`n`r`n<!-- region:image:strip-info -->`r`n<!-- /region -->`r`n[h1]Info:[/h1]`r`n<!-- region:info:checksum-event-pack,standalone-event-pack,small-effects,game-version -->`r`n<!-- /region -->`r`n")
    $descriptorText = @('version="1.0"', 'tags={', "`t`"Events`"", "`t`"Historical`"", '}', "name=`"Event Pack: $DisplayName`"", 'picture="thumbnail.png"', "supported_version=`"$SupportedVersion`"") -join "`r`n"
    Write-EpText -Path (Join-Path $packRoot 'descriptor.mod') -Text ($descriptorText + "`r`n")
    $settingsPath = Join-Path $RepoRoot 'tools\HoiModBuild.json'
    $settingsText = if (Test-Path -LiteralPath $settingsPath) { [System.IO.File]::ReadAllText($settingsPath, [System.Text.Encoding]::UTF8) } else { "{`r`n}`r`n" }
    $newSettingsText = Add-EpPackageSettingText -Text $settingsText -Pack $Pack
    $joinedBundleNames = @(Get-EpBundleNames -RepoRoot $RepoRoot)
    foreach ($bundleName in $joinedBundleNames) {
        $newSettingsText = Add-EpBundleMemberText -Text $newSettingsText -Bundle $bundleName -Pack $Pack
    }
    Write-EpText -Path $settingsPath -Text $newSettingsText
    Write-Host "Created pack '$Pack' ($Tag, namespace $namespace): source\$Pack and packs\$Pack; registered in tools\HoiModBuild.json$(if ($joinedBundleNames.Count -gt 0) { ' and in the members of ' + ($joinedBundleNames -join ', ') })." -ForegroundColor Green
    $managerRoot = if (Get-Command -Name 'Get-ModManagerRoot' -ErrorAction SilentlyContinue) { Get-ModManagerRoot } else { $null }
    $thumbnailScriptPath = if ($managerRoot) { Join-Path $managerRoot 'Scripts\Showcase\New-HoiThumbnail.ps1' } else { '<Modding Manager>\Scripts\Showcase\New-HoiThumbnail.ps1' }
    $thumbnailProblem = 'the Modding Manager was not found'
    $thumbnailRendered = $false
    if ($managerRoot) {
        try {
            $global:LASTEXITCODE = 0
            $thumbnailOutput = @(& $thumbnailScriptPath -Path $RepoRoot -Pack $Pack -Apply -PassThru)
            if ($LASTEXITCODE -eq 0) {
                $thumbnailRendered = $true
            } else {
                $thumbnailProblem = (@($thumbnailOutput | ForEach-Object { [string]$_ }) -join ' ').Trim()
            }
        } catch {
            $thumbnailProblem = $_.Exception.Message
        }
    }
    if ($thumbnailRendered) {
        Write-Host ('  Rendered packs\' + $Pack + '\thumbnail.png over the family''s default loading screen; the plan''s thumbnail step sets the pack''s own picture.') -ForegroundColor Gray
    } else {
        $masterThumbnail = Join-Path $RepoRoot 'assets\thumbnail_master.png'
        $placeholderNote = ''
        if (Test-Path -LiteralPath $masterThumbnail) {
            Copy-Item -LiteralPath $masterThumbnail -Destination (Join-Path $packRoot 'thumbnail.png')
            $placeholderNote = " packs\$Pack\thumbnail.png is a copy of assets\thumbnail_master.png."
        }
        Write-Host ("  No thumbnail rendered: $($thumbnailProblem.TrimEnd('.')).$placeholderNote Render it later: & `"$thumbnailScriptPath`" -Path `"$RepoRoot`" -Pack $Pack -Apply") -ForegroundColor Gray
    }
    Write-Host ('  Next: the event-pack-create skill (research, pictures, texts, plan); its thumbnail step picks the pack''s own picture in assets\thumbnail.json.') -ForegroundColor Gray
    return (Invoke-EpGenerate -RepoRoot $RepoRoot -Pack $Pack)
}

function Export-EpPicturePreviews {
    param(
        [Parameter(Mandatory = $true)][string]$RepoRoot,
        [Parameter(Mandatory = $true)][string]$Pack
    )

    Add-Type -AssemblyName System.Drawing
    $packData = Get-EpPack -RepoRoot $RepoRoot -Pack $Pack
    $previewDir = Join-Path $packData.RepoRoot ('scratch\preview\' + $Pack)
    if (-not (Test-Path -LiteralPath $previewDir)) {
        New-Item -ItemType Directory -Path $previewDir -Force | Out-Null
    }
    $writtenCount = 0
    foreach ($pictureKey in (Get-EpUsedPictureKeys -Pack $packData)) {
        $ddsPath = Join-Path $packData.PackRoot ((Get-EpPictureRelativePath -Pack $packData -PictureKey $pictureKey).Replace('/', '\'))
        $ddsSize = if (Test-Path -LiteralPath $ddsPath) { Get-EpDdsSize -Path $ddsPath } else { $null }
        if ($null -eq $ddsSize) {
            Write-Host "  [WARN] no readable DDS for '$pictureKey': run build.ps1 -ConvertPictures" -ForegroundColor Yellow
            continue
        }
        $ddsBytes = [System.IO.File]::ReadAllBytes($ddsPath)
        $bitmap = New-Object System.Drawing.Bitmap($ddsSize.Width, $ddsSize.Height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
        try {
            $bitmapData = $bitmap.LockBits((New-Object System.Drawing.Rectangle(0, 0, $ddsSize.Width, $ddsSize.Height)), [System.Drawing.Imaging.ImageLockMode]::WriteOnly, $bitmap.PixelFormat)
            [System.Runtime.InteropServices.Marshal]::Copy($ddsBytes, 128, $bitmapData.Scan0, $ddsSize.Width * $ddsSize.Height * 4)
            $bitmap.UnlockBits($bitmapData)
            $previewPath = Join-Path $previewDir ($pictureKey + '.png')
            $bitmap.Save($previewPath, [System.Drawing.Imaging.ImageFormat]::Png)
            $writtenCount++
        } finally {
            $bitmap.Dispose()
        }
    }
    Write-Host "Wrote $writtenCount preview(s) of pack '$Pack' to $previewDir" -ForegroundColor Green
    return 0
}

function Export-EpEventRenders {
    param(
        [Parameter(Mandatory = $true)][string]$RepoRoot,
        [Parameter(Mandatory = $true)][string]$Pack,
        [string]$GameDir,
        [string]$OutputDir
    )

    $pythonExecutable = Get-EpPythonExecutable
    if (-not $pythonExecutable) {
        Write-Host 'Python 3 with Pillow is needed to render events.' -ForegroundColor Red
        return 1
    }
    $rendererArguments = @('-I', (Join-Path $RepoRoot 'tools\render_event_cards.py'), '--pack', $Pack, '--source-dir', (Join-Path $RepoRoot ('source\' + $Pack)), '--pack-dir', (Join-Path $RepoRoot ('packs\' + $Pack)))
    if ($GameDir) {
        $rendererArguments += @('--game-dir', $GameDir)
    }
    if ($OutputDir) {
        $rendererArguments += @('--out', $OutputDir)
    }
    & $pythonExecutable @rendererArguments | Out-Host
    return $LASTEXITCODE
}

function Invoke-EpValidation {
    param([Parameter(Mandatory = $true)][string]$RepoRoot)

    Write-Host "`n==> Checking the event pack sources and generated files..." -ForegroundColor Cyan
    return ((Invoke-EpCheck -RepoRoot $RepoRoot) -eq 0)
}
