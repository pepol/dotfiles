-- Bootstrap lazy.nvim.
--
-- 0.12 ships vim.pack, but lazy.nvim stays: it is the thing that runs build
-- steps (:TSUpdate) and lazy-loads by filetype and command, and vim.pack is
-- still flagged experimental. Switching is a one-file change if that changes.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = { { import = "plugins" } },
  install = { colorscheme = { "modus" } },
  checker = { enabled = true, notify = false },
  change_detection = { notify = false },
  performance = {
    rtp = {
      -- Plugins we replace outright.
      disabled_plugins = { "gzip", "tarPlugin", "zipPlugin", "tohtml", "tutor" },
    },
  },
})
