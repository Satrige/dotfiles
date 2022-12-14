# dotfiles


## Zsh plugins

### Install font for oh-my-zsh theme Agnoster

```
sudo apt-get install fonts-powerline
```

[Full link](https://github.com/agnoster/agnoster-zsh-theme)

### Install plugin zsh-completions


Clone the repository inside your oh-my-zsh repo:
```
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
```

Add it to FPATH in your .zshrc by adding the following line before source "$ZSH/oh-my-zsh.sh":
```
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
```

### Install plugin zsh-autosuggestions for zsh

```
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

plugins=( 
    # other plugins...
    zsh-autosuggestions
)
```

### Install zsh-kubectl-prompt

Clone the repo into oh-my-zsh custom plugins folder
```
git clone https://github.com/superbrothers/zsh-kubectl-prompt.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-kubectl-prompt
```

Configure your prompt (or check how to customize the theme plugin you are using)
```
RPROMPT='%{$fg[blue]%}($ZSH_KUBECTL_PROMPT)%{$reset_color%}'
```


## Install search engines

### FZF

```
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

### Ripgrep

```
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
sudo dpkg -i ripgrep_13.0.0_amd64.deb
```

## Install the Vim-plug Plugin Manager ([full link](https://www.linode.com/docs/guides/how-to-install-neovim-and-plugins-with-vim-plug/))

To make it easier to install plugins, use the Vim-plug plugin manager. This plugin manager uses git to manage most plugins:

`curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim`

## Instal the latest version of neovim

```sh
$ sudo add-apt-repository ppa:neovim-ppa/stable
$ sudo apt-get update
$ sudo apt-get install neovim
```

## Install NeoVim Plugins
### Nvim-completion-manager Plugin

nvim-completion-manager is a fast, extensible completion framework that supports a variety of programming languages and snippet solutions. Some of these are supported out of the box, while others require the installation of extra Python 3 modules to work. In this guide we illustrate the use of this plugin with UltiSnips, a robust snippet solution.

1. Install the NeoVim Python module:

`pip3 install --user neovim`

2. Add the following lines at the bottom of your ~/.config/nvim/init.vim file to include the snippets available through UltiSnips and vim-snippets:

```
call plug#begin()
Plug 'roxma/nvim-completion-manager'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
call plug#end()
```

3. Launch nvim, execute `PlugInstall`, update the plugins, and exit:

```
nvim
:PlugInstall
:UpdateRemotePlugins
:q!
```

