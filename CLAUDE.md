# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Commands

### Installation and Setup
- `make install` - Install the complete dotfiles system
- `make restore` - Restore previous configuration from backups
- `make setup` - Set executable permissions for all .sh files (must run before install)

### Core Scripts
- `./scripts/install.sh` - Main installation script (run via `make install`)
- `./scripts/restore.sh` - Restoration script (run via `make restore`)

## Architecture and Structure

### Configuration Management System
This is a cross-platform dotfiles management system that works across macOS, Debian-based Linux, and WSL2. The system uses a modular architecture with platform-specific configuration files:

- **macos.conf** - macOS-specific packages, casks, and app store applications
- **debian.conf** - Debian/Ubuntu-specific apt packages and Homebrew packages

### Core Library System (`lib/` directory)
The system is built around six interconnected bash libraries:

1. **log.sh** - Centralized logging system with colored output, timestamps, and step tracking
2. **backup.sh** - Handles dotfile symlinking and backup creation with batch processing and validation
3. **font.sh** - Manages Nerd Fonts installation across platforms
4. **package.sh** - Unified package installation with error handling across package managers
5. **restore.sh** - Provides complete system rollback functionality with detailed error reporting
6. **common.sh** - Shared functions and validation logic used across platform scripts

### Plugin Management with Sheldon
The ZSH configuration uses Sheldon as the plugin manager:
- Configuration: `.config/sheldon/plugins.toml`
- Custom plugins in `.zsh/plugins/` directory
- Key plugins: zsh-defer, zsh-abbr, fast-syntax-highlighting, zsh-autosuggestions, fzf

### Development Environment Management
- **mise** (formerly rtx) manages runtime versions via `.config/mise/config.toml`
- Pre-configured versions: Node.js 22.14, Python 3.10, Ruby 3.4.2, Go 1.24.3, .NET 8
- Python virtual environment set to `~/.venv`

### Custom FZF Commands
Three custom FZF-powered commands in `.zsh/plugins/fzf-commands.zsh`:
- `fb` - Interactive Git branch switching
- `sf <search_term>` - Search file contents with preview
- `fd [query]` - Fast directory navigation based on file selection

### Backup and Restore System
- All existing files are backed up before modification (`.backup` extension)
- Complete restoration available via `make restore`
- Cache directories stored in `$XDG_CACHE_HOME` or `$HOME/.cache/dotfiles`
- Safe symlink management with comprehensive error handling prevents data loss
- Batch processing for multiple dotfiles with detailed success/failure reporting

### Platform-Specific Features
- **macOS**: Homebrew casks, Mac App Store integration, Apple Silicon/Intel detection
- **Linux**: APT package management, Homebrew on Linux support
- **WSL2**: Special font installation handling with PowerShell integration

## File Structure
- `DOTFILES` array in config files defines which directories are symlinked to `$HOME`
- Core configuration directories: `.config`, `.zsh`, `.zshrc`
- Platform detection automatically loads appropriate configuration
- Modular design allows easy addition of new tools and configurations