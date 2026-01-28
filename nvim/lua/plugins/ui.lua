return {
  -- Noice: floating cmdline, messages, and popupmenu
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
      routes = {
        -- Hide written messages
        { filter = { event = "msg_show", kind = "", find = "written" }, opts = { skip = true } },
        -- Hide search count messages
        { filter = { event = "msg_show", kind = "search_count" }, opts = { skip = true } },
        -- Hide "No information available" from LSP
        { filter = { event = "notify", find = "No information available" }, opts = { skip = true } },
      },
    },
  },

  -- Notify: notification position
  {
    "rcarriga/nvim-notify",
    opts = {
      stages = "fade",
      timeout = 2000,
      top_down = false,  -- Bottom-up
      render = "minimal",
    },
  },

  -- Lualine: statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "catppuccin",
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

  -- Which-key: keybinding hints
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Devicons: file icons
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
}
