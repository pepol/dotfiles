-- Setup leader keys
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any ley to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup plugins
require("lazy").setup({
  spec = {
    {
      "miikanissi/modus-themes.nvim",
      priority = 1000,
      lazy = false,
      config = function()
        vim.cmd([[colorscheme modus]])
      end,
    },
    { "nvim-telescope/telescope.nvim", tag = "0.1.8", dependencies = { "nvim-lua/plenary.nvim" } },
    { "nvim-treesitter/nvim-treesitter", branch = "master", lazy = false, build = ":TSUpdate" },
    { "neovim/nvim-lspconfig" },
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      },
      keys = {
        {
          "<leader>?",
          function()
            require("which-key").show({ global = false })
          end,
          desc = "Buffer Local Keymaps (which-key)",
        },
      },
    },
    { "nvim-tree/nvim-web-devicons", lazy = true },
    { url = "https://gitlab.com/HiPhish/rainbow-delimiters.nvim.git" },
    {
      "lewis6991/gitsigns.nvim",
      opts = {
        on_attach = function(bufnr)
          local gitsigns = require("gitsigns")

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then
              vim.cmd.normal({"]c", bang = true})
            else
              gitsigns.nav_hunk("next")
            end
          end)

          map("n", "[c", function()
            if vim.wo.diff then
              vim.cmd.normal({"[c", bang = true})
            else
              gitsigns.nav_hunk("prev")
            end
          end)

          -- Actions
          map("n", "<leader>hs", gitsigns.stage_hunk)
          map("n", "<leader>hr", gitsigns.reset_hunk)

          map("v", "<leader>hs", function()
            gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end)

          map("v", "<leader>hr", function()
            gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end)

          map("n", "<leader>hS", gitsigns.stage_buffer)
          map("n", "<leader>hR", gitsigns.reset_buffer)
          map("n", "<leader>hp", gitsigns.preview_hunk)
          map("n", "<leader>hi", gitsigns.preview_hunk_inline)

          map("n", "<leader>hb", function()
            gitsigns.blame_line({ full = true })
          end)

          map("n", "<leader>hd", gitsigns.diffthis)

          map("n", "<leader>hD", function()
            gitsigns.diffthus("~")
          end)

          map("n", "<leader>hQ", function() gitsigns.setqflist("all") end)
          map("n", "<leader>hq", gitsigns.setqflist)

          -- Toggles
          map("n", "<leader>tb", gitsigns.toggle_current_line_blame)
          map("n", "<leader>tw", gitsigns.toggle_word_diff)

          -- Text objects
          map({"o", "x"}, "ih", gitsigns.select_hunk)
        end
      },
    },
    { "ntpeters/vim-better-whitespace" },
  },
  install = { colorscheme = { "modus" } },
  checker = { enabled = true },
})

-- LSP
vim.lsp.enable("gopls")

-- Keybindings
-- Normal mode
vim.keymap.set("n", "<leader>n", ":set invnumber<CR>")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

-- Insert mode
vim.keymap.set("i", "jj", "<ESC>", { silent = true })

-- Visual mode

-- Setup
vim.opt.nu = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.tabstop = 2
vim.o.colorcolumn = "80"
