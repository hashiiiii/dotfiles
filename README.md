# dotfiles

Dotfiles for macOS, managed with [mise](https://mise.jdx.dev).

Requires Xcode Command Line Tools (`xcode-select --install`).

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/hashiiiii/dotfiles/main/bootstrap.sh | sh
```

The default location is `~/workspace/dotfiles`. Restart your terminal after setup.

## Apply changes

```bash
cd ~/workspace/dotfiles && mise bootstrap
```

Edit [`mise.toml`](mise.toml) for links and macOS settings, [`Brewfile`](Brewfile) for packages, and [`.config/mise/config.toml`](.config/mise/config.toml) for runtimes.

## Agent rules and skills

[rules-for-ai](https://github.com/hashiiiii/rules-for-ai) owns portable agent rules and skills, including Hallmark and Show-me.
It also owns their upstream versions, local patches, and dependency checks.
This repository keeps plugin installation settings, agent configuration, and OS packages such as librsvg for SVG rendering.
Install or update the plugin to receive skill changes; do not copy skill implementations into dotfiles.
Separately installed skills use the Skills CLI version pinned in the global mise configuration; their installation records stay with that manager.
