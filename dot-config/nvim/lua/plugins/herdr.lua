-- The herdr side of the editor.
--
-- Both plugins install in two halves: a herdr plugin providing the actions
-- herdr keybindings invoke, and this Neovim half. `mise run herdr-setup`
-- installs the herdr halves; these specs are the Neovim halves.
--
-- Everything here is gated on HERDR_ENV so a Neovim started outside a herdr
-- pane (over ssh, from a plain terminal) loads none of it.
return {
  -- Navigation and resizing that does not care where the boundary between
  -- editor and multiplexer is: ctrl+h/j/k/l walks Neovim splits first and
  -- crosses into the neighbouring herdr pane once there is no split left.
  {
    "lmilojevicc/herdr-splits.nvim",
    cond = vim.env.HERDR_ENV == "1",
    event = "VeryLazy",
    opts = {
      -- Resize is on ctrl+alt rather than the plugin's default alt, because
      -- AeroSpace owns alt+hjkl (and alt+shift+*, alt+1..9) at the OS level.
      -- These have to match the chords herdr forwards, so they are also
      -- written into the generated herdr-splits.conf from here.
      resize_keys = {
        left = "<C-M-h>", down = "<C-M-j>", up = "<C-M-k>", right = "<C-M-l>",
      },
      ignored_filetypes = {
        "neo-tree", "dadbod-ui", "dbout", "Trouble", "qf", "aerial",
        "DiffviewFiles", "DiffviewFileHistory",
      },
    },
    keys = {
      { "<C-h>", function() require("herdr-splits").move_cursor_left() end, desc = "Focus left" },
      { "<C-j>", function() require("herdr-splits").move_cursor_down() end, desc = "Focus down" },
      { "<C-k>", function() require("herdr-splits").move_cursor_up() end, desc = "Focus up" },
      { "<C-l>", function() require("herdr-splits").move_cursor_right() end, desc = "Focus right" },
      { "<C-M-h>", function() require("herdr-splits").resize_left() end, desc = "Resize left" },
      { "<C-M-j>", function() require("herdr-splits").resize_down() end, desc = "Resize down" },
      { "<C-M-k>", function() require("herdr-splits").resize_up() end, desc = "Resize up" },
      { "<C-M-l>", function() require("herdr-splits").resize_right() end, desc = "Resize right" },
    },
  },

  -- Writing prompts in Neovim instead of at an agent's own input line: stage
  -- a selection, a symbol, a git hunk, the quickfix list or the diagnostics
  -- under the cursor into a live agent's prompt, edit the message as a
  -- buffer, and send it when it reads right.
  {
    "makyinmars/herdr-context.nvim",
    cond = vim.env.HERDR_ENV == "1",
    -- Not lazy: :checkhealth herdr-context and the agent drawer should work
    -- before the first mapping is pressed.
    lazy = false,
    opts = {
      -- Never fire a prompt off on staging alone. The whole point is to read
      -- it once more in a buffer first.
      submit = false,
      -- Stay in the editor after sending; the agent is visible in its own
      -- pane and herdr's sidebar reports when it needs you.
      focus_after_send = false,
    },
    keys = {
      { "<leader>ac", function() require("herdr-context").compose() end, mode = { "n", "v" }, desc = "Agent: compose context" },
      { "<leader>ap", function() require("herdr-context").prompt() end, mode = { "n", "v" }, desc = "Agent: write a prompt" },
      { "<leader>ay", function() require("herdr-context").reference() end, mode = { "n", "v" }, desc = "Agent: stage file:line" },
      { "<leader>aY", function() require("herdr-context").send() end, mode = { "n", "v" }, desc = "Agent: stage selection" },
      { "<leader>ad", function() require("herdr-context").diagnostics() end, mode = { "n", "v" }, desc = "Agent: stage diagnostics" },
      { "<leader>ah", "<cmd>HerdrContextHunk<cr>", desc = "Agent: stage git hunk" },
      { "<leader>aq", "<cmd>HerdrContextQuickfix<cr>", desc = "Agent: stage quickfix" },
      { "<leader>at", function() require("herdr-context").select_target() end, desc = "Agent: choose target" },
      { "<leader>aa", function() require("herdr-context").agents() end, desc = "Agent: toggle drawer" },
      { "<leader>ar", function() require("herdr-context").refresh() end, desc = "Agent: refresh state" },
    },
  },
}
