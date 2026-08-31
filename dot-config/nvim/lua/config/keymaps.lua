-- Global mappings. Plugin-specific ones live with their plugin spec, and LSP
-- ones are attached per-buffer in config/lsp.lua.
local map = vim.keymap.set

-- Normal mode
map("n", "<leader>n", "<cmd>set invnumber<CR>", { desc = "Toggle line numbers" })
map("n", "<leader>bp", "<cmd>bp<CR>", { desc = "Previous buffer" })
map("n", "<leader>bn", "<cmd>bn<CR>", { desc = "Next buffer" })
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Insert mode
map("i", "jj", "<Esc>", { silent = true, desc = "Leave insert mode" })

-- Terminal mode: one key back to normal, so :terminal buffers are navigable.
map("t", "<C-\\><C-n>", "<C-\\><C-n>", { desc = "Leave terminal mode" })

-- Autocompletion menu navigation. 'autocomplete' opens the menu on its own;
-- these make Tab walk it without stealing Tab when it is closed.
map("i", "<Tab>", function()
  return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>"
end, { expr = true, desc = "Next completion" })
map("i", "<S-Tab>", function()
  return vim.fn.pumvisible() == 1 and "<C-p>" or "<S-Tab>"
end, { expr = true, desc = "Previous completion" })

-- Diff mode. `do`/`dp` are built in; these cover the rest of a merge.
map("n", "<leader>dq", "<cmd>diffoff!<CR>", { desc = "Diff: stop" })
map("n", "<leader>du", "<cmd>diffupdate<CR>", { desc = "Diff: refresh" })
-- Three-way merge: take the change from one side wholesale.
map("n", "<leader>d1", "<cmd>diffget LOCAL<CR>", { desc = "Diff: take LOCAL" })
map("n", "<leader>d2", "<cmd>diffget BASE<CR>", { desc = "Diff: take BASE" })
map("n", "<leader>d3", "<cmd>diffget REMOTE<CR>", { desc = "Diff: take REMOTE" })
