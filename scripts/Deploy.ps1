
<#
#ฬท๐   ๐๐ก๐ข ๐ข๐๐ก๐๐๐ฃ๐ค๐
#ฬท๐   ๐ตโโโโโ๐ดโโโโโ๐ผโโโโโ๐ชโโโโโ๐ทโโโโโ๐ธโโโโโ๐ญโโโโโ๐ชโโโโโ๐ฑโโโโโ๐ฑโโโโโ ๐ธโโโโโ๐จโโโโโ๐ทโโโโโ๐ฎโโโโโ๐ตโโโโโ๐นโโโโโ ๐งโโโโโ๐พโโโโโ ๐ฌโโโโโ๐บโโโโโ๐ฎโโโโโ๐ฑโโโโโ๐ฑโโโโโ๐ฆโโโโโ๐บโโโโโ๐ฒโโโโโ๐ชโโโโโ๐ตโโโโโ๐ฑโโโโโ๐ฆโโโโโ๐ณโโโโโ๐นโโโโโ๐ชโโโโโ.๐ถโโโโโ๐จโโโโโ@๐ฌโโโโโ๐ฒโโโโโ๐ฆโโโโโ๐ฎโโโโโ๐ฑโโโโโ.๐จโโโโโ๐ดโโโโโ๐ฒโโโโโ
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $True, Position = 0, HelpMessage="Run for x seconds")] 
    [string]$Path
)

function Set-DeployError {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $True, Position = 0)] 
        [string]$Message
    )
    Write-Output "================================================================"
    Write-Output "                             ERROR                              "
    Write-Output "================================================================"
    Write-Output "$Message"
    Write-Output "================================================================"
    exit -1
}
New-Alias -Name "logerr" -Value "Set-DeployError" -Force -ErrorAction Ignore | Out-Null


function Get-RootDirectory {
    Split-Path -Parent (Split-Path -Parent $PSCommandPath)
}

function Get-ScriptDirectory {
    Split-Path -Parent $PSCommandPath
}

$Script:ScriptsDirectory = Get-ScriptDirectory
$Script:RootDirectory = Get-RootDirectory
$Script:DllDirectory = Join-Path $Script:RootDirectory $Path
$Script:TestDirectory = Join-Path $Script:RootDirectory "test"
$Script:TestLibDirectory = Join-Path $Script:TestDirectory "lib"
$Script:TestLoadingDirectories = Join-Path $Script:TestDirectory "loading"

Remove-Item "$Script:TestLoadingDirectories" -Recurse -Force -ErrorAction Ignore | Out-Null


Write-Output "================================================================"
Write-Output "                            Deploy                              "
Write-Output "================================================================"


Write-Output "ScriptsDirectory $Script:ScriptsDirectory"
Write-Output "RootDirectory    $Script:RootDirectory"
Write-Output "DllDirectory     $Script:DllDirectory"

if(-not(Test-Path -Path "$Script:DllDirectory" -PathType Container)){
    logerr "Invalid Dll Path `"$Script:DllDirectory`""
}

Remove-Item "$Script:TestLibDirectory" -Recurse -Force -ErrorAction Ignore | Out-Null
New-Item "$Script:TestLibDirectory" -ItemType directory -Force -ErrorAction Ignore | Out-Null

ForEach($files in (gci "$Script:DllDirectory" -File -Filter "*.dll")){
    $fn = $files.Fullname
    $Copied = Copy-Item "$fn" "$Script:TestLibDirectory" -Force -Passthru
    Write-Output "Copied `"$fn`" => `"$Copied`""
}

exit 0