# dotfiles

[![license](https://img.shields.io/badge/LICENSE-MIT-green.svg)](LICENSE.md)

Dotfiles management for macOS (Apple Silicon).

[English](README.md) | [Japanese](README_JA.md)

## Install

```bash
curl -sL https://raw.githubusercontent.com/hashiiiii/dotfiles/main/install.sh | bash
```

To specify the clone directory:

```bash
curl -sL https://raw.githubusercontent.com/hashiiiii/dotfiles/main/install.sh | bash -s -- -o ~/path/to/dotfiles
```

Defaults to `~/.dotfiles`. Restart your terminal after installation.

### Details

- Installs Homebrew packages, casks, and Mac App Store apps via `Brewfile`
- Symlinks dotfiles (`.config/*`, `.zsh`, `.zshrc`) to `$HOME`
- Configures ZSH with Sheldon plugin manager, fzf, zsh-abbr
- Sets up mise for runtime version management (Node.js, Python, Ruby, Go, .NET)
- Applies macOS system preferences (keyboard repeat, Finder settings)

Existing files are backed up with `.backup` extension before modification.

## Restore

```bash
make restore
```

## Customization

- **Packages**: Edit `Brewfile`
- **ZSH plugins**: Edit `.config/sheldon/plugins.toml` ([Sheldon docs](https://sheldon.cli.rs/Introduction.html))
- **Abbreviations**: Edit `.config/zsh-abbr/user-abbreviations`
- **Custom functions**: Add `.zsh/plugins/foo.zsh`

## License

[MIT](LICENSE.md)
