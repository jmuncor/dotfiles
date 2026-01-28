return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    cmd = { "Neotree" },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Toggle file explorer" },
      { "<leader>E", "<cmd>Neotree reveal<CR>", desc = "Reveal current file" },
    },
    opts = {
      close_if_last_window = true,
      default_component_configs = {
        indent = {
          with_expanders = true,
        },
      },
      -- Match background with editor
      event_handlers = {
        {
          event = "neo_tree_buffer_enter",
          handler = function()
            vim.opt_local.signcolumn = "no"
          end,
        },
      },
      filesystem = {
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = true, -- Show filtered items as dimmed (like VS Code)
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {
            ".git",
            ".DS_Store",
            "Thumbs.db",
          },
          never_show = {
            ".DS_Store",
            "Thumbs.db",
          },
          never_show_by_pattern = {
            "*.pyc",
            "*/__pycache__",
          },
        },
      },
      window = {
        width = 30,
        mappings = {
          ["<space>"] = "none", -- Don't conflict with leader
          ["l"] = "open", -- Open file or expand folder
          ["h"] = "close_node", -- Collapse folder
        },
      },
    },
  },
}
