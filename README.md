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

Public settings for Claude Code, Codex, and Cursor live below `.config/`.
`mise.toml` links each settings file into its product directory.
Runtime directories remain local because they contain credentials, history, caches, and generated state.

Vendored personal skills live in `.agents/skills/`.
Codex and Cursor load them through `~/.agents/skills/`.
Claude Code loads the same sources through `~/.claude/skills/`.
The `stop-ai-slop-jp` snapshot uses [upstream revision `e09d327`](https://github.com/iKora128/stop-ai-slop-jp/commit/e09d32796f253a62693885757cea484c275d06f2).
The `show-me` snapshot uses [upstream revision `3c26291`](https://github.com/humanlayer/skills/commit/3c2629142c5d437428269b1b722b08c0b87f574d).
The `hallmark` snapshot uses [upstream revision `13ac0ec`](https://github.com/Nutlope/hallmark/commit/13ac0ec7e148655948100b6396439e481361d690).
Each directory keeps its upstream MIT license.

Portable rules also come from the [rules-for-ai](https://github.com/hashiiiii/rules-for-ai) plugin.
`.config/claude/settings.json` pins this plugin for Claude Code.
See the rules-for-ai README for its Codex and Cursor setup.

To pick up a newer rules-for-ai:

```
/plugin marketplace update rules-for-ai
```

Setup: [`mise.toml`](mise.toml)
Packages: [`Brewfile`](Brewfile)
Runtimes: [`.config/mise/config.toml`](.config/mise/config.toml)
