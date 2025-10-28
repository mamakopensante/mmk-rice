-- Reset cursor on exit

vim.cmd [[
  augroup ResetCursor
    autocmd!
    autocmd VimLeave * set guicursor=a:hor20-blinkon1
  augroup END
]]

-- Focus follows pointer (hover)

local timer = vim.loop.new_timer()

local function is_float(win)
  local cfg = vim.api.nvim_win_get_config(win)
  return cfg and cfg.relative and cfg.relative ~= ""
end

local function focus_under_mouse()
  local pos = vim.fn.getmousepos()
  local win = pos.winid or 0
  if win == 0 or win == vim.api.nvim_get_current_win() or is_float(win) or vim.fn.pumvisible() == 1 then
    return
  end

  local ok = pcall(vim.api.nvim_set_current_win, win)
  if not ok then return end

  local buf = vim.api.nvim_win_get_buf(win)
  if vim.bo[buf].buftype == "terminal" then
    vim.cmd("startinsert")
  elseif vim.fn.mode() == "t" then
    vim.cmd("stopinsert")
  end
end

local function enable_ffp()
  if not timer:is_active() then
    timer:start(0, 100, vim.schedule_wrap(focus_under_mouse))
    vim.g.focus_follows_pointer_enabled = true
  end
end

enable_ffp() -- Habilita por padrão
