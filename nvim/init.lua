-- Load options first (leader key must be set before lazy)
require("config.options")

-- Load keymaps
require("config.keymaps")

-- Load autocommands
require("config.autocmds")

-- Bootstrap and setup lazy.nvim
require("config.lazy")
