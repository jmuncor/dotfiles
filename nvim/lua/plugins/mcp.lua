-- ~/dotfiles/nvim/lua/plugins/mcp.lua
return {
  -- 1. Install MCPHub
  {
    "ravitemer/mcphub.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    build = "npm install -g mcp-hub@latest",
    config = function()
      require("mcphub").setup({
        -- Pointing to a file inside your dotfiles folder
        config = vim.fn.expand("~/.dotfiles/mcp-servers.json"),
      })
    end,
  },

  -- 2. Connect MCPHub to Avante
  {
    "yetone/avante.nvim",
    opts = function(_, opts)
      opts.custom_tools = opts.custom_tools or {}
      table.insert(opts.custom_tools, function()
        return require("mcphub.extensions.avante").mcp_tool()
      end)
    end,
  },
}
