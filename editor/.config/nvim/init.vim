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
Plug 'neovim/nvim-lspconfig'
Plug 'mhartington/formatter.nvim'

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
set colorcolumn=80,100,120

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
autocmd FileType sh setlocal ts=2 sts=2 sw=2
autocmd FileType javascript setlocal ts=2 sts=2 sw=2
autocmd FileType typescript setlocal ts=2 sts=2 sw=2
autocmd FileType typescriptreact setlocal ts=2 sts=2 sw=2
autocmd FileType markdown setlocal ts=2 sts=2 sw=2

" Better search for fzf, respects .gitignore
if executable('ag') == 1
  let $FZF_DEFAULT_COMMAND = 'ag -g ""'
endif

" Settings for vim-closetag
let g:closetag_filenames = '*.html,*.jsx'
let g:closetag_filetypes = 'html,javascriptreact,javascript.jsx,jsx'

" In WSL, yank to clipboard
if executable('clip.exe') == 1
  autocmd TextYankPost * if v:event.operator ==# 'y' | call system('clip.exe', @0) | endif
endif

" Improve autocomplete popup behavior
set completeopt=longest,menuone,noinsert

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
set noshowmode

let g:lightline = {
\   'colorscheme': 'seoul256',
\   'active': {
\       'left': [ ['mode', 'paste'] ],
\       'right': [ ['lineinfo'], ['percent'], ['fileencoding'], ['filetype'] ]
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
let mapleader = " "

" Reload init.vim
nnoremap <leader>r :source $MYVIMRC<CR>

" Ctrl + Backspace in insert mode
imap  <C-w>

" Switch to next buffer quickly
nnoremap <leader><leader> :bnext<CR>

" Close buffer
nnoremap <leader>d :bd<CR>

" Map fzf.vim commands
nnoremap <C-p> :Files<CR>
nnoremap <leader>] :Buffers<CR>

" Map omni completion commands
imap <C-space> <C-x><C-o>
imap <C-j> <C-n>
imap <C-k> <C-p>

" Map formatter.nvim
nnoremap <leader>f :Format<CR>

" Map netrw
nnoremap <leader>e :Explore<CR>

" ----------------------------------------
" Lua configs
" ----------------------------------------
lua << EOF

-- The following is modified from https://github.com/neovim/nvim-lspconfig#suggested-configuration

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = {
    'jsonls',
    'html',
    'cssls',
    'eslint',
    'tsserver',
}
for _, lsp in pairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
    flags = {
      -- This will be the default in neovim 0.7+
      debounce_text_changes = 150,
    }
  }
end

local format_prettier = function()
    return {
        exe = "npx",
        args = { "prettier", "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
        stdin = true,
    }
end

require('formatter').setup {
    logging = true,
    filetype = {
        typescript = { format_prettier },
        typescriptreact = { format_prettier },
    }
}

EOF
