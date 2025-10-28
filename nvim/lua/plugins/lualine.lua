return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local custom_theme = require('lualine.themes.iceberg_dark')
    for _, mode in pairs(custom_theme) do
      for _, section in pairs(mode) do
        section.bg = "none"
      end
    end
    custom_theme.normal.a.bg = '#555555'
    custom_theme.insert.a.bg = '#55ff55'
    custom_theme.visual.a.bg = '#ffff55'
    custom_theme.replace.a.bg = '#55ffff'

    require('lualine').setup {
        options = {
            theme = custom_theme,
        }
    }
  end
}
