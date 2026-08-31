# dotfiles

Neovim as the editor for everything textual, herdr as the multiplexer and
agent orchestrator, mise as the thing that installs both.

macOS is the target; the bootstrap degrades on Linux rather than failing.

## Install

```bash
git clone git@github.com:pepol/dotfiles.git ~/dotfiles
cd ~/dotfiles
mise run bootstrap
```

That installs Homebrew and the Brewfile, links the configs into `$HOME`, installs the tools named in `dot-config/mise/config.toml`, syncs the
Neovim plugins and treesitter parsers, installs herdr's agent integrations,
loads the launch agent that numbers the sidebar, and finishes by running
`mise run doctor`.

Open a new shell afterwards, then start herdr with `herdr`.

Individual steps, all re-runnable:

| task | what it does |
| --- | --- |
| `mise run link` | re-link configs after a pull |
| `mise run tools` | install/update the tools in the global mise config |
| `mise run nvim-sync` | plugins and treesitter parsers, headless |
| `mise run herdr-setup` | herdr's per-agent integrations |
| `mise run doctor` | check the pieces can see each other |
| `mise run check` | lint scripts, load the Neovim config in a scratch $HOME |
| `mise run link -- --dry-run` | show what linking would change |
| `mise run update` | upgrade tools and plugins |
| `mise run unlink` | remove the symlinks |

## How the two halves fit together

A **herdr workspace is one project checkout**, and it holds exactly one
Neovim. That Neovim listens on a socket named after the workspace, under
`$XDG_RUNTIME_DIR/herdr-nvim` (or `$TMPDIR/herdr-nvim-$UID` on macOS).

`$EDITOR` is not `nvim`, it is **`herdr-nvim`**. Whatever asks for an editor —
`git commit` in a shell pane, `git rebase -i`, an agent opening a file,
herdr's own `prefix+e` scrollback edit — goes through it:

1. Already inside a Neovim `:terminal`? Use that instance.
2. Is there a live editor for this workspace? Focus its pane, open the file
   there as a tab, block until you close it, then return focus to the pane
   that asked.
3. Otherwise, become the workspace editor: start Neovim listening on the
   socket, so the next call takes branch 2.

Outside herdr it is plain `nvim`. So is any invocation carrying Neovim options
(`nv -d a b`, `nv +42 file`), which describe how one editor process should
start and cannot be honoured by a remote tab.

Neovim implements none of Vim's `--remote-wait` variants — it answers `E5600`
— so `herdr-nvim` does the waiting itself: it opens the file with
`--remote-tab`, then polls until the file is no longer displayed in any
window. "No longer on screen" rather than "buffer gone", because `:wq` leaves
the buffer listed but hidden, and git only needs you to be finished with it.

`nv` is a short alias for the same thing, and is what the agent rules in
`dot-claude/` and `dot-cursor/` tell agents to use instead of starting their
own editor.

## Keys

Prefix is `ctrl+x`. The full convention is documented at the top of
`dot-config/herdr/config.toml`.

**Across the editor/pane boundary** — no prefix, and they do not care whether
the focused pane holds Neovim or a shell:

| key | |
| --- | --- |
| `ctrl+h/j/k/l` | focus left/down/up/right, through Neovim splits and herdr panes alike |
| `ctrl+alt+h/j/k/l` | resize, same |

**In Neovim**, leader is `,`:

| key | |
| --- | --- |
| `<leader>gd` / `<leader>gr` | diff the working tree / review the whole branch |
| `<leader>gh` / `<leader>gH` | file history / branch history |
| `<leader>gp` / `<leader>gv` | GitHub pull requests / start a review |
| `<leader>ap` | write a prompt for an agent, in a buffer |
| `<leader>ac` | compose a context bundle and stage it |
| `<leader>aY` / `<leader>ay` | stage the selection / a `file#L10-L20` reference |
| `<leader>ad` / `<leader>ah` | stage diagnostics / the git hunk under the cursor |
| `<leader>at` / `<leader>aa` | choose the target agent / toggle the agent drawer |
| `<leader>ff` `<leader>fg` `<leader>fb` | files, grep, buffers |

In a commit message, rebase todo or other buffer opened as `$EDITOR`,
`<leader>w` saves and hands control back and `<leader>q` aborts.

## Starting a project

```bash
herdr-project <branch> [--kind claude] [--base main]
```

Creates a git worktree for the branch, a herdr workspace labelled after it,
Neovim on the left (claiming the workspace editor socket) and an agent on the
right. `hp` is the alias.

