call plug#begin('~/.local/share/nvim/plugged')
  Plug 'KeitaNakamura/neodark.vim' " vim-plug
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  " Git integration
  Plug 'tpope/vim-fugitive'
  " Git comments
  Plug 'scrooloose/nerdcommenter'
  Plug 'scrooloose/nerdtree'
  Plug 'vim-airline/vim-airline'
  Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}}
  Plug 'nvim-treesitter/nvim-treesitter'
  let g:coc_global_extensions = [
      \ 'coc-rust-analyzer',
      \ 'coc-sh',
      \ 'coc-json',
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
" autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif
                                                                                                                            
set number
set colorcolumn=120

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

                                                                                                                            
"                              Bindings                                                                                     
" Binding of Fuzzy Findings
nnoremap <C-f> :call fzf#run({'source': 'git ls-files', 'sink': 'e', 'window': {'width': 0.9, 'height': 0.6}})<CR>
nnoremap <silent> <Leader>f :Rg<CR>
nnoremap <silent> <Leader>F :Rg <C-R><C-W><CR>
nnoremap <silent> <Leader>d :call CocActionAsync("jumpDefinition", "tab drop")<CR>


" Binding of comments
nnoremap <C-\> :call nerdcommenter#Comment(0,"toggle")<CR>                                                                  
vnoremap <C-\> :call nerdcommenter#Comment(0,"toggle")<CR>

" Treesitter configuration for code folding
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()  " Use Treesitter for folding
set foldlevel=99  " Ensure all folds are open by default
set foldenable  " Enable folding

lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "rust", "javascript", "python", "lua" },  -- Add other languages if needed
  highlight = { enable = true },  -- Enable syntax highlighting
  indent = { enable = true },  -- Enable automatic indentation
  fold = { enable = true }  -- Enable code folding
}
EOF

