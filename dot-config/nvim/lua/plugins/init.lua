-- Colourscheme and the small always-on UI pieces.
return {
  {
    "miikanissi/modus-themes.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      vim.cmd.colorscheme("modus")
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<leader>?",
        function() require("which-key").show({ global = false }) end,
        desc = "Buffer local keymaps (which-key)",
      },
    },
  },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { url = "https://gitlab.com/HiPhish/rainbow-delimiters.nvim.git", event = "BufReadPost" },
  { "ntpeters/vim-better-whitespace", event = "BufReadPost" },
}
