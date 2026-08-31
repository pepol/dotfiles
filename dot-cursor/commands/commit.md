# Commit

Create a git commit with **all current changes** (stage everything unstaged,
then commit).

## Steps

1. **Stage everything** — both staged and unstaged changes go in.
2. **Infer the message style** from the repo's history (e.g.
   `scope: short imperative message`, lowercase, no trailing period).
3. **Summarize** what is being committed in one line matching that style.
4. **Commit** with that message.

Do not ask for confirmation of the message; generate it and commit. If there
is nothing to commit, say so and do nothing.

Use `git commit -m "<message>"`. Do **not** run a bare `git commit`: `$EDITOR`
is `herdr-nvim`, so it would open a buffer in the user's editor and block
until they close it. Only do that if the user explicitly asked to write the
message themselves.

## Preferred: Git MCP server

When the Git MCP server is available, use its tools:

- **Status and diffs:** `git_status`, `git_diff_unstaged`, `git_diff_staged`.
- **History / style:** `git_log` with `max_count` around 15–20.
- **Stage all:** `git_add` with `files: ["."]` or the changed files from status.
- **Commit:** `git_commit` with the generated single-line message.

## Fallback: git CLI

1. `git add -A`
2. `git log -20 --oneline` to infer style
3. `git status`, `git diff --staged`
4. `git commit -m "<generated message>"`
