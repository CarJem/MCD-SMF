#region Definitions
Param([switch]$RemovePatch,[switch]$InstallPatch,[switch]$InstallMovies)

Function Write-NewLine {Write-Host "`r`n"}
Function Write-Divider {Write-Host "-----------------------------------------"}


Function Write-Step
{
    param($Message)
    Write-Host "$Message" -ForegroundColor Green
}
Function Write-SkipStep 
{
    param($Message)
    Write-Host "$Message" -ForegroundColor DarkGreen
}
Function Write-SemiStep 
{
    param($Message)
    Write-Host "$Message" -ForegroundColor Green
}
Function Write-SemiStep-Details
{
    param($Message)
    Write-Host "$Message" -ForegroundColor Magenta
}
Function Write-SemiStep-End 
{
    Write-Divider
}
Function Get-Confirmation 
{        
    $confirmation = Read-Host
    while($confirmation -ne "y")
    {
        if ($confirmation -eq 'n') {EndApp}
        $confirmation = Read-Host
    }
    Write-NewLine
}
Function Write-FileWarn
{
    param($message,$path,$question)
    Write-Host "$message" -NoNewline -ForegroundColor Yellow
    Write-Host " [$path]" -ForegroundColor Magenta
    Write-Host "$question" -ForegroundColor Yellow -NoNewLine
    Write-Host " [y/n] " -ForegroundColor Red -NoNewLine
}
Function Ask-To-Continue 
{
    Write-Host "Continue?" -ForegroundColor Yellow -NoNewLine  
    Write-Host " [y/n] " -ForegroundColor Red -NoNewLine
    Get-Confirmation
}
Function EndApp 
{
    Read-Host "Press any key to exit"
    exit
}

#endregion Definitions

#region Self Elevate

if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
 if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
  $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" "+ $MyInvocation.Line
  Write-Host $CommandLine
  Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
  Exit
 }
}

#endregion Self Elevate

#region Variables
$ErrorActionPreference = "Stop"

$BinPath = Split-Path $MyInvocation.MyCommand.Path -Parent
$DataPath = $(Split-Path $BinPath -Parent) + "\data"
$DungeonsDir = Get-Content -Path "$BinPath\DungeonsDir.txt" -Raw
$TargetModsFolder = "$DungeonsDir\Paks\~mods"
$SourceModsFolder = "$DataPath\~mods"
$SourceMoviesFolder = "$DataPath\Movies"
$TargetMoviesFolder = "$DungeonsDir\Movies\"
#endregion Variables

#region Title
Write-Divider
Write-Host "  Minecraft Dungeons Mod Folder Manager  " -ForegroundColor DarkRed
Write-Host "             Version 2.0.0               " -ForegroundColor yellow
Write-Host "      Created by CarJem Generations      " -ForegroundColor yellow
Write-Divider
#endregion Title

#region Patch Remove
if ($RemovePatch) 
{

    Write-SemiStep "Preparing to Remove Patch..."
    Write-SemiStep-Details "Target: $TargetModsFolder"
    Write-SemiStep-End

    Ask-To-Continue

    Write-Step "Removing Patch..."

    #Test if the Patch Exists
    if (Test-Path -Path $TargetModsFolder) 
    {
        #It Exists, so Remove it
        (Get-Item "$TargetModsFolder").Delete()
        Write-Step "Patch Removed!"
    }
    else 
    {
        #There's nothing to remove, forget about it
        Write-SkipStep "Nothing to remove, Patch not found"
    }
}
#endregion Patch Remove

#region Patch Install
if ($InstallPatch)  
{    
    Write-SemiStep "Preparing to Install Patch..."
    Write-SemiStep-Details "Source: $SourceModsFolder"
    Write-SemiStep-Details "Target: $TargetModsFolder"
    Write-SemiStep-End

    Ask-To-Continue

    Write-Step "Installing Patch..."
  
    #Test for Folder Conflict
    if (Test-Path -Path $TargetModsFolder) 
    {  
        #There's a Folder Conflict, Prompt the user to determine our next action
        Write-FileWarn "A folder already exists at this location!" "$TargetModsFolder" "Are you sure you want to proceed? (If this is not a symbolic link, all files in this directory will be lost)"
        Get-Confirmation

        #If we are allowed to continue, procced by removing the conflicting directory
        Write-Step "Removing Folder Conflict..."
        (Get-Item "$TargetModsFolder").Delete()
    }

    #Create the Symbolic Link to the Source Mod Folder at the Target
    Write-Step "Creating Symbolic Link..."
    New-Item -ItemType SymbolicLink -Path "$TargetModsFolder" -Target "$SourceModsFolder"
    Write-NewLine
    Write-Step "Patch Installed!"

}
#endregion Patch Install

#region Install Movies
if ($InstallMovies) 
{
    Write-SemiStep "Preparing to Install Movies..."
    Write-SemiStep-Details "Source: $SourceMoviesFolder"
    Write-SemiStep-Details "Target: $TargetMoviesFolder"
    Write-SemiStep-End

    Ask-To-Continue

    Write-Step "Installing Movies..."
    Copy-Item -Path "$SourceMoviesFolder\*" -Destination "$TargetMoviesFolder" -Force -Recurse
    Write-Step "Movies Installed!"
}
#endregion Install Movies

EndApp

