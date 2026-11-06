BeforeAll {
    $script:RepoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
    . (Join-Path $script:RepoRoot 'tools\EventPacks.ps1')
    $script:PackNames = @(Get-EpPackNames -RepoRoot $script:RepoRoot)
}

Describe 'Pack descriptors' {
    It 'the repository has no descriptor of its own: every Workshop item is a pack' {
        Test-Path -LiteralPath (Join-Path $script:RepoRoot 'descriptor.mod') | Should -BeFalse
        $script:PackNames.Count | Should -BeGreaterThan 0
    }

    It 'every pack has a descriptor without BOM, named Event Pack: <country>, with a supported version and a thumbnail under 1 MB' {
        foreach ($packName in $script:PackNames) {
            $packData = Get-EpPack -RepoRoot $script:RepoRoot -Pack $packName
            $descriptorPath = Join-Path $packData.PackRoot 'descriptor.mod'
            Test-Path -LiteralPath $descriptorPath | Should -BeTrue -Because $packName
            $descriptorBytes = [System.IO.File]::ReadAllBytes($descriptorPath)
            ($descriptorBytes.Length -ge 3 -and $descriptorBytes[0] -eq 0xEF -and $descriptorBytes[1] -eq 0xBB -and $descriptorBytes[2] -eq 0xBF) | Should -BeFalse -Because "$packName descriptor.mod is written without BOM [ENC-002]"
            $descriptorText = [System.IO.File]::ReadAllText($descriptorPath, [System.Text.Encoding]::UTF8)
            $descriptorText | Should -Match ('(?m)^name="Event Pack: ' + [regex]::Escape($packData.DisplayName) + '"')
            $descriptorText | Should -Match '(?m)^supported_version="\d+\.\d+(\.\*|\.\d+)?"'
            $descriptorText | Should -Match '(?m)^picture="thumbnail\.png"'
            $thumbnailPath = Join-Path $packData.PackRoot 'thumbnail.png'
            Test-Path -LiteralPath $thumbnailPath | Should -BeTrue -Because $packName
            (Get-Item -LiteralPath $thumbnailPath).Length | Should -BeLessThan 1MB
        }
    }

    It 'every pack and bundle has its own launcher folder name' {
        $settings = Read-EpJson -Path (Join-Path $script:RepoRoot 'tools\HoiModBuild.json')
        $itemNames = @($script:PackNames) + @(Get-EpBundleNames -RepoRoot $script:RepoRoot)
        $folderNames = @($itemNames | ForEach-Object { $settings.packages.$_.modFolderName })
        @($folderNames | Sort-Object -Unique).Count | Should -Be $itemNames.Count
    }

    It 'the bundle is named Immersive Events Expanded, carries the tags of its packs and the supported version of its members, and has a thumbnail under 1 MB' {
        $bundleNames = @(Get-EpBundleNames -RepoRoot $script:RepoRoot)
        $bundleNames.Count | Should -Be 1
        foreach ($bundleName in $bundleNames) {
            $bundleData = Get-EpBundle -RepoRoot $script:RepoRoot -Bundle $bundleName
            $descriptorPath = Join-Path $bundleData.PackRoot 'descriptor.mod'
            $descriptorBytes = [System.IO.File]::ReadAllBytes($descriptorPath)
            ($descriptorBytes.Length -ge 3 -and $descriptorBytes[0] -eq 0xEF -and $descriptorBytes[1] -eq 0xBB -and $descriptorBytes[2] -eq 0xBF) | Should -BeFalse -Because 'descriptor.mod is written without BOM [ENC-002]'
            $descriptorText = [System.IO.File]::ReadAllText($descriptorPath, [System.Text.Encoding]::UTF8)
            $descriptorText | Should -Match '(?m)^name="Immersive Events Expanded"\r?$'
            $descriptorText | Should -Match '(?m)^picture="thumbnail\.png"'
            $bundleTags = @([regex]::Matches(([regex]::Match($descriptorText, '(?s)tags\s*=\s*\{(.*?)\}').Groups[1].Value), '"([^"]+)"') | ForEach-Object { $_.Groups[1].Value } | Sort-Object)
            foreach ($memberName in $bundleData.Members) {
                $memberText = [System.IO.File]::ReadAllText((Join-Path $script:RepoRoot ('packs\' + $memberName + '\descriptor.mod')), [System.Text.Encoding]::UTF8)
                @([regex]::Matches(([regex]::Match($memberText, '(?s)tags\s*=\s*\{(.*?)\}').Groups[1].Value), '"([^"]+)"') | ForEach-Object { $_.Groups[1].Value } | Sort-Object) | Should -Be $bundleTags -Because "the tags of $memberName"
                [regex]::Match($memberText, '(?m)^supported_version="([^"]*)"').Groups[1].Value | Should -Be ([regex]::Match($descriptorText, '(?m)^supported_version="([^"]*)"').Groups[1].Value) -Because "the supported version of $memberName"
            }
            $thumbnailPath = Join-Path $bundleData.PackRoot 'thumbnail.png'
            Test-Path -LiteralPath $thumbnailPath | Should -BeTrue
            (Get-Item -LiteralPath $thumbnailPath).Length | Should -BeLessThan 1MB
        }
    }
}
