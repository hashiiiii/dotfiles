# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Commands

- `curl -fsSL https://raw.githubusercontent.com/hashiiiii/dotfiles/main/bootstrap.sh | sh` - One-line install on a fresh machine
- `mise bootstrap` - Re-converge this machine from `mise.toml` (idempotent)
- `mise bootstrap --dry-run` - Preview every step without changing anything
- `mise dotfiles status` - List managed dotfile symlinks and whether they are applied

## Architecture

macOS-specific dotfiles management driven by [mise](https://mise.jdx.dev). Machine
setup is **declarative**: almost everything lives in `mise.toml` and is applied by
`mise bootstrap` (an experimental mise feature). The only imperative code is the
thin POSIX entry script.

### Entry Point

- `bootstrap.sh` - POSIX `sh` (no bashisms; must run on a stock macOS shell). Installs
  only Homebrew and mise, clones the repo, then runs `mise dotfiles apply` followed by
  `mise bootstrap`. It deliberately does the minimum; everything else is declarative.

### Declarative Config

- **`mise.toml`** (repo root) - The machine-setup source of truth:
  - `[dotfiles]` - symlinks (`"target" = "source"` string form = symlink by default;
    sources are relative to config_root)
  - `[bootstrap.macos.defaults]` - macOS `defaults` (mise infers `-bool`/`-int`/`-float`
    from the TOML value type)
  - `[bootstrap.hooks.post-defaults]` - `killall Finder SystemUIServer` to reload the UI
  - `[bootstrap.user]` - login shell (`/bin/zsh`)
  - `[tasks.bootstrap]` - runs `brew bundle` and `pre-commit install` (runs every
    bootstrap; keep idempotent)
- **`.config/mise/config.toml`** - The **global** mise config (`[tools]`, `[env]`,
  `[settings]`). Runtime versions live here, NOT in `mise.toml`, to avoid duplication.
  `mise bootstrap` installs these at its tools step once `~/.config` is symlinked.
- **`Brewfile`** - Homebrew formulae, casks, and Mac App Store apps (native `brew bundle`
  format). Casks/MAS stay here because mise's package backend only handles formulae.

### Secrets

- **`.gitignore`** - `.config/*` is default-denied with an explicit allowlist of tracked
  tool dirs; credential files are re-excluded (defense-in-depth). `~/.config` is a
  whole-directory symlink into this PUBLIC repo, so this allowlist is the primary guard.
- **`.pre-commit-config.yaml`** - a `gitleaks` pre-commit hook (system binary via a
  `local` repo) scans the staged diff and blocks commits containing secrets.

### Key Design Decisions

- `~/.config` is symlinked as a whole directory (one symlink), matching the live setup.
- Dotfiles use symlink mode so real files stay in the repo, not scattered across `$HOME`.
- mise is installed/managed via Homebrew (single source); `mise bootstrap` requires a
  recent mise and `experimental = true` (set in both `mise.toml` and the global config).
- No automated restore: mise converges forward only. Manual recovery is documented in
  the README (`unlink` symlinks, `chsh` back, `brew uninstall`).

### ZSH Environment

- **Sheldon** for plugin management (`.config/sheldon/plugins.toml`); mise is activated
  via `eval "$(mise activate zsh)"` (PATH-resolved to the Homebrew binary).
- **zsh-abbr** for abbreviations (`.config/zsh-abbr/user-abbreviations`)
- **mise** for runtime version management (`.config/mise/config.toml`)
- Custom FZF commands in `.zsh/plugins/fzf-commands.zsh`: `fb` (branch switch), `sf` (file search)
- `.zshrc` keeps shell-startup writes minimal: static Homebrew PATH, `sheldon source`,
  history, prompt; the rest is delegated to sheldon plugins.
