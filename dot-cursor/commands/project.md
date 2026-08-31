# Project

Start a new project: a git worktree in its own herdr workspace.

## Input

**Branch name** (after `/project`, e.g. `/project feat/retry-budget`).
Normalize it: lowercase; keep `/`, letters, digits and hyphens; replace
anything else with `-`; collapse runs of `-` to one.

## Workflow

herdr does the whole thing — worktree, checkout and workspace — in one
command:

```bash
herdr worktree create --branch <branch> --label <branch> --focus
```

Add `--base <ref>` to fork from something other than the repository default,
and `--path <path>` to place the checkout somewhere specific. Read the new
workspace and pane ids from `.result`.

Interactively the same thing is `prefix+shift+g`, which prompts for the
branch.

Then set the workspace up for work:

1. Split a second pane for the agent:
   `herdr pane split <root-pane> --direction right --cwd <worktree> --no-focus`
2. Start the agent in it:
   `herdr agent start <name> --kind cursor --pane <new-pane>`

Leave focus on the first pane. Report the workspace id, both pane ids and the
worktree path back to the user. Do not ask for confirmation.

## If it fails

- Not in a git repository → say so.
- Branch already exists → pick another name or look at the existing worktree
  with `git worktree list`; do not delete anything.
- Agent failed to start → the workspace is still good. Say which agent kind
  failed and leave the pane at a shell.

## Cleanup

When the work is merged: `herdr worktree remove <path>`, which closes the
workspace too. Never `rm -rf` a worktree.