Worktrees land in `.worktrees/<repo>/<branch>` **beside the repository**, not
under a single global worktree root. That is deliberate: the `includeIf
gitdir:` rules in `.gitconfig` pick the git identity by path, so a worktree of
a repo in `~/src/corp` has to stay under `~/src/corp` to keep the corp name
and email.

Clean up with `herdr worktree remove <path>`, which closes the workspace too.

## What is where

```
mise.toml                    bootstrap and maintenance tasks
Brewfile                     macOS packages mise cannot install
scripts/                     what the mise tasks actually run
templates/                   the launch agent plist, before $HOME is filled in
dot-config/mise/config.toml  the real tool list -- neovim, herdr, runtimes
dot-config/nvim/             Neovim 0.12 config
dot-config/herdr/config.toml herdr keys, sidebar, popups
dot-local/bin/               herdr-nvim, nv, herdr-project, herdr-sidebar-numbers
dot-local/lib/herdr/         herdr socket client + editor registry, shared by those
dot-claude/, dot-cursor/     agent rules: use nv, split rather than take over
```

## Linking

`mise run link` does the symlinking itself rather than shelling out to GNU
stow. Everything linkable lives under a top-level `dot-*` entry, and a leading
`dot-` on any path component becomes `.`:

```
dot-zshrc                  ->  ~/.zshrc
dot-config/nvim/init.lua   ->  ~/.config/nvim/init.lua
```

Files are linked individually and directories are always created for real,
never symlinked. That matters because `~/.config` and `~/.local/bin` are
shared: mise puts shims there, Neovim writes its lockfile, herdr writes its
socket and logs. A directory symlink would put all of it inside the checkout.

Anything outside a `dot-*` entry — `mise.toml`, `Brewfile`, `scripts/`,
`templates/`, the README — is repo infrastructure and is never linked, so
there is no ignore file to keep in sync.

An existing real file where a link should go is reported and left alone;
move it aside and re-run. `mise run unlink` removes only the links that point
back into this checkout.

## Neovim 0.12 notes

The config targets 0.12 and will not work on 0.11:

- **LSP** is `vim.lsp.enable()` plus `vim.lsp.config()`. `nvim-lspconfig` is
  still installed, but as the collection of `lsp/<name>.lua` server
  definitions rather than as a framework. Local overrides go in
  `dot-config/nvim/lsp/<name>.lua`, which win because the config directory
  comes first on the runtimepath — see `lsp/lua_ls.lua`.
- **Completion** is built in: `'autocomplete'` with `'complete'` set to
  `o,.^5,w^5,b^5`, so LSP items come first and buffer words fill in behind
  them. There is no completion plugin.
- 0.12 already maps `grn`, `gra`, `grr`, `gri`, `grt`, `grx` and `K`;
  `config/lsp.lua` only adds what is missing.
- **lazy.nvim stays** rather than moving to `vim.pack`. `vim.pack` is still
  flagged experimental and does not run build steps like `:TSUpdate`.
  Switching later is a change to `lua/config/lazy.lua` alone.
- `nvim-treesitter` is pinned to `branch = "master"`. The `main` branch has a
  different, still-moving API and drops `ensure_installed`.

## The herdr Neovim plugins

Two plugins do the integration, each installing in two halves — a herdr plugin
providing the actions herdr keybindings invoke, and a Neovim plugin:

- [`herdr-splits.nvim`](https://github.com/lmilojevicc/herdr-splits.nvim) —
  navigation and resizing across the boundary. Its default resize chords are
  `alt+hjkl`; they are moved to `ctrl+alt+hjkl` here because AeroSpace owns
  the plain alt layer. The two sides have to agree, so the chords appear both
  in `resize_keys` in `lua/plugins/herdr.lua` and in `herdr/config.toml`.
- [`herdr-context.nvim`](https://github.com/makyinmars/herdr-context.nvim) —
  writing prompts in a buffer and staging code context into a live agent's
  prompt without submitting it.

`mise run herdr-setup` installs the agent integrations; the herdr halves of
these two plugins are installed with `herdr plugin install <repo>`.

Taking `ctrl+h` for navigation also takes ASCII backspace. The Backspace key
sends DEL and is unaffected; only the literal `ctrl+h` chord is gone.

## Migrated away from

tmux and zellij (herdr replaces both), Helix and Emacs and `.vimrc` (Neovim is
the only editor now), `gh.nvim` and `litee.nvim` (unmaintained, replaced by
`octo.nvim`), `vim-slime` (targeted tmux; `herdr-context.nvim` covers sending
text to a pane), and asdf (mise). The old configs are in the
`dotfiles-v2024` repository.
