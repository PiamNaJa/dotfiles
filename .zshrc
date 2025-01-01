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

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)

source $ZSH/oh-my-zsh.sh

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
if command -v ngrok &>/dev/null; then
  eval "$(ngrok completion)"
fi

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
eval "$(zoxide init zsh)"
alias cdr=_CDR
alias cdd="_CDR && FZF_CD"
alias killport="lsof -i :$1 | awk 'NR!=1 {print $2}' | xargs kill"
alias mkdir='mkdir -p'
alias ls='eza --icons=auto'
alias lt='eza --tree --icons=auto'
alias v='nvim'
alias vdiff='nvim -d'