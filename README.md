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

## Neovim

Requires **Neovim 0.11+**. The config is written in Lua (`.config/nvim/init.lua`) and uses [lazy.nvim](https://github.com/folke/lazy.nvim) as the plugin manager (auto-bootstrapped on first launch).

### Install Neovim

```sh
# macOS
brew install neovim

# Ubuntu / Debian
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt-get update
sudo apt-get install neovim
```

### Plugins

Plugins are installed automatically on first launch via lazy.nvim. No manual steps required.

| Category | Plugin |
|---|---|
| Plugin manager | lazy.nvim |
| LSP | nvim-lspconfig + mason.nvim |
| Completion | nvim-cmp + LuaSnip |
| File explorer | nvim-tree.lua |
| Fuzzy finder | telescope.nvim |
| Statusline | lualine.nvim |
| Comments | Comment.nvim |
| Git | vim-fugitive, gitsigns.nvim |
| Colorscheme | tokyonight.nvim |
| Other | nvim-autopairs, which-key.nvim, nvim-treesitter |

### LSP servers

The following LSP servers are auto-installed via Mason on first launch:

rust-analyzer, typescript, gopls, pyright, lua, json, yaml, bash, dockerfile

