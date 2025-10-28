return {
  "datsfilipe/min-theme.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require('min-theme').setup({
      theme = 'dark',
      transparent = true,
      italics = {
        comments = true,
        keywords = true,
        functions = true,
        strings = true,
        variables = true,
      },
      overrides = {},
    })
  end
}
