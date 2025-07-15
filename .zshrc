# Define Functions
_CDR() {
    cd "$(git rev-parse --show-toplevel)"
}

FZF_CD() {
    dr=$(fd -t d -H -E 'node_modules' -E '.git' | fzf --border-label='fzf cd') && cd "$dr"
}

lg() {
    export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir
    lazygit "$@"
    [ -f "$LAZYGIT_NEW_DIR_FILE" ] && cd "$(cat "$LAZYGIT_NEW_DIR_FILE")" && rm -f "$LAZYGIT_NEW_DIR_FILE"
}

GHWF() {
    local selected_files
    selected_files=$(gh workflow list --limit 100 | fzf -m --preview='' | cut -f1)

  if [[ -z "$selected_files" ]]; then
    echo "🚫 No workflow selected."
    return 1
  fi

  for workflow_file in ${(f)selected_files}; do
    echo "▶️ Running workflow '$workflow_file' on ref production"
    gh workflow run "$workflow_file" --ref production
  done
}

# Oh-My-Zsh Setup
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
source "$ZSH/oh-my-zsh.sh"

# Zinit Setup
export ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
[ ! -d "$ZINIT_HOME/.git" ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "$ZINIT_HOME/zinit.zsh"

(( ${+_comps} )) && _comps[zinit]=_zinit

# Zinit Plugins
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light Aloxaf/fzf-tab
zinit light lukechilds/zsh-nvm
zinit light mroth/evalcache

# Oh-My-Zsh Plugins
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

autoload -Uz _zinit

# NVM Config
export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true

# Oh-My-Zsh Plugins
plugins=(evalcache zsh-nvm git npm docker docker-compose terraform)

# Enable ngrok completion if available
command -v ngrok &>/dev/null && _evalcache ngrok completion

# History Options
setopt hist_ignore_dups hist_save_no_dups hist_ignore_space hist_find_no_dups

# FZF & Zoxide Setup
unalias zi
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':omz:plugins:nvm' lazy yes
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
_evalcache fzf --zsh
_evalcache zoxide init zsh
_evalcache mise activate zsh

# Environment Variables
export PATH="$HOME/Library/Android/sdk/platform-tools:$HOME/Library/Android/sdk/build-tools/35.0.0:$HOME/Library/Android/sdk/tools/bin:$PATH"
export ANDROID_NDK_HOME="$HOME/Library/Android/sdk/ndk/21.4.7075529"
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$HOME/.local/bin:$PATH"
export PATH="/usr/local/opt/libpq/bin:/opt/homebrew/opt/libpq/bin:$PATH"
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/postgresql@17/lib"
export CPPFLAGS="-I/opt/homebrew/opt/postgresql@17/include"

# Aliases
alias cdr=_CDR
alias cdd="_CDR && FZF_CD"
alias killport="lsof -i :\$1 | awk 'NR!=1 {print \$2}' | xargs kill"
alias mkdir='mkdir -p'
alias ls='eza --icons=auto'
alias lt='eza --tree --icons=auto'
alias v='nvim'
alias vdiff='nvim -d'
alias yz='yazi'
alias cat='bat'
alias c='clear'

# Fabric Aliases
alias fabric="fabric --stream"
alias gencm="git diff --staged | fabric -p summarize_git_diff"
alias sum="pbpaste | fabric -p summarize"
alias askcode="fabric -p coding_master"
alias genpr="git --no-pager diff main | fabric -p write_pull-request"
alias now='echo $(( $(date +%s)*1000 + $(date +%N)/1000000 ))'
alias ghwf=GHWF
