return {
  {
    "nvim-telescope/telescope.nvim",
    -- 0.2 is the current series and the one that supports Neovim 0.12; 0.1.x
    -- predates it. The range follows 0.2 patches without jumping to 0.3.
    version = "^0.2",
    cmd = "Telescope",
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",

      -- Native sorter, in C. Telescope's own recommendation, and the
      -- difference is obvious once a picker is fed a large repository.
      -- `build` needs make and a C compiler: on macOS that is the Xcode
      -- command line tools, which installing Homebrew already pulls in.
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

      -- Recommended: file icons in the results, and the previewer's syntax
      -- highlighting. Declared here so lazy loads them before telescope
      -- rather than relying on them happening to be loaded already.
      "nvim-tree/nvim-web-devicons",
      "nvim-treesitter/nvim-treesitter",

      -- Routes vim.ui.select through telescope, which is what the herdr
      -- agent pickers and LSP code actions use.
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          ["ui-select"] = { require("telescope.themes").get_dropdown() },
        },
      })

      -- The fzf extension is a compiled library, so it is the one thing here
      -- that can be missing on a machine where `make` did not run. Say so
      -- rather than failing the whole config: telescope still works, just
      -- with the slower Lua sorter.
      if not pcall(telescope.load_extension, "fzf") then
        vim.notify(
          "telescope-fzf-native is not built; run :Lazy build telescope-fzf-native.nvim",
          vim.log.levels.WARN
        )
      end
      telescope.load_extension("ui-select")
    end,
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
      { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
      { "<leader>fr", "<cmd>Telescope resume<cr>", desc = "Resume last picker" },
    },
  },
}
