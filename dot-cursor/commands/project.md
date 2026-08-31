# Project

Start a new project: a git worktree, a herdr workspace, and the standard
editor-plus-agent layout.

## Input

**Branch name** (after `/project`, e.g. `/project feat/retry-budget`).
Normalize it: lowercase; keep `/`, letters, digits and hyphens; replace
anything else with `-`; collapse runs of `-` to one.

## Workflow

This is one command. `herdr-project` does the worktree, the workspace, the
split and the agent:

```bash
herdr-project <branch> --kind cursor
```

That creates:

- a git worktree for `<branch>`, under `.worktrees/<repo>/<branch>` beside the
  repository — deliberately not under a global worktree root, so the
  `includeIf gitdir:` rules in `~/.gitconfig` still pick the right identity;
- a herdr workspace labelled `<branch>`, focused;
- a left pane running Neovim through `herdr-nvim`, which claims the
  workspace's editor socket, so `$EDITOR` from any pane in this workspace
  lands there;
- a right pane running the agent.

Add `--base <ref>` to fork from something other than the repository default.
Omit `--kind` for a plain shell on the right.

Report the workspace id, the two pane ids and the worktree path back to the
user. Do not ask for confirmation.

## If it fails

- Not in a git repository → say so; `herdr-project` needs one.
- Branch already exists → pick another name or check the existing worktree
  with `git worktree list`; do not delete anything.
- Agent failed to start → the workspace is still good. Say which agent kind
  failed and leave the pane at a shell.

## Cleanup

When the work is merged: `herdr worktree remove <path>` (which also closes the
workspace). Never `rm -rf` a worktree.
