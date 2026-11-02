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
