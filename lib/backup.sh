#!/bin/bash

source "$DOTFILE_HOME/lib/log.sh"

backup_dotfile() {
    local src="$1"
    local dest="$2"

    # 既に正しいシンボリックリンクが設定済みならスキップ（冪等性）
    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
        logInfo "Already linked: $dest"
        return 0
    fi

    # 既存ファイル/リンクの処理
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        if [ ! -L "$dest" ]; then
            local backup="${dest}.backup"
            if [ -e "$backup" ]; then
                logWarn "Backup $backup already exists. Keeping existing backup."
            else
                mv "$dest" "$backup"
                logInfo "Backed up: $dest"
            fi
        else
            rm "$dest"
        fi
    fi

    # 親ディレクトリの作成（.config/ghostty等の個別リンク対応）
    local dest_dir
    dest_dir="$(dirname "$dest")"
    if [ ! -d "$dest_dir" ]; then
        mkdir -p "$dest_dir"
    fi

    ln -s "$src" "$dest"
    logOK "Linked: $dest -> $src"
}
