-- Local override of nvim-lspconfig's lua_ls definition. Merged over it,
-- because ~/.config/nvim comes first on the runtimepath.
return {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = {
        checkThirdParty = false,
        -- Complete and go-to-definition across the Neovim API and every
        -- installed plugin, which is most of what this config edits.
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- vim is a global here, not an undefined variable.
      diagnostics = { globals = { "vim" } },
      telemetry = { enable = false },
    },
  },
}
