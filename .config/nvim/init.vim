call plug#begin('~/.local/share/nvim/plugged')
  Plug 'KeitaNakamura/neodark.vim' " vim-plug
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  Plug 'scrooloose/nerdtree'
  Plug 'vim-airline/vim-airline'
  Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}}
  Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
  let g:coc_global_extensions = [
      \ 'coc-sh',
      \ 'coc-json',
      \ 'coc-eslint',
      \ 'coc-highlight',
      \ 'coc-docker',
      \]
call plug#end()

set termguicolors                " recommended
colorscheme neodark

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

set tabstop=8 softtabstop=0 expandtab shiftwidth=2 smarttab

set encoding=utf-8 " Necessary to show Unicode glyphs

" Start NERDTree when Vim starts with a directory argument.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

let NERDTreeShowHidden=1

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif

"                              Bindings


" Binding of Fuzzy Findings
nnoremap <C-f> :FZF<CR>
nnoremap <silent> <Leader>f :Rg<CR>
