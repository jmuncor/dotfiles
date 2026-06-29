-- Leader key.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- I use Telescope instead of netrw.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Line numbers.
vim.opt.number = true
vim.opt.relativenumber = true

-- Two-space indentation.
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true

-- Search.
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Appearance.
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.laststatus = 3 -- one global statusline

-- Behavior.
vim.opt.clipboard = "unnamedplus"

-- Over SSH, send clipboard writes through OSC 52 so yanks reach my local
-- machine. Local sessions keep the default clipboard provider.
if os.getenv("SSH_CONNECTION") then
  local osc52 = require("vim.ui.clipboard.osc52")
  vim.g.clipboard = {
    name = "OSC 52",
    copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
    paste = { ["+"] = osc52.paste("+"), ["*"] = osc52.paste("*") },
  }
end
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Wrapping.
vim.opt.wrap = false
vim.opt.breakindent = true
