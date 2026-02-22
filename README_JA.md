# dotfiles

[![license](https://img.shields.io/badge/LICENSE-MIT-green.svg)](LICENSE.md)

macOS 向け dotfiles 管理 (Apple Silicon)。

[English](README.md) | [Japanese](README_JA.md)

## Install

```bash
curl -sL https://raw.githubusercontent.com/hashiiiii/dotfiles/main/install.sh | bash
```

clone 先を指定する場合:

```bash
curl -sL https://raw.githubusercontent.com/hashiiiii/dotfiles/main/install.sh | bash -s -- -o ~/path/to/dotfiles
```

デフォルトは `~/.dotfiles` です。インストール後、ターミナルを再起動してください。

### Details

- Homebrew パッケージ、cask、Mac App Store アプリを `Brewfile` 経由でインストール
- dotfiles (`.config/*`, `.zsh`, `.zshrc`) を `$HOME` にシンボリックリンク
- ZSH を Sheldon プラグインマネージャ、fzf、zsh-abbr で構成
- mise によるランタイムバージョン管理 (Node.js, Python, Ruby, Go, .NET)
- macOS システム環境設定の適用 (キーリピート、Finder 設定)

既存ファイルは変更前に `.backup` 拡張子でバックアップされます。

## Restore

```bash
make restore
```

## Customization

- **パッケージ**: `Brewfile` を編集
- **ZSH プラグイン**: `.config/sheldon/plugins.toml` を編集 ([Sheldon ドキュメント](https://sheldon.cli.rs/Introduction.html))
- **略語**: `.config/zsh-abbr/user-abbreviations` を編集
- **自作関数**: `.zsh/plugins/foo.zsh` として追加

## License

[MIT](LICENSE.md)
