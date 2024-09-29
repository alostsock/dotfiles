" ----------------------------------------
" Load plugins
" ----------------------------------------
" Automatic install
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify a directory for plugins
call plug#begin(stdpath('data') . '/plugged')

" Editor features
Plug 'justinmk/vim-sneak'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary'
Plug 'f-person/git-blame.nvim'
Plug 'stevearc/oil.nvim'

" UI additions
Plug 'junegunn/seoul256.vim'
Plug 'airblade/vim-gitgutter'
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'

" Language support
Plug 'neovim/nvim-lspconfig'
Plug 'mhartington/formatter.nvim'
" https://github.com/hrsh7th/nvim-cmp#recommended-configuration
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

call plug#end()

" ----------------------------------------
" Editor settings
" ----------------------------------------
" Use `:help <option>` for documentation

set lazyredraw
set nowrap
" Allow autocmd filetype detection to actually do things
filetype on
" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup
" Makes nvim modify files instead of writing them whole.
" Allows inotify, webpack-dev-server to watch files for changes.
set backupcopy=yes
" Enable mouse usage (all modes)
set mouse=a
" Improve autocomplete popup behavior
set completeopt=longest,menuone,noinsert

" Always show signcolumn. Prevents buffer from moving when signs change.
set signcolumn=yes
set nofoldenable
" Show line numbers
set number
" Show Rulers
set colorcolumn=80,100,120

" Set height of the command line
set cmdheight=1
" Reduce plugin trigger delay
set updatetime=500
" Don't show completion messages from ins-completion-menu in command line
set shortmess+=c

" Show hidden characters
set list listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·

" Tab/space behavior
set expandtab " Change tabs to spaces
set tabstop=4
set softtabstop=4
set shiftwidth=4
autocmd FileType vim setlocal ts=2 sts=2 sw=2
autocmd FileType sh setlocal ts=2 sts=2 sw=2
autocmd FileType json setlocal ts=2 sts=2 sw=2
autocmd FileType yaml setlocal ts=2 sts=2 sw=2
autocmd FileType markdown setlocal ts=2 sts=2 sw=2
autocmd FileType html setlocal ts=2 sts=2 sw=2
autocmd FileType css setlocal ts=2 sts=2 sw=2
autocmd FileType scss setlocal ts=2 sts=2 sw=2
autocmd FileType javascript setlocal ts=2 sts=2 sw=2
autocmd FileType javascriptreact setlocal ts=2 sts=2 sw=2
autocmd FileType typescript setlocal ts=2 sts=2 sw=2
autocmd FileType typescriptreact setlocal ts=2 sts=2 sw=2
autocmd FileType lua setlocal ts=2 sts=2 sw=2

if executable('rg') == 1
  let $FZF_DEFAULT_COMMAND = "rg --files --no-ignore-vcs --hidden -g '!.git/'"
endif

" In WSL, yank to clipboard
if executable('clip.exe') == 1
  autocmd TextYankPost * if v:event.operator ==# 'y' | call system('clip.exe', @0) | endif
endif

" search case-insensitive, unless the pattern has capital letters
set ignorecase
set smartcase

" open new split panes to the right
set splitright

" ----------------------------------------
" Colors
" ----------------------------------------
set termguicolors
colorscheme seoul256
syntax enable

" Keep default terminal background color
hi Normal ctermbg=none guibg=none
hi SignColumn ctermbg=none guibg=none
hi LineNr ctermbg=none guibg=none

highlight Cursor guifg=steelblue

" Floating window colors
hi Pmenu ctermfg=248 guifg=#a8a897 ctermbg=236 guibg=#30302c
hi PmenuSel ctermfg=248 guifg=#a8a897 ctermbg=239 guibg=#4e4e43
hi NormalFloat ctermfg=248 guifg=#a8a897 ctermbg=236 guibg=#30302c

" Change Sneak match colors
hi Sneak ctermbg=grey guibg=grey

" ----------------------------------------
" Lightline config
" ----------------------------------------
set laststatus=2
set showtabline=2
" Use lightlines insert/normal/etc mode indicators instead of vim's builtins
set noshowmode

let g:lightline = {
\ 'colorscheme': 'seoul256',
\ 'active': {
\   'left': [ ['mode', 'paste'] ],
\   'right': [ ['lineinfo'], ['percent'], ['fileencoding'], ['filetype'] ]
\ },
\ 'tabline': {
\   'left': [ ['buffers'] ]
\ },
\ 'component_expand': {
\   'buffers': 'lightline#bufferline#buffers'
\ },
\ 'component_type': {
\   'buffers': 'tabsel'
\ }
\}

let g:lightline#bufferline#modified='*'
let g:lightline#bufferline#read_only='%'

" Invert color of selected/unselected buffers (bufferline)
let s:palette = g:lightline#colorscheme#seoul256#palette
let s:palette.tabline.left = [ ['#808070', '#30302c', 244, 236] ]
let s:palette.tabline.middle = [ ['#30302c', '#30302c', 236, 236] ]
let s:palette.tabline.tabsel = [ ['#a8a897', '#4e4e43', 248, 239] ]
" Hide the 'close' component in tabline (is there a better way?)
let s:palette.tabline.right = [ ['#30302c', '#30302c', 236, 236] ]

" Update lightline's status bar when buffers change
autocmd BufWritePost,TextChanged,TextChangedI * call lightline#update()

" ----------------------------------------
" Remap keys
" ----------------------------------------

" Reload init.vim
nnoremap <leader>r :source $MYVIMRC<CR>

" Ctrl + Backspace in insert mode
imap  <C-w>

" Switch through buffers quickly
nnoremap <leader>k :bnext<CR>
nnoremap <leader>j :bprev<CR>

" Close buffer
nnoremap <leader>d :bd<CR>

" Navigate splits
nmap <C-h> :wincmd h<CR>
nmap <C-j> :wincmd j<CR>
nmap <C-k> :wincmd k<CR>
nmap <C-l> :wincmd l<CR>

" fzf.vim commands
nnoremap <C-p> :Files<CR>
nnoremap <leader>= :Buffers<CR>

" Comment lines
nnoremap <C-_> :Commentary<CR>
xnoremap <C-_> :Commentary<CR>
inoremap <C-_> <Esc>:Commentary<CR>0i

" gitgutter hunk commands
nmap [g <Plug>(GitGutterPrevHunk)
nmap ]g <Plug>(GitGutterNextHunk)
nmap gp <Plug>(GitGutterPreviewHunk)
nmap gs <Plug>(GitGutterStageHunk)
nmap gu <Plug>(GitGutterUndoHunk)

" git blame commands
nnoremap <C-b> :GitBlameToggle<CR>
nnoremap gbc :GitBlameCopyCommitURL<CR>

" Oil
nnoremap - :Oil<CR>

" initialize Lua config
lua require('init')

