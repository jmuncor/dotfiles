return {
  {
    "navarasu/onedark.nvim",
    name = "onedark",
    priority = 1000,
    opts = {
      style = "dark",
      transparent = false,
      -- onedark already styles treesitter, telescope, lualine, LSP, snacks,
      -- and which-key well enough for this setup.
    },
    config = function(_, opts)
      require("onedark").setup(opts)
      require("onedark").load()
    end,
  },
}
