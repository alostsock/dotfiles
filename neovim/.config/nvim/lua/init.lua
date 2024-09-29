-- https://github.com/stevearc/oil.nvim?tab=readme-ov-file#quick-start
require('oil').setup({
  view_options = {
    -- Show files and directories that start with "."
    show_hidden = true,
  },
})

-- https://github.com/hrsh7th/nvim-cmp#recommended-configuration
local cmp = require('cmp')
cmp.setup({
  mapping = {
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

-- Setup nvim-lspconfig. https://github.com/neovim/nvim-lspconfig#suggested-configuration

local opts = { noremap=true, silent=true }

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

local on_attach = function(client, bufnr)
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
end

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local servers = {
  'jsonls',
  'html',
  -- requires the npm package "vscode-langservers-extracted"
  'cssls',
  'eslint',
  -- requires npm packages "typescript" and "typescript-language-server"
  'ts_ls',
  'rust_analyzer',
}

local capabilities = require('cmp_nvim_lsp').default_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

for _, lsp in pairs(servers) do
  require('lspconfig')[lsp].setup {
    capabilities = capabilities,
    on_attach = on_attach,
    flags = { debounce_text_changes = 200 }
  }
end

-- Setup formatter.nvim
-- https://github.com/mhartington/formatter.nvim/blob/master/CONFIG.md#sample-configuration

vim.api.nvim_set_keymap('n', '<leader>f', ':Format<CR>', opts)

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

