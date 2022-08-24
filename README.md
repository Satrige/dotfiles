# dotfiles

## Install the Vim-plug Plugin Manager ([full link](https://www.linode.com/docs/guides/how-to-install-neovim-and-plugins-with-vim-plug/))

To make it easier to install plugins, use the Vim-plug plugin manager. This plugin manager uses git to manage most plugins:

`curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim`

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

