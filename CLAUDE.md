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
This is a macOS-specific dotfiles management system. The system uses a modular architecture with the following configuration file:

- **macos.conf** - macOS-specific packages, casks, and app store applications

### Core Library System (`lib/` directory)
The system is built around five interconnected bash libraries:

1. **log.sh** - Centralized logging system with colored output and timestamps
2. **backup.sh** - Handles dotfile symlinking and backup creation (creates `.backup` files)
3. **font.sh** - Manages Nerd Fonts installation on macOS
4. **package.sh** - Installs development tools (mise, Homebrew)
5. **restore.sh** - Provides complete system rollback functionality

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
- Safe symlink management prevents data loss

### Platform-Specific Features
- **macOS**: Homebrew casks, Mac App Store integration, Apple Silicon/Intel detection

## File Structure
- `DOTFILES` array in `macos.conf` defines which directories are symlinked to `$HOME`
- Core configuration directories: `.config`, `.zsh`, `.zshrc`
- `install.sh` enforces macOS-only execution (rejects non-Darwin platforms)
- Modular design allows easy addition of new tools and configurations