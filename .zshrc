export ZSH="$HOME/.oh-my-zsh"                                                                                               
                                                                                                                            
ZSH_THEME="agnoster"                                                                                                        
                                                                                                                            
CASE_SENSITIVE="true"                                                                                                       
                                                                                                                            
plugins=(                                                                                                                   
  git                                                                                                                       
  docker                                                                                                                    
  docker-compose                                                                                                            
  kubectl                                                                                                                   
  zsh-autosuggestions                                                                                                       
  zsh-completions                                                                                                           
  zsh-kubectl-prompt                                                                                                        
)                                                                                                                           
                                                                                                                            
source $ZSH/oh-my-zsh.sh                                                                                                    
                                                                                                                            
# Preferred editor for local and remote sessions                                                                            
if [[ -n $SSH_CONNECTION ]]; then                                                                                           
  export EDITOR='vim'                                                                                                       
else                                                                                                                        
  export EDITOR='nvim'                                                                                                      
fi                                                                                                                          
                                                                                                                            
# nvm                                                                                                                       
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"          
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                                                                            
                                                                                                                            
                                                                                                                            
# Preferred editor for local and remote sessions                                                                            
if [[ -n $SSH_CONNECTION ]]; then                                                                                           
  export EDITOR='vim'                                                                                                       
else                                                                                                                        
  export EDITOR='mvim'                                                                                                      
fi                                                                                                                          
                                                                                                                            
# Aliases                                                                                                                   
alias vim="nvim"                                                                                                            
alias k="kubectl"                                                                                                           
                                                                                                                            
## git aliases                                                                                                              
alias gs="git status"                                                                                                       
alias grb="git rebase origin/master"                                                                                        
alias gp="git push origin"                                                                                                  
alias gpf="git push --force origin"                                                                                         
alias gco="git checkout"                                                                                                    
alias gcm="git commit -m"                                                                                                   
                                                                                                                            
source <(kubectl completion zsh)                                                                                            
                                                                                                                            
RPROMPT='%{$fg[blue]%}($ZSH_KUBECTL_PROMPT)%{$reset_color%}'                                                                
                                                                                                                            
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
