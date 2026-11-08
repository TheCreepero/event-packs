[CmdletBinding(DefaultParameterSetName = 'Deploy')]
param(
    [Parameter(ParameterSetName = 'Deploy')]
    [switch]$Deploy,

    [Parameter(ParameterSetName = 'DevLink')]
    [switch]$DevLink,

    [Parameter(ParameterSetName = 'Package')]
    [switch]$Package,

    [Parameter(ParameterSetName = 'PublishSteam')]
    [switch]$PublishSteam,

    [Parameter(ParameterSetName = 'InstallSteamCmd')]
    [switch]$InstallSteamCmd,

    [Parameter(ParameterSetName = 'ValidateOnly')]
    [switch]$ValidateOnly,

    [Parameter(ParameterSetName = 'Test')]
    [switch]$Test,

    [Parameter(ParameterSetName = 'NewPack', Mandatory = $true)]
    [switch]$NewPack,

    [Parameter(ParameterSetName = 'NewPack', Mandatory = $true)]
    [string]$Tag,

    [Parameter(ParameterSetName = 'NewPack', Mandatory = $true)]
    [string]$DisplayName,

    [Parameter(ParameterSetName = 'Generate', Mandatory = $true)]
    [switch]$Generate,

    [Parameter(ParameterSetName = 'FetchPicture', Mandatory = $true)]
    [switch]$FetchPicture,

    [Parameter(ParameterSetName = 'FetchPicture', Mandatory = $true)]
    [string]$File,

    [Parameter(ParameterSetName = 'FetchPicture', Mandatory = $true)]
    [Parameter(ParameterSetName = 'RemovePicture', Mandatory = $true)]
    [string]$Key,

    [Parameter(ParameterSetName = 'FetchPicture')]
    [string]$Crop,

    [Parameter(ParameterSetName = 'FetchPicture')]
    [string]$Tone,

    [Parameter(ParameterSetName = 'RemovePicture', Mandatory = $true)]
    [switch]$RemovePicture,

    [Parameter(ParameterSetName = 'ConvertPictures', Mandatory = $true)]
    [switch]$ConvertPictures,

    [Parameter(ParameterSetName = 'PreviewPictures', Mandatory = $true)]
    [switch]$PreviewPictures,

    [Parameter(ParameterSetName = 'RenderEvents', Mandatory = $true)]
    [switch]$RenderEvents,

    [Parameter(ParameterSetName = 'RenderEvents')]
    [string]$GameDir,

    [Parameter(ParameterSetName = 'Check', Mandatory = $true)]
    [switch]$Check,

    [Parameter(ParameterSetName = 'ApplyPlan', Mandatory = $true)]
    [switch]$ApplyPlan,

    [Parameter(ParameterSetName = 'Check')]
    [Parameter(ParameterSetName = 'ApplyPlan', Mandatory = $true)]
    [string]$Plan,

    [Parameter(ParameterSetName = 'Audit', Mandatory = $true)]
    [switch]$Audit,

    [Parameter(ParameterSetName = 'SyncMirrors', Mandatory = $true)]
    [switch]$SyncMirrors,

    [Parameter(ParameterSetName = 'TestMod', Mandatory = $true)]
    [switch]$TestMod,

    [switch]$Validate,
    [switch]$NoValidate,
    [switch]$Clean,
    [switch]$Force,

    [string]$ModDir,
    [string]$ZipOutput,
    [string]$SteamUser,
    [string]$ChangeNote,
    [string]$SteamCmdPath,
    [switch]$DryRun,
    [switch]$UpdateDescription,
    [string]$Pack,
    [string]$IncludeMembers,
    [switch]$CheckLinks
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'tools\HoiModBuild.ps1')
. (Join-Path $PSScriptRoot 'tools\EventPacks.ps1')
. (Join-Path $PSScriptRoot 'tools\EventPacksTestMod.ps1')

function Get-SelectedPackNames {
    if ($Pack) {
        return @($Pack)
    }
    return @(Get-EpPackNames -RepoRoot $PSScriptRoot)
}

