# dotfiles

Dotfiles for macOS, managed with [mise](https://mise.jdx.dev).

[English](README.md) | [Japanese](README_JA.md)

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/hashiiiii/dotfiles/main/bootstrap.sh | sh
```

The repo is cloned to `~/workspace/dotfiles` by default. Restart your terminal after install.

To use a different path, set `DOTFILE_DIR`:

```bash
curl -fsSL https://raw.githubusercontent.com/hashiiiii/dotfiles/main/bootstrap.sh | DOTFILE_DIR=~/path/to/dotfiles sh
```

## Re-converge

```bash
cd ~/workspace/dotfiles && mise bootstrap
```

Use your `DOTFILE_DIR` if you chose a non-default location.

Setup: [`mise.toml`](mise.toml)
Packages: [`Brewfile`](Brewfile)
Runtimes: [`.config/mise/config.toml`](.config/mise/config.toml)
