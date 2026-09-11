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

The config requires **Neovim 0.12+**. It is written in Lua at
`.config/nvim/init.lua` and uses
[lazy.nvim](https://github.com/folke/lazy.nvim) as the plugin manager.

### Install on macOS

```sh
brew install neovim tree-sitter-cli ripgrep fd lazygit
```

The tools are used as follows:

- `tree-sitter-cli` and Apple Clang build Treesitter parsers;
- `ripgrep` and `fd` power file and text search;
- `lazygit` is opened by the Snacks Git view.

Git, `curl`, and `tar` are also required. macOS provides them after the Command
Line Tools are installed:

```sh
xcode-select --install
```

### Start Neovim

Put this repository's `.config/nvim` directory at `~/.config/nvim`, then run:

```sh
nvim
```

On the first launch, lazy.nvim installs the plugins, Mason installs the
configured language servers, and Treesitter installs its parsers. Wait for the
jobs to finish before restarting Neovim.

### Update and check the setup

Update plugins first:

```vim
:Lazy sync
```

Restart Neovim, then update the parsers and Mason registry:

```vim
:TSUpdate
:MasonUpdate
:Mason
```

In Mason, press `C` to check for old packages and `U` to update them. Check the
main parts of the setup with:

```vim
:checkhealth nvim-treesitter
:checkhealth vim.lsp
:checkhealth
```

`TSStatus` and `LspInfo` are not commands in this setup.

### Main plugins

Plugins are installed automatically on first launch via lazy.nvim. No manual steps required.

| Category | Plugin |
|---|---|
| Plugin manager | lazy.nvim |
| LSP | nvim-lspconfig + mason.nvim |
| Completion | nvim-cmp + LuaSnip |
| File explorer | nvim-tree.lua |
| Fuzzy finder / utilities | snacks.nvim (picker, dashboard, notifier, lazygit, terminal, indent guides, smooth scroll, word highlights, bufdelete, zen) |
| Statusline | lualine.nvim |
| Comments | Comment.nvim |
| Git | vim-fugitive, gitsigns.nvim, diffview.nvim |
| Colorscheme | everforest-nvim |
| Markdown | render-markdown.nvim (loads for `*.md` files and renders headings, code blocks, checkboxes, tables, and quotes in-buffer) |
| Search | highlight-current-n.nvim (`n` / `N` highlight the active search match) |
| Surround | nvim-surround (`ys`, `ds`, `cs`; custom `C` surround wraps text in Markdown fenced code blocks with a language prompt) |
| Other | nvim-autopairs, which-key.nvim, nvim-treesitter + treesitter-parser-registry |

### Notable keybindings

`<C-w>o` toggles Snacks zen mode (window zoom) instead of running one-way `:only`.

### Treesitter

The following parsers are installed automatically:

```text
rust, javascript, typescript, python, lua, yaml, go, json, bash, groovy,
dockerfile, markdown, markdown_inline, regex, terraform, hcl, tsx, html, css
```

Treesitter provides syntax highlighting and folds when a parser is available.
Other file types use indent-based folds.

### LSP servers

The following LSP servers are auto-installed via Mason on first launch:

```text
rust-analyzer, typescript-language-server, gopls, pyright,
lua-language-server, json-lsp, yaml-language-server,
bash-language-server, dockerfile-language-server
```
