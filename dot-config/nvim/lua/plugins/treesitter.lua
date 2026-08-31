-- Treesitter. Pinned to the master branch: the main branch has a different,
-- still-moving API (require("nvim-treesitter").install()) and drops the
-- ensure_installed/build model this relies on.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline",
          "bash", "cmake", "commonlisp", "css", "cue", "diff", "dockerfile",
          "editorconfig", "elixir", "erlang", "git_config", "git_rebase",
          "gitattributes", "gitcommit", "gitignore", "go", "gomod", "gosum",
          "gotmpl", "gowork", "groovy", "helm", "hcl", "html", "http", "ini",
          "java", "javadoc", "javascript", "jq", "json", "jsonnet", "llvm",
          "make", "nginx", "objdump", "passwd", "pem", "perl", "promql",
          "proto", "python", "regex", "rust", "sql", "ssh_config", "strace",
          "terraform", "tmux", "toml", "typescript", "yaml",
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
      })
    end,
  },
}
