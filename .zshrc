_CDR() {
	cd $(git rev-parse --show-toplevel)
}

FZF_CD() {
	dr=$(
		fd -t d -H -E 'node_modules' -E '.git' | fzf \
			--preview '' \
			--border-label='fzf cd'
	) && test $? -eq 0 && cd $dr
}

lg() {
    export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir
    lazygit "$@"
    if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
            cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
            rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
    fi
}

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
source $ZSH/oh-my-zsh.sh

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light Aloxaf/fzf-tab
zinit light lukechilds/zsh-nvm
zinit light mroth/evalcache

zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

autoload -Uz _zinit

export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true
plugins=(evalcache zsh-nvm git npm docker docker-compose terraform)

if command -v ngrok &>/dev/null; then
  eval "$(ngrok completion)"
fi

setopt hist_ignore_dups
setopt hist_save_no_dups
setopt hist_ignore_space
setopt hist_find_no_dups

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':omz:plugins:nvm' lazy yes
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

_evalcache fzf --zsh
_evalcache zoxide init zsh


export PATH=$PATH:$HOME/Library/Android/sdk/platform-tools
export PATH=$PATH:$HOME/Library/Android/sdk/build-tools/35.0.0
export PATH=$PATH:$HOME/Library/Android/sdk/tools/bin
export ANDROID_NDK_HOME=$HOME/Library/Android/sdk/ndk/21.4.7075529
# export GOROOT=/opt/homebrew/bin/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$HOME/.local/bin:$PATH
alias fabric="fabric --stream"
alias gencm="git diff --staged | fabric -p summarize_git_diff"
alias sum="pbpaste | fabric -p summarize"
alias askcode="fabric -p coding_master"
alias genpr="git --no-pager diff main | fabric -p write_pull-request"
export PATH="/usr/local/opt/libpq/bin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
alias cdr=_CDR
alias cdd="_CDR && FZF_CD"
alias killport="lsof -i :$1 | awk 'NR!=1 {print $2}' | xargs kill"
alias mkdir='mkdir -p'
alias ls='eza --icons=auto'
alias lt='eza --tree --icons=auto'
alias v='nvim'
alias vdiff='nvim -d'
alias yz='yazi'
alias cat='bat'
alias c='clear'