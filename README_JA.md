# dotfiles

[![license](https://img.shields.io/badge/LICENSE-MIT-green.svg)](LICENSE.md)

[mise](https://mise.jdx.dev) で構築する macOS 向け dotfiles 管理 (Apple Silicon)。

[English](README.md) | [Japanese](README_JA.md)

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/hashiiiii/dotfiles/main/bootstrap.sh | sh
```

`bootstrap.sh` は素の POSIX `sh` で書かれており、macOS 標準シェルだけで動きます。
Homebrew と mise のみをインストールし、本リポジトリを `~/workspace/dotfiles` に
clone した後、残りは `mise bootstrap` に委譲して収束させます。完了後はターミナルを
再起動してください (ログインシェルが zsh に設定されます)。

clone 先を変える場合は `DOTFILE_DIR` を指定します:

```bash
curl -fsSL https://raw.githubusercontent.com/hashiiiii/dotfiles/main/bootstrap.sh | DOTFILE_DIR=~/path/to/dotfiles sh
```

## 仕組み

ほぼ全ての設定は [`mise.toml`](mise.toml) に宣言され、`mise bootstrap`
(mise の experimental 機能) が以下の順で収束させます:

1. **Dotfiles** — `[dotfiles]` が `~/.config`・`~/.zshrc`・`~/.zsh`・`~/.zprofile`・
   Claude 設定/hooks・Xcode テーマを `$HOME` にシンボリックリンク。
2. **macOS defaults** — キーリピート、マウススケーリング、Finder の設定。
3. **ログインシェル** — `/bin/zsh` に設定。
4. **ランタイム** — [`.config/mise/config.toml`](.config/mise/config.toml) の
   `[tools]` からインストール (.NET, Python, Ruby, Go, Rust)。
5. **`bootstrap` タスク** — `brew bundle` で [`Brewfile`](Brewfile) の formula・
   cask・Mac App Store アプリをインストールし、コミット前の秘匿検知フックを設定。
   mise のパッケージ機能は formula のみ対応のため、cask/MAS は Brewfile に置く。

`mise bootstrap` は冪等で、既に目的の状態にあるものはスキップされます。
`mise bootstrap --dry-run` で事前確認できます。

## 既存マシンの再収束

```bash
cd ~/workspace/dotfiles && mise bootstrap        # -n / --dry-run で事前確認
```

## 秘匿情報

本リポジトリは公開で、`~/.config` はリポジトリへのディレクトリ丸ごとの
シンボリックリンクです。そのため `~/.config/<tool>/` に書き込むツールは作業ツリーへ
直接書き込みます。誤コミットを次の 2 層で防ぎます:

- **`.gitignore` allowlist** — `.config/*` をデフォルト deny し、明示的に許可した
  ツールディレクトリのみを追跡。認証情報ファイルは再 deny。
- **コミット前スキャン** — [gitleaks](https://github.com/gitleaks/gitleaks) の
  pre-commit フック ([`.pre-commit-config.yaml`](.pre-commit-config.yaml)) が、
  秘匿らしき文字列を含むコミットをブロック。

## カスタマイズ

- **パッケージ**: `Brewfile` を編集
- **ランタイム**: `.config/mise/config.toml` (`[tools]`) を編集
- **マシン構築** (dotfiles, macOS defaults, ログインシェル): `mise.toml` を編集
- **ZSH プラグイン**: `.config/sheldon/plugins.toml` を編集 ([Sheldon ドキュメント](https://sheldon.cli.rs/Introduction.html))
- **略語**: `.config/zsh-abbr/user-abbreviations` を編集
- **自作関数**: `.zsh/plugins/foo.zsh` として追加

## 手動リカバリ

自動 restore はありません (mise は前方収束のみで、ロールバックはしません)。
変更を戻すには:

- **Dotfiles**: `mise dotfiles status` で管理対象のシンボリックリンク一覧を確認し、
  戻したいものを `unlink ~/.zshrc` などで削除。
- **ログインシェル**: `chsh -s /bin/bash` (または以前のシェル)。
- **パッケージ / defaults**: 必要に応じて `brew uninstall …` / `defaults delete …`。

## License

[MIT](LICENSE.md)
