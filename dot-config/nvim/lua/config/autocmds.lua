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

-- Files opened as $EDITOR are one-shot: a commit message, a rebase todo, an
-- agent's scratch file. The caller is blocked until Neovim exits, so make
-- finishing one keystroke instead of :wq.
--
-- Only when this Neovim was started for that one file, which is what git
-- does. Editing .git/COMMIT_EDITMSG inside a session you were already using
-- gets none of this, because <leader>q would take the whole editor with it.
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  pattern = {
    "COMMIT_EDITMSG", "MERGE_MSG", "TAG_EDITMSG", "git-rebase-todo",
    "*.git/PULLREQ_EDITMSG",
  },
  callback = function(args)
    if vim.fn.argc() ~= 1 then return end

    vim.keymap.set("n", "<leader>w", "<cmd>wq<CR>", {
      buffer = args.buf, desc = "Save and hand back to the caller",
    })
    -- :cq exits non-zero, which is how git is told to abandon the commit
    -- rather than take an empty message.
    vim.keymap.set("n", "<leader>q", "<cmd>cq<CR>", {
      buffer = args.buf, desc = "Abort: exit non-zero so git cancels",
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
