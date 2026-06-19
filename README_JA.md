# dotfiles

[mise](https://mise.jdx.dev) で構築する macOS 向け dotfiles 管理。

[English](README.md) | [Japanese](README_JA.md)

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/hashiiiii/dotfiles/main/bootstrap.sh | sh
```

デフォルトでは `~/workspace/dotfiles` に clone されます。完了後はターミナルを再起動してください。

clone 先を変える場合は `DOTFILE_DIR` を指定します:

```bash
curl -fsSL https://raw.githubusercontent.com/hashiiiii/dotfiles/main/bootstrap.sh | DOTFILE_DIR=~/path/to/dotfiles sh
```

## 再収束

```bash
cd ~/workspace/dotfiles && mise bootstrap
```

`DOTFILE_DIR` を指定した場合は、そのパスに読み替えてください。

構築: [`mise.toml`](mise.toml) · パッケージ: [`Brewfile`](Brewfile) · ランタイム: [`.config/mise/config.toml`](.config/mise/config.toml)
