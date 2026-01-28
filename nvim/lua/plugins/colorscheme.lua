return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = false,
      custom_highlights = function(colors)
        return {
          -- Make neo-tree background match the editor
          NeoTreeNormal = { bg = colors.base },
          NeoTreeNormalNC = { bg = colors.base },
          NeoTreeEndOfBuffer = { fg = colors.base, bg = colors.base },
        }
      end,
      integrations = {
        treesitter = true,
        telescope = { enabled = true },
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true },
        barbecue = { dim_dirname = true, bold_basename = true, dim_context = false },
        blink_cmp = true,
        which_key = true,
        noice = true,
        notify = true,
        neotree = true,
      },
    },
  },
}
