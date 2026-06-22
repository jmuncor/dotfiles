return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "python",
        "typescript",
        "javascript",
        "tsx",
        "lua",
        "markdown",
        "markdown_inline",
        "json",
        "yaml",
        "bash",
        "html",
        "css",
      },
      highlight = { enable = true },
      indent = { enable = true },
      auto_install = true,
    },
    config = function(_, opts)
      require("nvim-treesitter").setup(opts)
    end,
  },
}
