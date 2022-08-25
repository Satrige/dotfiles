  1 export ZSH="$HOME/.oh-my-zsh"                                                                                           
  2                                                                                                                         
  3 ZSH_THEME="agnoster"                                                                                                    
  4                                                                                                                         
  5 CASE_SENSITIVE="true"                                                                                                   
  6                                                                                                                         
  7 plugins=(                                                                                                               
  8   git                                                                                                                   
  9   docker                                                                                                                
 10   docker-compose                                                                                                        
 11   kubectl                                                                                                               
 12   zsh-autosuggestions                                                                                                   
 13   zsh-completions                                                                                                       
 14   zsh-kubectl-prompt                                                                                                    
 15 )                                                                                                                       
 16                                                                                                                         
 17 source $ZSH/oh-my-zsh.sh                                                                                                
 18                                                                                                                         
 19 # Preferred editor for local and remote sessions                                                                        
 20 if [[ -n $SSH_CONNECTION ]]; then                                                                                       
 21   export EDITOR='vim'                                                                                                   
 22 else                                                                                                                    
 23   export EDITOR='nvim'                                                                                                  
 24 fi                                                                                                                      
 25                                                                                                                         
 26 # nvm                                                                                                                   
 27 export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"      
 28 [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                                                                        
 29                                                                                                                         
 30                                                                                                                         
 31 # Preferred editor for local and remote sessions                                                                        
 32 if [[ -n $SSH_CONNECTION ]]; then                                                                                       
 33   export EDITOR='vim'                                                                                                   
 34 else                                                                                                                    
 35   export EDITOR='mvim'                                                                                                  
 36 fi                                                                                                                      
 37                                                                                                                         
 38 # Aliases                                                                                                               
 39 alias vim="nvim"                                                                                                        
 40 alias k="kubectl"                                                                                                       
 41                                                                                                                         
 42 ## git aliases                                                                                                          
 43 alias gs="git status"                                                                                                   
 44 alias grb="git rebase origin/master"                                                                                    
 45 alias gp="git push origin"                                                                                              
 46 alias gpf="git push --force origin"                                                                                     
 47 alias gco="git checkout"                                                                                                
 48 alias gcm="git commit -m"                                                                                               
 49                                                                                                                         
 50 source <(kubectl completion zsh)                                                                                        
 51                                                                                                                         
 52 RPROMPT='%{$fg[blue]%}($ZSH_KUBECTL_PROMPT)%{$reset_color%}'                                                            
 53                                                                                                                         
 54 [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
