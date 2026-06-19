# dotfiles

[![license](https://img.shields.io/badge/LICENSE-MIT-green.svg)](LICENSE.md)

Dotfiles management for macOS (Apple Silicon), driven by [mise](https://mise.jdx.dev).

[English](README.md) | [Japanese](README_JA.md)

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/hashiiiii/dotfiles/main/bootstrap.sh | sh
```

`bootstrap.sh` is plain POSIX `sh` and runs on a stock macOS shell. It installs
only Homebrew and mise, clones this repo to `~/workspace/dotfiles`, then hands
off to `mise bootstrap`, which converges everything else. Restart your terminal
afterwards (the login shell is set to zsh).

To clone elsewhere, set `DOTFILE_DIR`:

```bash
curl -fsSL https://raw.githubusercontent.com/hashiiiii/dotfiles/main/bootstrap.sh | DOTFILE_DIR=~/path/to/dotfiles sh
```

## How it works

Almost everything is declared in [`mise.toml`](mise.toml) and applied by
`mise bootstrap` (an experimental mise feature), which converges in order:

1. **Dotfiles** — `[dotfiles]` symlinks `~/.config`, `~/.zshrc`, `~/.zsh`,
   `~/.zprofile`, Claude settings/hooks, and the Xcode theme into `$HOME`.
2. **macOS defaults** — keyboard repeat, mouse scaling, and Finder preferences.
3. **Login shell** — set to `/bin/zsh`.
4. **Runtimes** — installed from `[tools]` in
   [`.config/mise/config.toml`](.config/mise/config.toml) (.NET, Python, Ruby,
   Go, Rust).
5. **`bootstrap` task** — runs `brew bundle` (Homebrew formulae, casks, and Mac
   App Store apps from [`Brewfile`](Brewfile)) and installs the commit-time
   secret hook. Casks/MAS live in the Brewfile because mise's package backend
   only handles formulae.

Re-running `mise bootstrap` is safe — anything already in its desired state is
skipped. Preview with `mise bootstrap --dry-run`.

## Re-converge an existing machine

```bash
cd ~/workspace/dotfiles && mise bootstrap        # add -n / --dry-run to preview
```

## Secrets

This repo is public and `~/.config` is a whole-directory symlink into it, so any
tool that writes under `~/.config/<tool>/` writes into the working tree. Two
layers guard against accidental leaks:

- **`.gitignore` allowlist** — `.config/*` is default-denied; only explicitly
  allowed tool dirs are tracked, with credential files re-excluded.
- **Commit-time scan** — a [gitleaks](https://github.com/gitleaks/gitleaks)
  pre-commit hook (see [`.pre-commit-config.yaml`](.pre-commit-config.yaml))
  blocks commits containing secret-shaped strings.

## Customization

- **Packages**: edit `Brewfile`
- **Runtimes**: edit `.config/mise/config.toml` (`[tools]`)
- **Machine setup** (dotfiles, macOS defaults, login shell): edit `mise.toml`
- **ZSH plugins**: `brew install <plugin>`, then `source` it in `.zshrc` (no plugin manager)
- **Aliases**: edit `.zsh/plugins/aliases.zsh`
- **Custom functions**: add `.zsh/plugins/foo.zsh`
- **Claude Code config**: edit `home/.claude/settings.json` / `home/.claude/hooks/`
- **Shell env / PATH**: edit `.zprofile`; interactive shell: edit `.zshrc`

## Manual recovery

There is no automated restore — mise converges forward, it does not roll back.
To undo changes:

- **Dotfiles**: `mise dotfiles status` lists every managed symlink; remove the
  ones you want with `unlink ~/.zshrc` (etc.).
- **Login shell**: `chsh -s /bin/bash` (or your previous shell).
- **Packages / defaults**: `brew uninstall …` / `defaults delete …` as needed.

## License

[MIT](LICENSE.md)
