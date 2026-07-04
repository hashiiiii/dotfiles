# dotfiles

Dotfiles for macOS, managed with [mise](https://mise.jdx.dev).

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

## AI agent configs

Claude Code / cursor-agent configs live in
[rules-for-ai](https://github.com/hashiiiii/rules-for-ai) and deploy
themselves:

```bash
git clone https://github.com/hashiiiii/rules-for-ai.git ~/workspace/rules-for-ai
cd ~/workspace/rules-for-ai && mise dotfiles apply
```

Setup: [`mise.toml`](mise.toml)
Packages: [`Brewfile`](Brewfile)
Runtimes: [`.config/mise/config.toml`](.config/mise/config.toml)
