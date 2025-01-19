# Set Up

## Install Brew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Install zshrc

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## Set default zsh

```bash
chsh -s /bin/zsh
```

## Install Package

```bash
brew install neovim git stow fd fzf fork maccy postman yazi ffmpeg sevenzip jq poppler fd ripgrep zoxide imagemagick font-symbols-only-nerd-font
```

## Themes

```bash
ya pack -a yazi-rs/flavors:catppuccin-macchiato
```

## Clone Dotfiles

```bash
cd ~
git clone https://github.com/PiamNaJa/dotfiles.git
cd dotfiles
stow .
```
