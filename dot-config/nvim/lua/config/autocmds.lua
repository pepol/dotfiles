-- Autocommands, in one place so they are greppable.
local augroup = vim.api.nvim_create_augroup("dotfiles", { clear = true })

-- Terraform files are HCL; Neovim's own ft detection calls them "terraform"
-- only for some layouts.
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup,
  pattern = "*.tf",
  callback = function() vim.bo.filetype = "hcl" end,
})

-- Flash what was yanked, so a yank from a herdr pane read is visible.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function() vim.hl.on_yank({ timeout = 150 }) end,
})

-- Files opened through herdr-nvim as $EDITOR are one-shot: a commit message,
-- a rebase todo, an agent's scratch file. Closing the window is the signal
-- herdr-nvim waits on, so make that one keystroke instead of :wq.
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  pattern = {
    "COMMIT_EDITMSG", "MERGE_MSG", "TAG_EDITMSG", "git-rebase-todo",
    "*.git/PULLREQ_EDITMSG",
  },
  callback = function(args)
    vim.bo[args.buf].bufhidden = "wipe"
    vim.keymap.set("n", "<leader>w", "<cmd>wq<CR>", {
      buffer = args.buf, desc = "Save and hand back to the caller",
    })
    vim.keymap.set("n", "<leader>q", "<cmd>q!<CR>", {
      buffer = args.buf, desc = "Abort and hand back to the caller",
    })
    -- Start on the first line: git puts the subject there.
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
  end,
})

-- Do not leave a terminal buffer sitting in normal mode when you enter it.
vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup,
  callback = function()
    vim.wo.number = false
    vim.wo.signcolumn = "no"
  end,
})
