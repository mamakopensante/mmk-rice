-- Define o leader antes de carregar qualquer outra coisa
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Carrega as configurações principais
require("core.options")
require("core.keymaps")
require("core.autocmds")

-- Carrega o gerenciador de plugins (lazy.nvim)
require("plugins")