switch ($PSCmdlet.ParameterSetName) {
    'NewPack' {
        if (-not $Pack) {
            Write-Host '-NewPack needs -Pack <key>, such as -Pack finland' -ForegroundColor Red
            exit 1
        }
        exit ([int](@(Invoke-EpNewPack -RepoRoot $PSScriptRoot -Pack $Pack -Tag $Tag -DisplayName $DisplayName)[-1]))
    }
    'Generate' {
        $worstExitCode = 0
        foreach ($packName in (Get-SelectedPackNames)) {
            $packExitCode = [int](@(Invoke-EpGenerate -RepoRoot $PSScriptRoot -Pack $packName -DryRun:$DryRun)[-1])
            if ($packExitCode -ne 0) { $worstExitCode = $packExitCode }
        }
        exit $worstExitCode
    }
    'FetchPicture' {
        if (-not $Pack) {
            Write-Host '-FetchPicture needs -Pack <key>' -ForegroundColor Red
            exit 1
        }
        exit ([int](@(Invoke-EpFetchPicture -RepoRoot $PSScriptRoot -Pack $Pack -File $File -Key $Key -Crop $Crop -Tone $Tone -DryRun:$DryRun)[-1]))
    }
    'RemovePicture' {
        if (-not $Pack) {
            Write-Host '-RemovePicture needs -Pack <key>' -ForegroundColor Red
            exit 1
        }
        exit ([int](@(Invoke-EpRemovePicture -RepoRoot $PSScriptRoot -Pack $Pack -Key $Key -DryRun:$DryRun)[-1]))
    }
    'ConvertPictures' {
        $worstExitCode = 0
        foreach ($packName in (Get-SelectedPackNames)) {
            $packExitCode = [int](@(Invoke-EpConvertPictures -RepoRoot $PSScriptRoot -Pack $packName -Force:$Force)[-1])
            if ($packExitCode -ne 0) { $worstExitCode = $packExitCode }
        }
        exit $worstExitCode
    }
    'PreviewPictures' {
        $worstExitCode = 0
        foreach ($packName in (Get-SelectedPackNames)) {
            $packExitCode = [int](@(Export-EpPicturePreviews -RepoRoot $PSScriptRoot -Pack $packName)[-1])
            if ($packExitCode -ne 0) { $worstExitCode = $packExitCode }
        }
        exit $worstExitCode
    }
    'RenderEvents' {
        $worstExitCode = 0
        foreach ($packName in (Get-SelectedPackNames)) {
            $packExitCode = [int](@(Export-EpEventRenders -RepoRoot $PSScriptRoot -Pack $packName -GameDir $GameDir)[-1])
            if ($packExitCode -ne 0) { $worstExitCode = $packExitCode }
        }
        exit $worstExitCode
    }
    'Check' {
        if ($Plan) {
            exit ([int](@(Invoke-EpPlanCheck -RepoRoot $PSScriptRoot -PlanPath $Plan -Pack $Pack)[-1]))
        }
        exit ([int](@(Invoke-EpCheck -RepoRoot $PSScriptRoot -Pack (Get-SelectedPackNames))[-1]))
    }
    'ApplyPlan' {
        exit ([int](@(Invoke-EpApplyPlan -RepoRoot $PSScriptRoot -PlanPath $Plan -Pack $Pack -DryRun:$DryRun)[-1]))
    }
    'Audit' {
        if (-not $Pack) {
            Write-Host '-Audit needs -Pack <key>' -ForegroundColor Red
            exit 1
        }
        exit ([int](@(Invoke-EpAudit -RepoRoot $PSScriptRoot -Pack $Pack)[-1]))
    }
    'SyncMirrors' {
        exit (Sync-ModSkillMirrors -RepoPath $PSScriptRoot)
    }
    'TestMod' {
        $launcherModDir = $(if ($ModDir) { $ModDir } else { Get-ModDefaultModDir })
        exit ([int](@(Invoke-EpTestMod -RepoRoot $PSScriptRoot -Pack (Get-SelectedPackNames) -ModDir $launcherModDir -DryRun:$DryRun)[-1]))
    }
}

$buildConfig = Get-ModBuildConfig -RepoDir $PSScriptRoot -ModDir $ModDir
$buildParameters = Select-ModBuildParameters -BoundParameters $PSBoundParameters
exit (Invoke-ModBuild -Config $buildConfig -ExtraValidation { Invoke-EpValidation -RepoRoot $PSScriptRoot } @buildParameters)
