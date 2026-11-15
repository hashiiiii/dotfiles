# AGENTS.md

WHY-only notes for AI agents. WHAT is in [`README.md`](README.md) and [`mise.toml`](mise.toml).

- **`mise bootstrap`** converges machine setup from `mise.toml`; `bootstrap.sh` only installs Homebrew + mise.
- **`~/.config`** is a whole-directory symlink into this **public** repo. `.gitignore` excludes secrets, runtime paths, `docs/`, and `.superpowers/`.
- **Agent runtime directories** are not whole-directory symlinks because they contain credentials and generated state. Public settings use individual mappings in `mise.toml`.
- **Portable rules and skills** come from the [rules-for-ai](https://github.com/hashiiiii/rules-for-ai) plugin. That repository owns skill source, upstream pins, patches, and checks; do not duplicate skill implementations here.
- **Agent installation settings** stay here. `.config/claude/settings.json` enables the plugin without a submodule; this repository owns OS packages and machine-specific configuration.
- **Brewfile** holds all Homebrew packages (mise brew backend does not cover casks / MAS).
- **No zsh plugin manager** — plugins are brew formulae sourced in `.zshrc`.
- **`.zprofile`** = login env/PATH; **`.zshrc`** = interactive shell.
- **`bootstrap.sh`** must remain POSIX `sh`.
- No automated rollback — recovery is manual.
