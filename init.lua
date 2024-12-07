-- Inicializar o Lazy

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- Última versão estável
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup()

-- Options

vim.opt.termguicolors = false
vim.opt.clipboard = 'unnamedplus'
vim.opt.mouse='a'
vim.opt.guicursor = "n-v-c:block-blinkon1,i:hor20-blinkon1"
vim.opt.cmdheight = 0
vim.opt.tabstop = 3                        -- Número de espaços para tabs
vim.opt.shiftwidth = 4                     -- Espaços por indentação
vim.opt.expandtab = true                   -- Converter tabs para espaços
vim.opt.smartindent = true                 -- Identação automática
vim.opt.wrap = false                       -- Não quebrar linhas

-- Reset cursor

vim.cmd [[
augroup ResetCursor
  autocmd!
  autocmd VimLeave * set guicursor=a:hor20-blinkon1
augroup END
 ]]
