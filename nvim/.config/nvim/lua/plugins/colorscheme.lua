return {
  {
    "navarasu/onedark.nvim",
    name = "onedark",
    priority = 1000,
    opts = {
      style = "dark",
      transparent = false,
      -- onedark.nvim auto-styles treesitter, telescope, lualine, native LSP,
      -- snacks, which-key, etc. out of the box, so no integrations or custom
      -- highlights are needed.
    },
    config = function(_, opts)
      require("onedark").setup(opts)
      require("onedark").load()
    end,
  },
}
