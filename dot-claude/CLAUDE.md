# Working in this environment

You are running in a pane of a **herdr** session. herdr is the terminal
multiplexer and agent orchestrator; **Neovim** is the editor. Confirm the
environment before using any of this:

```bash
test "${HERDR_ENV:-}" = 1
```

Your own coordinates are in `$HERDR_WORKSPACE_ID`, `$HERDR_TAB_ID` and
`$HERDR_PANE_ID`.

## Editing and reading files

Read and edit files directly. Do not start an editor to do it: `$EDITOR` is
`nvim`, and running it in your pane takes over that pane with a full-screen UI
you then have to drive blind.

The user has their own Neovim, in its own pane. When they should look at
something, name the file and line and let them open it — do not try to open it
for them.

## Layout conventions

A workspace is one project checkout. The usual layout is Neovim in one pane
and an agent in another; `prefix+shift+g` makes a new worktree-backed
workspace for a branch.

When you need to run something alongside your own pane, split rather than
taking over the user's editor:

```bash
herdr pane split --current --direction right --cwd "$PWD" --no-focus
```

Read the new pane id from `.result.pane.pane_id`, then `herdr pane run` in it.
Prefer `--no-focus` so the user keeps their place.

## Git

- Always `git commit -m`. A bare `git commit` opens `nvim` in your pane and
  blocks until something closes it, which you cannot do.
- Same for `git rebase -i`, `git add -p` and anything else interactive:
  use the non-interactive form.
- Reviewing a change is the user's editor's job, not a wall of terminal
  output: point them at `<leader>gr` (diffview over the branch) rather than
  pasting a long diff.
- Worktrees under `.worktrees/` are herdr workspaces. Do not delete them
  directly; `herdr worktree remove` does it.

## Running herdr commands

Run `herdr --help`, then the command group (`herdr pane`, `herdr agent`) for
current syntax; the installed binary is the authority. Most commands return
JSON — read ids out of the response rather than guessing them.

Do not close workspaces, tabs or panes you did not create, and never run
`herdr server stop`.
