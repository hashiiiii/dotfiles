# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Commands

- `make install` - Install the complete dotfiles system
- `make restore` - Restore previous configuration from backups
- `make setup` - Set executable permissions for all .sh files (must run before install)

## Architecture

macOS-specific dotfiles management system. Bash scripts with `set -euo pipefail`.

### Entry Points

- `scripts/install.sh` - Main installation script (run via `make install`)
- `scripts/restore.sh` - Restoration script (run via `make restore`, delegates to `lib/restore.sh`)

### Library (`lib/`)

- **log.sh** - Colored logging with timestamps (source guard prevents multiple loading)
- **backup.sh** - Idempotent dotfile symlinking with `.backup` creation
- **package.sh** - Homebrew and mise installation
- **restore.sh** - System rollback from `.backup` files

### Configuration

- **Brewfile** - Homebrew packages, casks, Mac App Store apps (native `brew bundle` format)
- **macos.conf** - `DOTFILES` array defining which `.config/*` subdirectories are symlinked to `$HOME`

### Key Design Decisions

- `.config` subdirectories are symlinked individually (not the entire `.config` directory)
- `backup_dotfile()` is idempotent: skips if symlink already correct, preserves existing `.backup` files
- `.zshrc` uses static `brew shellenv` instead of `eval` for faster shell startup
- Fonts installed via `brew cask` (font-jetbrains-mono-nerd-font), not custom scripts

### ZSH Environment

- **Sheldon** for plugin management (`.config/sheldon/plugins.toml`)
- **zsh-abbr** for abbreviations (`.config/zsh-abbr/user-abbreviations`)
- **mise** for runtime version management (`.config/mise/config.toml`)
- Custom FZF commands in `.zsh/plugins/fzf-commands.zsh`: `fb` (branch switch), `sf` (file search), `fd` (directory nav)
