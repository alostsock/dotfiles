-- https://github.com/stevearc/oil.nvim?tab=readme-ov-file#quick-start
require('oil').setup({
  view_options = {
    -- Show files and directories that start with "."
    show_hidden = true,
  },
})

require('gitblame').setup({
  enabled = false,
})

-- https://github.com/hrsh7th/nvim-cmp#recommended-configuration
local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  mapping = {
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<C-k>'] = cmp.mapping(cmp.mapping.scroll_docs(-4)),
    ['<C-j>'] = cmp.mapping(cmp.mapping.scroll_docs(4)),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete()),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
  }, {
    { name = 'buffer' },
  })
})

-- Setup nvim-lspconfig
-- https://github.com/neovim/nvim-lspconfig/blob/master/test/minimal_init.lua

local on_attach = function(client, bufnr)
  -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  local opts = { buffer = bufnr, noremap=true, silent=true }
  -- See `:help vim.*` for documentation on any of the below functions
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<leader>e', vim.diagnostic.setloclist, opts)
end

--[[
  Required installs:
  - https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
  - npm install -g \
      vscode-langservers-extracted \
      typescript typescript-language-server \
      bash-language-server
  - apt install shellcheck
  - https://rust-analyzer.github.io/manual.html#installation

--]]
local servers = {
  'jsonls',
  'html',
  'cssls',
  'eslint',
  'ts_ls',
  'bashls',
  'rust_analyzer',
  'elixirls',
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local lspconfig = require('lspconfig')
for _, lsp in pairs(servers) do
  lspconfig[lsp].setup {
    capabilities = capabilities,
    on_attach = on_attach,
    flags = { debounce_text_changes = 200 }
  }
end

lspconfig.elixirls.setup {
  cmd = { "elixir-ls" }
}

-- Setup nvim-treesitter
-- https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#modules
require('nvim-treesitter.configs').setup {
  ensure_installed = { "elixir", "heex", "eex" },
  sync_install = false,
  auto_install = false,
  highlight = {
    enable = true,
    disable = {},
    additional_vim_regex_highlighting = false,
  },
}

-- Setup formatter.nvim
-- https://github.com/mhartington/formatter.nvim/blob/master/CONFIG.md#sample-configuration

vim.api.nvim_set_keymap('n', '<leader>f', ':Format<CR>', { noremap=true, silent=true })

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
    json = { format_prettier },
    html = { format_prettier },
    css = { format_prettier },
    scss = { format_prettier },
    javascript = { format_prettier },
    javascriptreact = { format_prettier },
    typescript = { format_prettier },
    typescriptreact = { format_prettier },
  }
}

