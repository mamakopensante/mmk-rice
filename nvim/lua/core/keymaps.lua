-- Nvim-Tree

vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', {})

-- ToggleTerm
vim.keymap.set('n', '<leader>t', ':ToggleTerm<CR>', { desc = "Toggle Terminal" })
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { noremap = true, silent = true, desc = "Exit terminal mode" })

-- Runner Buffer (executar arquivo python)
vim.keymap.set("n", "<leader>r", function()
  local tmpfile = vim.fn.tempname() .. ".py"
  vim.api.nvim_command("write! " .. tmpfile)
  vim.cmd("TermExec cmd='python3 " .. tmpfile .. "'")
end, { noremap = true, silent = true, desc = "Run Python file" })
