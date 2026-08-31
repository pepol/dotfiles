# Working in this environment

You are running in a pane of a **herdr** session. herdr is the terminal
multiplexer and agent orchestrator; **Neovim** is the editor for everything
textual. Confirm the environment before using any of this:

```bash
test "${HERDR_ENV:-}" = 1
```

Your own coordinates are in `$HERDR_WORKSPACE_ID`, `$HERDR_TAB_ID` and
`$HERDR_PANE_ID`.

## Opening files for the user

Do not print a file and ask the user to open it themselves, and do not start
your own `nvim`. Run:

```bash
nv path/to/file          # or: herdr-nvim path/to/file
```

This hands the file to the Neovim that already owns this workspace, brings
that pane into focus, and blocks until the user closes the tab. It is the
same mechanism `$EDITOR` uses, so `git commit` behaves the same way: the
message opens in the editor the user is looking at, and the command you ran
resumes when they close it.

Because it blocks, only use it when you actually want the user to look at
something now. To read a file yourself, read it directly.

## Layout conventions

A workspace is one project checkout. The usual layout is Neovim on the left
and an agent on the right; `herdr-project <branch>` creates that from a git
worktree.

When you need to run something alongside your own pane, split rather than
taking over the user's editor:

```bash
herdr pane split --current --direction right --cwd "$PWD" --no-focus
```

Read the new pane id from `.result.pane.pane_id`, then `herdr pane run` in it.
Prefer `--no-focus` so the user keeps their place.

## Git

- `git commit` opens Neovim for the user; write the message with `-m` unless
  the user asked to edit it.
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
