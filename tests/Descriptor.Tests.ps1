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

    It 'every pack has its own launcher folder name' {
        $settings = Read-EpJson -Path (Join-Path $script:RepoRoot 'tools\HoiModBuild.json')
        $folderNames = @($script:PackNames | ForEach-Object { $settings.packages.$_.modFolderName })
        @($folderNames | Sort-Object -Unique).Count | Should -Be $script:PackNames.Count
    }
}
