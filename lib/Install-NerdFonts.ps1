###################################################################################
# Execute this script in Windows PowerShell to copy Nerd Fonts from WSL to Windows.
###################################################################################

param(
  [string]$Username
)

if (-not $Username) {
  $scriptPath = $MyInvocation.MyCommand.Path
  Write-Host "Error: Username parameter is missing. Please provide your WSL username." -ForegroundColor Red
  Write-Host "Usage: powershell -ExecutionPolicy Bypass -File `"$scriptPath`" -Username your_username" -ForegroundColor Yellow
  exit 1
}

$wslFonts = "\\wsl$\Debian\home\$Username\.local\share\fonts"
$winFonts = "$env:WINDIR\Fonts"

Write-Host "Copying fonts from $wslFonts to $winFonts..." -ForegroundColor Cyan

Copy-Item -Path "$wslFonts\*" -Destination $winFonts -Recurse -Force

Write-Host "Fonts have been copied to $winFonts. You might need to restart or log off/on for changes to take effect." -ForegroundColor Green
