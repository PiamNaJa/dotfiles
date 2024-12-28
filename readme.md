# Install Brew

```/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"```

# Install zshrc

```sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"```

# Set default zsh

```chsh -s /bin/zsh```

# Install Package

```brew install neovim git stow fork maccy postman```

# Clone Dotfiles

```
cd ~
git clone https://github.com/PiamNaJa/dotfiles.git
cd dotfiles
stow .
```
