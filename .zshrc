export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

CASE_SENSITIVE="true"

plugins=(
  git
  docker
  docker-compose
  zsh-autosuggestions
  zsh-completions
  kubectl
)

alias vim="nvim"

source $ZSH/oh-my-zsh.sh

alias d=docker
alias dc="docker compose"
alias k=kubectl

# tippspiel aliases
alias use-staging-kube="export KUBECONFIG=~/.k8s/tippspiel-k8s-kubeconfig.yml"
alias ks="kubectl -n tippspiel-staging"
alias kp="kubectl -n tippspiel-production"
                                                                                                                            
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

source <(kubectl completion zsh)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
eval "$(oh-my-posh init zsh --config $(brew --prefix oh-my-posh)/themes/amro.omp.json)"
