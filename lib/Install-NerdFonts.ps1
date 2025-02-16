###################################################################################
# Install Nerd Fonts using Scoop package manager
###################################################################################

param(
    [string]$Username
)

# Get NERD_FONT from WSL environment
$nerdFont = wsl bash -c 'source ~/.dotfiles/dotfiles.conf && echo $NERD_FONT'
if (-not $nerdFont) {
    $nerdFont = "JetBrainsMono"  # Fallback font if not set
}

# Check if Scoop is installed
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "Scoop is not installed. Installing Scoop..." -ForegroundColor Yellow
    try {
        # Install Scoop
        Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
        Invoke-RestMethod get.scoop.sh | Invoke-Expression
    } catch {
        Write-Host "Error installing Scoop: $_" -ForegroundColor Red
        exit 1
    }
}

Write-Host "Adding nerd-fonts bucket to Scoop..." -ForegroundColor Cyan
try {
    scoop bucket add nerd-fonts
} catch {
    Write-Host "Error adding nerd-fonts bucket: $_" -ForegroundColor Red
    exit 1
}

Write-Host "Installing $nerdFont Nerd Font..." -ForegroundColor Cyan
try {
    scoop install "$nerdFont-NF"
    Write-Host "`n$nerdFont Nerd Font has been installed successfully!" -ForegroundColor Green
    
    Write-Host "`nNext steps:" -ForegroundColor Yellow
    Write-Host "1. Open Windows Terminal" -ForegroundColor White
    Write-Host "2. Press Ctrl+Shift+, to open settings" -ForegroundColor White
    Write-Host "3. In the left sidebar, click on your profile (e.g., Ubuntu)" -ForegroundColor White
    Write-Host "4. Scroll down to 'Additional Settings' -> 'Appearance'" -ForegroundColor White
    Write-Host "5. Change 'Font face' to '$nerdFont NF'" -ForegroundColor White
    Write-Host "6. Click 'Save'" -ForegroundColor White
    Write-Host "`nYou might need to restart Windows Terminal for the changes to take effect." -ForegroundColor Yellow
} catch {
    Write-Host "Error installing font: $_" -ForegroundColor Red
    exit 1
}