export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnoster"

CASE_SENSITIVE="true"

plugins=(
  git
  docker
  docker-compose
  # kubectl
  zsh-autosuggestions
  zsh-completions
  # zsh-kubectl-prompt
)

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Aliases
alias vim="nvim"
# alias k="kubectl"

## git aliases                                                                                                              
alias gs="git status"
alias grb="git rebase origin/master"
alias gp="git push origin"
alias gpf="git push --force origin"
alias gco="git checkout"
alias gcm="git commit -m"

git_create_branch() {
    local branch_name="$1"
    if [ -z "$branch_name" ]; then
        echo "Usage: create_git_branch <branch_name>"
        return 1
    fi

    git checkout -b "$branch_name"
    git push --set-upstream origin "$branch_name"
}

alias gcb="git_create_branch"

git_push_current_branch() {
    # Get the current branch name
    branch_name=$(git rev-parse --abbrev-ref HEAD)

    # Push the current branch with the -u flag
    git push -u origin "$branch_name"
}

alias gpuo="git_push_current_branch"

# source <(kubectl completion zsh)

# RPROMPT='%{$fg[blue]%}($ZSH_KUBECTL_PROMPT)%{$reset_color%}'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
