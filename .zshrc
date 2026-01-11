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

  local target_ref="production"
  if ! gh api "repos/:owner/:repo/branches/production" --silent >/dev/null 2>&1; then
    target_ref="main"
  fi

  for workflow_file in ${(f)selected_files}; do
    echo "▶️ Running workflow '$workflow_file' on ref $target_ref"
    gh workflow run "$workflow_file" --ref "$target_ref" &
  done
  wait
  echo "✅ All selected workflows have been triggered."
}

KILL_PORT() {
    lsof -t -i :"$1" | xargs kill
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

# Oh-My-Zsh Plugins
plugins=(evalcache git mise npm docker docker-compose terraform)

# Enable ngrok completion if available
command -v ngrok &>/dev/null && _evalcache ngrok completion

# History Options
setopt hist_ignore_dups hist_save_no_dups hist_ignore_space hist_find_no_dups

# FZF & Zoxide Setup
unalias zi
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
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
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/libpq/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libpq/include"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/p/.lmstudio/bin"
export MLX_ENABLE_FAST_KERNELS=1
export MLX_GPU_MEMORY_FRACTION=0.90
# End of LM Studio CLI section



# Aliases
alias cdr=_CDR
alias cdd="_CDR && FZF_CD"
alias killport=KILL_PORT
alias mkdir='mkdir -p'
alias ls='eza --icons=auto'
alias lt='eza --tree --icons=auto'
alias v='nvim'
alias vdiff='nvim -d'
alias yz='yazi'
alias cat='bat'
alias c='clear'
alias gty='open -a "ghostty" "$(pwd)"'

alias now='echo $(( $(date +%s)*1000 + $(date +%N)/1000000 ))'
alias ghwf=GHWF

# Added by Antigravity
export PATH="/Users/p/.antigravity/antigravity/bin:$PATH"
