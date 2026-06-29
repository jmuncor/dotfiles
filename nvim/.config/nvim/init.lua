-- Options first so the leader key exists before plugins load.
require("config.options")

-- My base keymaps.
require("config.keymaps")

-- Small editor automations.
require("config.autocmds")

-- Plugin manager bootstrap and setup.
require("config.lazy")
