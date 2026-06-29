return {
  {
    "preservim/vim-pencil",
    ft = { "markdown", "text", "tex" },

    init = function()
      -- Writing defaults.
      vim.g["pencil#wrapModeDefault"] = "soft"
      vim.g["pencil#textwidth"] = 80
      vim.g["pencil#conceallevel"] = 1
    end,

    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "text", "tex" },
        callback = function()
          -- Soft wrapping for prose.
          vim.cmd("PencilSoft")
          vim.opt_local.textwidth = 80
          vim.opt_local.foldcolumn = "2" -- small left margin

          -- Make j/k follow wrapped screen lines.
          local opts = { buffer = true, silent = true }
          vim.keymap.set({ "n", "x" }, "j", "gj", opts)
          vim.keymap.set({ "n", "x" }, "k", "gk", opts)

          -- No completion popup while writing prose.
          vim.b.completion = false

          -- Keep prose buffers quiet.
          vim.diagnostic.enable(false, { bufnr = 0 })
          vim.opt_local.spell = false
        end,
      })
    end,
  },
}
