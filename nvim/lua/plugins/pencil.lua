return {
  {
    "preservim/vim-pencil",
    ft = { "markdown", "text", "tex" },

    init = function()
      -- Settings
      vim.g["pencil#wrapModeDefault"] = "soft"
      vim.g["pencil#textwidth"] = 80
      vim.g["pencil#conceallevel"] = 1
    end,

    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "text", "tex" },
        callback = function()
          -- 1. Enable Pencil & Formatting
          vim.cmd("PencilSoft")
          vim.opt_local.textwidth = 80
          vim.opt_local.foldcolumn = "2" -- Adds a small left margin

          -- 2. Navigation Fixes (So j/k works on wrapped lines)
          local opts = { buffer = true, silent = true }
          vim.keymap.set({ "n", "x" }, "j", "gj", opts)
          vim.keymap.set({ "n", "x" }, "k", "gk", opts)

          -- 3. REMOVE THE POPUP BOX (Autocomplete)
          -- This specifically tells the completion engine to ignore this buffer
          local cmp_ok, cmp = pcall(require, "cmp")
          if cmp_ok then
            cmp.setup.buffer({ enabled = false })
          end

          -- 4. REMOVE RED SQUIGGLY LINES (Diagnostics & Spell)
          -- Disable linter warnings
          vim.diagnostic.enable(false, { bufnr = 0 })
          -- Disable native spell check (if you want zero red lines)
          vim.opt_local.spell = false
        end,
      })
    end,
  },
}
