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

Machine-level settings for Claude Code / cursor-agent (`settings.json`,
statusline, MCP servers) live in this repo under `.config/claude` /
`.config/cursor`, symlinked into `~/.claude` / `~/.cursor` by this repo's
`mise.toml`. Portable rules and skills come from the
[rules-for-ai](https://github.com/hashiiiii/rules-for-ai) plugin, pinned
declaratively in `.config/claude/settings.json` (`extraKnownMarketplaces` +
`enabledPlugins`) — Claude Code installs it on session start. See the
rules-for-ai README for Codex / Cursor setup.

To pick up a newer rules-for-ai:

```
/plugin marketplace update rules-for-ai
```

Setup: [`mise.toml`](mise.toml)
Packages: [`Brewfile`](Brewfile)
Runtimes: [`.config/mise/config.toml`](.config/mise/config.toml)
