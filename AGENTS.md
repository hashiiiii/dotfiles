# AGENTS.md

WHY-only notes for AI agents. WHAT is in [`README.md`](README.md) and [`mise.toml`](mise.toml).

- **`mise bootstrap`** converges machine setup from `mise.toml`; `bootstrap.sh` only installs Homebrew + mise.
- **`~/.config`** is a whole-directory symlink into this **public** repo. `.gitignore` excludes secrets, runtime paths, `docs/`, and `.superpowers/`.
- **Agent runtime directories** are not whole-directory symlinks because they contain credentials and generated state. Public settings use individual mappings in `mise.toml`.
- **`.agents/skills`** is the canonical source for vendored personal skills. Per-skill links preserve machine-local skills in `~/.agents/skills` and `~/.claude/skills`.
- **Portable rules** come from the [rules-for-ai](https://github.com/hashiiiii/rules-for-ai) plugin. `.config/claude/settings.json` pins the plugin without a submodule.
- **Brewfile** holds all Homebrew packages (mise brew backend does not cover casks / MAS).
- **No zsh plugin manager** — plugins are brew formulae sourced in `.zshrc`.
- **`.zprofile`** = login env/PATH; **`.zshrc`** = interactive shell.
- **`bootstrap.sh`** must remain POSIX `sh`.
- No automated rollback — recovery is manual.
