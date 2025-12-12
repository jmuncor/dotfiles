return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    -- Clean up lualine_y to ONLY show percentage (progress)
    opts.sections.lualine_y = { "progress" }

    -- Set lualine_z to ONLY show line:column (location), replacing the clock
    opts.sections.lualine_z = {
      { "location", padding = { left = 0, right = 1 } },
    }
  end,
}
