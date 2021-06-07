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

Plug 'justinmk/vim-sneak'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" UI additions
Plug 'junegunn/seoul256.vim'
Plug 'airblade/vim-gitgutter'
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'

" Language support
Plug 'alvan/vim-closetag'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'rust-lang/rust.vim'
Plug 'elixir-editors/vim-elixir'

call plug#end()

" ----------------------------------------
" Editor settings
" ----------------------------------------
set nocompatible
set lazyredraw
set nowrap
" TextEdit might fail if hidden is not set.
set hidden
" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup
" Makes nvim modify files instead of writing them whole.
" Allows inotify, webpack-dev-server to watch files for changes.
set backupcopy=yes

" Set height of the command line
set cmdheight=1
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show signcolumn. Prevents buffer from moving when signs change.
set signcolumn=yes
set nofoldenable
" Line numbers
set number
" Colored column 80
call matchadd('ColorColumn', '\%81v', 100)

" Enable mouse usage (all modes)
set mouse=a

" Some netrw defaults
let g:netrw_banner = 0
let g:netrw_liststyle = 3

" Show hidden characters
set list listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·
" Change tabs to spaces
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" File type behavior
autocmd FileType javascript setlocal ts=2 sts=2 sw=2
autocmd FileType markdown setlocal ts=2 sts=2 sw=2

" Better search for fzf, respects .gitignore
if executable('ag') == 1
  let $FZF_DEFAULT_COMMAND = 'ag -g ""'
endif

" Settings for vim-closetag
let g:closetag_filenames = '*.html,*.jsx'
let g:closetag_filetypes = 'html,javascriptreact,javascript.jsx,jsx'

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

" Floating window colors
hi Pmenu ctermfg=248 guifg=#a8a897 ctermbg=236 guibg=#30302c
hi PmenuSel ctermfg=248 guifg=#a8a897 ctermbg=239 guibg=#4e4e43

" Change Sneak match colors
hi Sneak ctermbg=grey guibg=grey

" ----------------------------------------
" Lightline config
" ----------------------------------------
set laststatus=2
set showtabline=2
set noshowmode

let g:lightline = {
\   'colorscheme': 'seoul256',
\   'active': {
\       'left': [ ['mode', 'paste'] ],
\       'right': [ ['percent'], ['fileencoding'], ['filetype'] ]
\   },
\   'tabline': {
\       'left': [ ['buffers'] ]
\   },
\   'component_expand': {
\       'buffers': 'lightline#bufferline#buffers'
\   },
\   'component_type': {
\       'buffers': 'tabsel'
\   }
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
nnoremap <Leader>r :source $MYVIMRC<CR>

" Ctrl + Backspace in insert mode
imap  <C-w>

" Switch to next buffer quickly
nnoremap <leader><leader> :bnext<CR>
" Close buffer
nnoremap <leader>d :bd<CR>

" Map fzf.vim commands
nnoremap <C-p> :Files<CR>
nnoremap <leader>] :Buffers<CR>

" Map netrw
nnoremap <leader>e :Explore<CR>

" Format selection
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" :Prettier
command! -nargs=0 Prettier :CocCommand prettier.formatFile

nnoremap <leader>g :GitGutterPreviewHunk<CR>
nnoremap <leader>gu :GitGutterUndoHunk<CR>


" ----------------------------------------
" CoC config
" ----------------------------------------
let g:coc_global_extensions = [
\   'coc-markdownlint',
\   'coc-json',
\   'coc-html',
\   'coc-prettier',
\   'coc-tsserver',
\   'coc-eslint',
\   'coc-python',
\   'coc-elixir',
\   'coc-rust-analyzer',
\   'coc-go'
\]

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

