-- Prompts, agent output and notes are all markdown, so it gets rendered
-- rather than shown raw.
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "markdown", "codecompanion", "AgenticChat", "herdr-context" },
    opts = {
      -- Show the raw text on the line the cursor is on, so a prompt stays
      -- editable while the rest of the buffer stays readable.
      anti_conceal = { enabled = true },
    },
  },
}
