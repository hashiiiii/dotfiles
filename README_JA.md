# クロスプラットフォーム dotfiles

Debian系LinuxディストリビューションとmacOS間で一貫した開発環境を提供するdotfiles管理システムです。OSに依存せず、同じ開発体験を実現します。

## 特徴

- 🔄 クロスプラットフォーム対応（Debian系LinuxとmacOS）
- 🔒 既存設定の安全なバックアップ機能
- 🛠 開発環境の自動セットアップ
- 📦 パッケージ管理（Debian用apt、両プラットフォーム用Homebrew）
- 🎨 ZSHによるターミナルカスタマイズ
- 🔤 Nerd Fontsのインストール

## 前提条件

### Debian系Linux
- sudo権限
- 基本的な開発ツール（`curl`、`git`）

### macOS
- 管理者権限
- Xcode Command Line Tools（未インストールの場合は自動的にインストール）
- Apple SiliconまたはIntelプロセッサ（自動検出）

## インストール方法

1. リポジトリのクローン：
   ```bash
   git clone https://github.com/yourusername/dotfiles.git
   cd dotfiles
   ```

2. Makefileの実行：
   ```bash
   make setup
   make install
   ```

スクリプトが自動的にOSを検出し、適切なセットアップを実行します。

## ディレクトリ構成

```
.
├── .config/          # アプリケーション設定
├── .zsh/             # ZSHカスタマイズ
├── lib/              # ヘルパースクリプト
│   ├── backup.sh     # バックアップ機能
│   └── log.sh        # ログ機能
├── scripts/          # インストールスクリプト
│   ├── install.sh    # メインインストールスクリプト
│   ├── common.sh     # 共通セットアップ
│   ├── debian.sh     # Debian固有セットアップ
│   └── macosx.sh     # macOS固有セットアップ
└── dotfiles.conf     # メイン設定ファイル
```

## 設定ファイル

- `dotfiles.conf`: dotfilesとDebianパッケージを定義するメイン設定ファイル
- `dotfiles.macosx.conf`: macOS固有のHomebrewパッケージとCasks設定
- `.Brewfile`: 両プラットフォーム共通のHomebrewパッケージ

## バックアップと復元

インストール時に既存の設定ファイルは`.backup`拡張子で自動的にバックアップされます。
バックアップの削除は以下のコマンドで実行できます：

```bash
make clean
```

## トラブルシューティング

### Debian系Linux
- `sudo`コマンドでエラーが発生する場合は、ユーザーが`sudo`グループに所属しているか確認してください
- パッケージのインストールに失敗する場合は、`sudo apt update`を実行してパッケージリストを更新してください

### macOS
- Homebrewのインストールに失敗する場合は、XcodeとCommand Line Toolsが正しくインストールされているか確認してください
- Apple SiliconマシンでIntel用バイナリを使用する場合は、Rosetta 2が正しくインストールされているか確認してください

## 注意事項

- 既存の設定ファイルは自動的にバックアップされますが、重要なファイルは事前に手動でバックアップすることを推奨します
- システム環境設定の変更には管理者権限が必要です
- macOSのバージョンによって一部の機能が利用できない場合があります

## コントリビューション

バグ修正や機能改善のIssueやPull Requestは大歓迎です。

## ライセンス

MIT License - 自由に使用・改変していただけます。
