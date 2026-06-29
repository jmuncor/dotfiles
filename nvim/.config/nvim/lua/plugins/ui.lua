return {
  -- Statusline.
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "onedark",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "filename" },
        lualine_c = { "diagnostics" },
        lualine_x = {},
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- Keybinding hints.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- File icons.
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
}
