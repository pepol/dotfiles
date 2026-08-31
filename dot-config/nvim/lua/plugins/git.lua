-- Git: hunks in the gutter, and Neovim as the diff and review surface.
return {
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        -- Navigation. In diff mode the built-in ]c/[c already do the right
        -- thing, so only take them over outside it.
        map("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gitsigns.nav_hunk("next")
          end
        end, "Next hunk")

        map("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gitsigns.nav_hunk("prev")
          end
        end, "Previous hunk")

        -- Actions
        map("n", "<leader>hs", gitsigns.stage_hunk, "Stage hunk")
        map("n", "<leader>hr", gitsigns.reset_hunk, "Reset hunk")
        map("v", "<leader>hs", function()
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage selection")
        map("v", "<leader>hr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Reset selection")
        map("n", "<leader>hS", gitsigns.stage_buffer, "Stage buffer")
        map("n", "<leader>hR", gitsigns.reset_buffer, "Reset buffer")
        map("n", "<leader>hp", gitsigns.preview_hunk, "Preview hunk")
        map("n", "<leader>hi", gitsigns.preview_hunk_inline, "Preview hunk inline")
        map("n", "<leader>hb", function()
          gitsigns.blame_line({ full = true })
        end, "Blame line")
        map("n", "<leader>hd", gitsigns.diffthis, "Diff against index")
        map("n", "<leader>hD", function()
          gitsigns.diffthis("~")
        end, "Diff against last commit")
        map("n", "<leader>hQ", function() gitsigns.setqflist("all") end, "All hunks to quickfix")
        map("n", "<leader>hq", gitsigns.setqflist, "Buffer hunks to quickfix")

        -- Toggles
        map("n", "<leader>tb", gitsigns.toggle_current_line_blame, "Toggle line blame")
        map("n", "<leader>tw", gitsigns.toggle_word_diff, "Toggle word diff")

        -- Text object
        map({ "o", "x" }, "ih", gitsigns.select_hunk, "Select hunk")
      end,
    },
  },

  -- The diff viewer. This is what makes Neovim the place you read a change
  -- rather than scrolling `git diff` in a pane: a file list, per-file diffs
  -- over any revision range, and file history. Also the merge-conflict
  -- resolver `git mergetool` opens into.
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
    opts = {
      enhanced_diff_hl = true,
      view = {
        -- Three-way for merges: LOCAL, BASE and REMOTE all visible.
        merge_tool = { layout = "diff3_mixed", disable_diagnostics = true },
      },
    },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Git: diff working tree" },
      { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Git: close diff" },
      -- Reviewing what an agent just did is the common case: everything on
      -- this branch that is not on the default branch.
      { "<leader>gr", "<cmd>DiffviewOpen origin/HEAD...HEAD<cr>", desc = "Git: review branch" },
      { "<leader>gs", "<cmd>DiffviewOpen --staged<cr>", desc = "Git: diff staged" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Git: file history" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Git: branch history" },
    },
  },

  -- Pull requests, issues and review threads, in buffers. Replaces gh.nvim
  -- and litee.nvim, which are unmaintained and do not run on 0.12.
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = { picker = "telescope" },
    keys = {
      { "<leader>gp", "<cmd>Octo pr list<cr>", desc = "GitHub: pull requests" },
      { "<leader>gi", "<cmd>Octo issue list<cr>", desc = "GitHub: issues" },
      { "<leader>gv", "<cmd>Octo review start<cr>", desc = "GitHub: start review" },
      { "<leader>gV", "<cmd>Octo review submit<cr>", desc = "GitHub: submit review" },
    },
  },
}
