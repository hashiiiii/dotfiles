# AGENTS.md

WHY-only notes for AI agents. WHAT is in [`README.md`](README.md) and [`mise.toml`](mise.toml).

- **`mise bootstrap`** converges machine setup from `mise.toml`; `bootstrap.sh` only installs Homebrew + mise.
- **`~/.config`** is a whole-directory symlink into this **public** repo — `.gitignore` denies secrets/runtime paths only.
- **`~/.claude`** is not whole-directory symlinked (runtime/secrets); only `.config/claude/settings.json` and `hooks/`.
- **Brewfile** holds all Homebrew packages (mise brew backend does not cover casks / MAS).
- **No zsh plugin manager** — plugins are brew formulae sourced in `.zshrc`.
- **`.zprofile`** = login env/PATH; **`.zshrc`** = interactive shell.
- **`bootstrap.sh`** must remain POSIX `sh`.
- No automated rollback — recovery is manual.
