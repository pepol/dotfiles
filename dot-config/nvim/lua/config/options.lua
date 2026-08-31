-- Editor options. Split out of init.lua so plugin specs and LSP setup are not
-- interleaved with them.

local o = vim.o

-- Indentation: two spaces, no tabs.
o.expandtab = true
o.shiftwidth = 2
o.softtabstop = 2
o.tabstop = 2

o.number = true
o.colorcolumn = "80"

-- Searching: case-insensitive until you type a capital.
o.ignorecase = true
o.smartcase = true
-- Live preview of :s in a split.
o.inccommand = "split"

-- Treesitter folds, all open on entry. foldexpr is the 0.12 spelling; the
-- older 'foldmethod=expr' plus a Vimscript expression is gone.
o.foldmethod = "expr"
o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
o.foldlevel = 99

-- 0.12 defaults 'diffopt' to include indent-heuristic and inline:char, which
-- is what makes the built-in diff readable enough to be the git difftool.
-- linematch aligns changed blocks line by line inside a hunk.
o.diffopt = o.diffopt .. ",linematch:60"

-- Insert-mode autocompletion, new in 0.12 and enough to replace a completion
-- plugin outright. Sources come from 'complete', in priority order: the LSP
-- (via omnifunc, which vim.lsp.completion sets), then the current buffer,
-- other windows and other listed buffers. The caret limits keep any one
-- source from crowding out the rest.
o.autocomplete = true
o.complete = "o,.^5,w^5,b^5"
o.completeopt = "menuone,noselect,popup,fuzzy"
-- Do not open the menu faster than a fast typist reaches the next keystroke.
o.autocompletedelay = 60

-- Terminal buffers (agents run in herdr panes, but :terminal still happens).
o.scrollback = 100000

o.undofile = true
o.splitbelow = true
o.splitright = true
o.signcolumn = "yes"
o.termguicolors = true

-- Leave more room for LSP progress and macro messages than the default.
o.cmdheight = 1
o.updatetime = 250
