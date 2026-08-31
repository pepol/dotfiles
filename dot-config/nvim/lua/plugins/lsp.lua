-- Server definitions.
--
-- With vim.lsp.enable() doing the starting and stopping, nvim-lspconfig is no
-- longer a framework -- it is the collection of lsp/<name>.lua files that say
-- how to launch each server and what to treat as a project root. It has to be
-- on the runtimepath before config/lsp.lua calls vim.lsp.enable(), so it is
-- not lazy-loaded.
return {
  { "neovim/nvim-lspconfig", lazy = false },
}
