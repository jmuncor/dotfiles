return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = {
      { "<leader>e", function() Snacks.explorer.open() end, desc = "Toggle file explorer" },
      { "<leader>E", function() Snacks.explorer.reveal() end, desc = "Reveal current file" },
    },
    opts = {
      explorer = {
        replace_netrw = true,
      },
      picker = {
        enabled = true,
        sources = {
          explorer = {
            hidden = true,  -- show dotfiles (.env, .gitignore, etc.)
            ignored = true, -- show gitignored files (node_modules, etc.)
            exclude = {     -- VSCode-like excludes
              ".git",
              ".svn",
              ".hg",
              "CVS",
              ".DS_Store",
              "Thumbs.db",
            },
          },
        },
      },
    },
  },
}
