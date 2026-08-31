-- LSP, using the 0.12 API.
--
-- vim.lsp.enable() replaces the old require("lspconfig").<server>.setup{}: it
-- starts and stops clients as buffers come and go, and reads each server's
-- definition from an lsp/<name>.lua file on the runtimepath. nvim-lspconfig
-- ships those definitions, so it is a data dependency now, not a framework.
-- Anything overridden locally lives in ~/.config/nvim/lsp/<name>.lua, which
-- wins because our config directory comes first on the runtimepath.

-- Defaults every server inherits.
vim.lsp.config("*", {
  capabilities = {
    textDocument = {
      -- Ask servers to send whole-file diagnostics unprompted.
      publishDiagnostics = { relatedInformation = true },
    },
  },
})

vim.lsp.enable({
  "gopls",
  "rust_analyzer",
  "vtsls",
  "cue",
  "lua_ls",
  "yamlls",
})

vim.diagnostic.config({
  virtual_text = { current_line = false, severity = { min = "WARN" } },
  -- The full text of the diagnostic under the cursor, where it cannot be
  -- confused with the code.
  virtual_lines = { current_line = true },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "E",
      [vim.diagnostic.severity.WARN] = "W",
      [vim.diagnostic.severity.INFO] = "I",
      [vim.diagnostic.severity.HINT] = "H",
    },
  },
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("dotfiles-lsp", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end
    local buf = args.buf

    -- Feed LSP items into the built-in completion menu. 'complete' lists "o"
    -- first, so these outrank buffer words. autotrigger=false because
    -- 'autocomplete' is already opening the menu on every keystroke; letting
    -- the LSP trigger it too would query twice per character.
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, buf, { autotrigger = false })
    end

    -- 0.12 already maps grn/gra/grr/gri/grt/grx and K. These are the gaps.
    local function map(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc })
    end
    map("gd", vim.lsp.buf.definition, "Go to definition")
    map("gD", vim.lsp.buf.declaration, "Go to declaration")
    map("<leader>ls", vim.lsp.buf.document_symbol, "Document symbols")
    map("<leader>lf", function() vim.lsp.buf.format({ async = true }) end, "Format")
    map("<leader>ld", vim.diagnostic.setloclist, "Diagnostics to loclist")

    -- Inlay hints are off by default; they are worth having on demand rather
    -- than always, because they shift columns while you type.
    if client:supports_method("textDocument/inlayHint") then
      map("<leader>lh", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }), { bufnr = buf })
      end, "Toggle inlay hints")
    end

    -- Highlight other references to the symbol under the cursor.
    if client:supports_method("textDocument/documentHighlight") then
      local group = vim.api.nvim_create_augroup("dotfiles-lsp-highlight", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = group, buffer = buf, callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        group = group, buffer = buf, callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})
