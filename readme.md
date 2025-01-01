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
brew install neovim git stow fd fzf fork maccy postman
```

## Clone Dotfiles

```bash
cd ~
git clone https://github.com/PiamNaJa/dotfiles.git
cd dotfiles
stow .
```

## VimPlug

```bash
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```
