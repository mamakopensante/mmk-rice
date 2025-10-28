-- Instala o lazy.nvim automaticamente
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- Core
    require("plugins.cmp"),
    require("plugins.treesitter"),
    require("plugins.lualine"),
    require("plugins.nvim-tree"),
    require("plugins.toggleterm"),
    require("plugins.theme"),

    -- LSP
    {
      "williamboman/mason-lspconfig.nvim",
      dependencies = {
        "williamboman/mason.nvim",
        "neovim/nvim-lspconfig",
      },
      config = function()
        -- 1. Configura o Mason
        require("mason").setup()

        -- 2. Configura o Mason-LSPConfig para instalar os servidores
        require("mason-lspconfig").setup({
          ensure_installed = { "pyright", "lua_ls" },
        })

        -- 3. Configura os servidores com lspconfig
        local lspconfig = require("lspconfig")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        lspconfig.pyright.setup({
          capabilities = capabilities,
        })

        lspconfig.lua_ls.setup({
          capabilities = capabilities,
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
            },
          },
        })
      end,
    },
  }, -- Fim da tabela 'spec'

  -- Opções do lazy.nvim (fora do 'spec')
  install = { colorscheme = { "default" } },
  checker = { enabled = false },
})

-- Aplica o tema
vim.cmd.colorscheme("min-theme")
