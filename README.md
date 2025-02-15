# Cross-Platform Dotfiles

A unified dotfiles management system that works seamlessly across Debian-based Linux distributions and macOS. This repository provides a consistent development environment regardless of the operating system you're using.

## Features

- 🔄 Cross-platform compatibility (Debian-based Linux and macOS)
- 🔒 Safe backup system for existing configurations
- 🛠 Automated development environment setup
- 📦 Package management (apt for Debian, Homebrew for both platforms)
- 🎨 Terminal customization with ZSH
- 🔤 Nerd Fonts installation

## Prerequisites

### Debian-based Linux
- sudo access
- Basic development tools (`curl`, `git`)

### macOS
- Administrator access
- Xcode Command Line Tools (will be installed automatically if missing)
- Apple Silicon or Intel processor (automatically detected)

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/dotfiles.git
   cd dotfiles
   ```

2. Run Makefile
   ```bash
   make setup
   make install
   ```

The script will automatically detect your OS and run the appropriate setup.

## Directory Structure

```
.
├── .config/          # Application configurations
├── .zsh/             # ZSH customizations
├── lib/              # Helper scripts
│   ├── backup.sh     # Backup functionality
│   └── log.sh        # Logging utilities
├── scripts/          # Installation scripts
│   ├── install.sh    # Main installation script
│   ├── common.sh     # Common setup for both platforms
│   ├── debian.sh     # Debian-specific setup
│   └── macosx.sh     # macOS-specific setup
└── dotfiles.conf     # Main configuration
```

## Configuration Files

- `dotfiles.conf`: Main configuration file defining dotfiles and Debian packages
- `dotfiles.macosx.conf`: macOS-specific configuration for Homebrew packages and casks
- `.Brewfile`: Homebrew packages common to both platforms

## Backup and Recovery

The installation process automatically backs up existing configurations with a `.backup` extension. To clean up backups:

```bash
make clean
```

## Contributing

Feel free to submit issues and pull requests for improvements or bug fixes.

## License

MIT License - feel free to use and modify as you like.
