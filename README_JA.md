# macOS Dotfiles

[![license](https://img.shields.io/badge/LICENSE-MIT-green.svg)](LICENSE.md)

macOS 向け dotfiles 管理 (Apple Silicon / Intel)。

[English](README.md) | [Japanese](README_JA.md)

## インストール

```bash
git clone https://github.com/hashiiiii/dotfiles.git
cd dotfiles
make install
```

インストール後、ターミナルを再起動してください。

## 何をするか

- Homebrew パッケージ、cask、Mac App Store アプリを `Brewfile` 経由でインストール
- dotfiles (`.config/*`, `.zsh`, `.zshrc`) を `$HOME` にシンボリックリンク
- ZSH を Sheldon プラグインマネージャ、fzf、zsh-abbr で構成
- mise によるランタイムバージョン管理 (Node.js, Python, Ruby, Go, .NET)
- macOS システム環境設定の適用 (キーリピート、Finder 設定)

既存ファイルは変更前に `.backup` 拡張子でバックアップされます。

## 復元

```bash
make restore
```

## 構成

```
scripts/install.sh    メインインストールスクリプト
lib/
  log.sh              ログ出力
  backup.sh           シンボリックリンクとバックアップ管理
  package.sh          Homebrew / mise インストール
  restore.sh          ロールバック
Brewfile              Homebrew パッケージ定義
macos.conf            シンボリックリンク対象の dotfiles 一覧
.config/              各アプリケーションの設定
.zsh/                 ZSH プラグインと関数
.zshrc                ZSH 設定
```

## カスタマイズ

- **パッケージ**: `Brewfile` を編集
- **ZSH プラグイン**: `.config/sheldon/plugins.toml` を編集 ([Sheldon ドキュメント](https://sheldon.cli.rs/Introduction.html))
- **略語**: `.config/zsh-abbr/user-abbreviations` を編集
- **自作関数**: `.zsh/plugins/foo.zsh` として追加

## ライセンス

[MIT](LICENSE.md)
