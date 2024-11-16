<#
    Windows Development VM Install Script
    To run:
        1. Open a new terminal window as Administrator
        2. Allow Script execution by running "Set-ExecutionPolicy Unrestricted"
        3. Execute with ".\win-ignition-key.ps1"
#>

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal( [Security.Principal.WindowsIdentity]::GetCurrent() )
if (-Not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "[!] Please run this script as administrator`n" -ForegroundColor Red
    Read-Host  "Press any key to continue"
    exit
}

. { Invoke-WebRequest -useb https://boxstarter.org/bootstrapper.ps1 } | Invoke-Expression
Get-Boxstarter -Force

Install-BoxstarterPackage -PackageName https://raw.githubusercontent.com/An00bRektn/ignition-key/main/boxstarter/windev.txt

# For everything that isn't in chocolatey - too lazy to make a custom
# package like flare or commando
New-Item -Path C:\Tools -ItemType Directory
# Path for Defender exclusions
New-Item -Path 'C:\Users\sreisz\Desktop\the-lab' -ItemType Directory

Invoke-WebRequest -Uri 'https://www.winitor.com/tools/pestudio/current/pestudio.zip' -OutFile C:\Tools\pestudio.zip
Invoke-WebRequest -Uri 'https://aka.ms/vs/17/release/vs_BuildTools.exe' -OutFile C:\Tools\vs_BuildTools.exe
Invoke-WebRequest -Uri 'http://sandsprite.com/CodeStuff/scdbg.zip' -OutFile C:\Tools\scdbg.zip
Invoke-WebRequest -Uri 'https://download.ericzimmermanstools.com/Get-ZimmermanTools.zip' -OutFile C:\Tools\Get-ZimmermanTools.zip
Invoke-WebRequest -Uri 'https://didierstevens.com/files/software/DidierStevensSuite.zip' -Outfile C:\Tools\DidierStevensSuite.zip

Expand-Archive C:\Tools\pestudio.zip -DestinationPath C:\Tools\pestudio
Expand-Archive C:\Tools\scdbg.zip -DestinationPath C:\Tools\scdbg
Expand-Archive C:\Tools\Get-ZimmermanTools.zip -DestinationPath C:\Tools\EricZimmermanTools
Expand-Archive C:\Tools\DidierStevensSuite.zip -DestinationPath C:\Tools\DidierStevensSuite

# A bunch of things that I don't want to automate because they're very likely to break :/
Write-Host "[+] Install Complete! Here's a checklist of things you might also want to do" -ForegroundColor Green
Write-Host "  \\--> Set the wallpaper" -ForegroundColor Yellow
Write-Host "  \\--> VS Build tool setup in C:\Tools" -ForegroundColor Yellow
Write-Host "  \\--> Download BurpSuite? (https://portswigger.net/burp/releases/professional-community-2022-8-2)" -ForegroundColor Yellow
Write-Host "  \\--> Create an exception for Defender so it doesn't choke and die (also probably grab ThreatCheck)" -ForegroundColor Yellow

Read-Host "Press any key to continue..."
exit
