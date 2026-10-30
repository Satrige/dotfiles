# dotfiles


## Zsh

### Install Oh My Zsh

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Install oh-my-posh

The prompt comes from [oh-my-posh](https://ohmyposh.dev), not from the Oh My Zsh
theme.

```sh
brew install jandedobbeleer/oh-my-posh/oh-my-posh
```

`.zshrc` starts it with the `amro` theme that ships with the package, so this
repository has no oh-my-posh config file:

```sh
eval "$(oh-my-posh init zsh --config $(brew --prefix oh-my-posh)/themes/amro.omp.json)"
```

### Install the tools used by .zshrc

- [nvm](https://github.com/nvm-sh/nvm#install--update-script): use the install
  script, because `.zshrc` loads it from `~/.nvm`;
- Go: `brew install go`. `~/go/bin` is on `PATH`;
- `kubectl`: comes with Docker Desktop.

### Install plugin zsh-autosuggestions for zsh

```
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

plugins=( 
    # other plugins...
    zsh-autosuggestions
)
```


## Install search engines

### FZF

```sh
brew install fzf
$(brew --prefix)/opt/fzf/install
```

The install script writes `~/.fzf.zsh`, and `.zshrc` loads that file.

### Ripgrep

```sh
brew install ripgrep
```

## Kitty

```sh
brew install --cask kitty
```

Put this repository's `.config/kitty/kitty.conf` at `~/.config/kitty/kitty.conf`.
It sets the Catppuccin Mocha colors, tabs, and splits (`Cmd+D`, `Cmd+Shift+D`,
and `Cmd+Z` to zoom).

The config asks for JetBrains Mono. If that font is not installed, kitty falls
back to Menlo. Kitty ships its own Nerd Font symbols, so oh-my-posh icons work
without an extra font.

## Neovim

The config requires **Neovim 0.12+**. It is written in Lua at
`.config/nvim/init.lua` and uses
[lazy.nvim](https://github.com/folke/lazy.nvim) as the plugin manager.

### Install on macOS

```sh
brew install neovim tree-sitter-cli ripgrep fd lazygit go
```

The tools are used as follows:

- `tree-sitter-cli` and Apple Clang build Treesitter parsers;
- `ripgrep` and `fd` power file and text search;
- `lazygit` is opened by the Snacks Git view;
- `go` provides `gofmt`, which formats Go files on save.

Git, `curl`, and `tar` are also required. macOS provides them after the Command
Line Tools are installed:

```sh
xcode-select --install
```

### Start Neovim

Copy this repository's `.config/nvim` directory to `~/.config/nvim`, then run the
command below. The files are copied, not symlinked, so copy them again after you
change them.

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

Normal-mode commands also work with the Russian keyboard layout, through
`langmap`.

### Formatting

Go files are formatted with `gofmt` on save. This is a small autocmd in
`init.lua`, not a plugin. If `gofmt` is not on `PATH`, Neovim shows a warning and
saves the file without formatting.

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
bash-language-server, dockerfile-language-server, terraform-ls
```
