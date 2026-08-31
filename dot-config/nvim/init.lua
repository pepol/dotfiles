-- Neovim 0.12 -- editor, diff viewer and prompt composer for a herdr session.
--
-- Load order matters: the leader keys have to be set before lazy.nvim reads
-- any plugin spec, because specs declare mappings against them.
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

require("config.options")
require("config.lazy")
require("config.lsp")
require("config.keymaps")
require("config.autocmds")
