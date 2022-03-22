[string]$Destination = 'C:\Program Files\WindowsPowerShell\Modules\PomodoroPS'


Get-ChildItem -Path $PSScriptRoot -Filter "*.psm1" | ForEach-Object {
    # Test for Folder
    if((Test-Path -Path "$Destination") -ne $true){
        New-Item -Path "$Destination" -ItemType Directory -Force -Verbose
    }
    Copy-Item -Path $_.FullName -Destination "$Destination" -Force -Verbose
    Import-Module -Name ($_.Name).Substring(0,$(($_.Name).Length - 5)) -Force -Verbose
}