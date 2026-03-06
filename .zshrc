# Functions
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
    local selected_branch
    selected_branch=$(git branch --list 'main*' 'master*' 'develop*' 'dev*' 'prod*' 'production*' 'staging*' 'feature*' 'release*' 'hotfix*' 'test*' | sed 's|remotes/origin/||' | sort -u | fzf --border-label='Select branch')

    if [[ -z "$selected_branch" ]]; then
        echo "🚫 No branch selected."
        return 1
    fi

    local selected_files
    selected_files=$(gh workflow list --limit 100 | fzf -m --preview='' | cut -f1)

    if [[ -z "$selected_files" ]]; then
        echo "🚫 No workflow selected."
        return 1
    fi

    for workflow_file in ${(f)selected_files}; do
        echo "▶️ Running workflow '$workflow_file' on branch $selected_branch"
        gh workflow run "$workflow_file" --ref "$selected_branch" &
    done
    wait
    echo "✅ All selected workflows have been triggered."
}

WORK() {

    # 1. Handle optional "days" argument (default: 1 day)

    local days=${1:-1}

    local start_dir="$PWD"



    # Define Colors

    local B_BLUE='\033[1;34m'

    local B_GREEN='\033[1;32m'

    local B_YELLOW='\033[1;33m'

    local CYAN='\033[0;36m'

    local DIM='\033[2m'

    local NC='\033[0m' # No Color



    # --- PART 1: COMMITTED WORK ---

    echo -e "${B_BLUE}==========================================${NC}"

    echo -e " 📅 COMMITTED WORK (Last $days Days)"

    echo -e "${B_BLUE}==========================================${NC}"



    local found_commits=0



    # Optimization: Find .git folders 2 levels deep

    while IFS= read -r git_dir; do

        local repo_dir=$(dirname "$git_dir")

        cd "$repo_dir" || continue



        local current_author=$(git config user.name)

        [[ -z "$current_author" ]] && current_author=$(git config --global user.name)



        # Run git log

        local logs=$(git log --all --color=always --no-merges --since="${days} days ago" --author="$current_author" --format="%C(yellow)%h%Creset - %s %C(dim white)(%cr)%Creset %C(cyan)<%an>%Creset" 2>/dev/null)



        if [[ -n "$logs" ]]; then

            found_commits=1

            echo -e "${B_GREEN}📂 $repo_dir${NC}"

            echo "$logs"

            echo ""

        fi

        cd "$start_dir"

    done < <(find "$PWD" -maxdepth 2 -name .git -type d)



    [[ $found_commits -eq 0 ]] && echo "💤 No commits found in the last $days days."



    # --- PART 2: UNCOMMITTED WORK ---

    echo ""

    echo -e "${B_YELLOW}==========================================${NC}"

    echo -e " 🚧 UNCOMMITTED WORK (Files modified in last $days days)"

    echo -e "${B_YELLOW}==========================================${NC}"



    typeset -U dirty_repos

    dirty_repos=()



    # FIX: Use a Zsh Array for the arguments

    # This splits "-mtime" and "-1" into separate items safely

    local time_arg=(-mtime "-${days}")



    # 1. Find modified files

    while IFS= read -r file_path; do

        local curr_dir=$(dirname "$file_path")

        

        while [[ "$curr_dir" != "$start_dir" && "$curr_dir" != "/" ]]; do

            if [[ -d "$curr_dir/.git" ]]; then

                dirty_repos+=("$curr_dir")

                break

            fi

            curr_dir=$(dirname "$curr_dir")

        done

    # FIX: Expand the array using "${time_arg[@]}"

    done < <(find "$PWD" -maxdepth 4 -type d \( -name node_modules -o -name .git -o -name dist -o -name build -o -name coverage -o -name .next \) -prune -o -type f "${time_arg[@]}" -print)



    # 3. Check Status

    local found_wip=0

    for repo in "${dirty_repos[@]}"; do

        cd "$repo" || continue

        

        local status_out=$(git status -s)

        

        if [[ -n "$status_out" ]]; then

            found_wip=1

            echo -e "${B_GREEN}📂 $repo${NC}"

            git -c color.status=always status -s

            echo -e "${DIM}---------------------------------${NC}"

        fi

        cd "$start_dir"

    done



    [[ $found_wip -eq 0 ]] && echo "✨ No files modified in the last $days days."

}

KILL_PORT() {
    kill -9 $(lsof -t -i:"$1")
}

# Oh-My-Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
source "$ZSH/oh-my-zsh.sh"

# Zinit
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

# Zinit Snippets (Oh-My-Zsh)
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

autoload -Uz _zinit
plugins=(evalcache git mise npm docker docker-compose terraform)

# Completions
command -v ngrok &>/dev/null && _evalcache ngrok completion

# History
setopt hist_ignore_dups hist_save_no_dups hist_ignore_space hist_find_no_dups

# FZF & Zoxide
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
# LM Studio
export PATH="$PATH:/Users/p/.lmstudio/bin"
export MLX_ENABLE_FAST_KERNELS=1
export MLX_GPU_MEMORY_FRACTION=0.90
# Antigravity
export PATH="/Users/p/.antigravity/antigravity/bin:$PATH"

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
alias work=WORK
alias openclaw='cd $HOME/Documents/code/openclaw && docker compose run --rm openclaw-cli'