"""Shared client for herdr's socket API and the Neovim server registry.

Two things live here because every script in ~/.local/bin needs both:

* `request()` speaks herdr's newline-delimited JSON protocol. The `herdr` CLI
  covers most of it, but not `pane.focus` (the CLI's `pane focus` is
  `pane.focus_direction`, which only moves relative to the current pane), and
  spawning the CLI per call is slow in a loop.

* The registry maps a herdr workspace or pane to the Unix socket of the Neovim
  server running in it. That mapping is what makes one Neovim instance per
  project reachable from every other pane, so $EDITOR, the prompt composer and
  pane navigation all land in the same editor.

Import with:

    import sys, os
    sys.path.insert(0, os.path.expanduser("~/.local/lib/herdr"))
    import herdr_ipc
"""

import json
import os
import re
import socket
import subprocess

__all__ = [
    "HerdrError",
    "in_herdr",
    "request",
    "socket_path",
    "registry_dir",
    "workspace_socket",
    "pane_file",
    "read_pane_owner",
    "nvim_alive",
    "remote_expr",
    "vim_string",
    "focus_pane",
    "current_pane_id",
]


class HerdrError(RuntimeError):
    """A herdr API call returned an error, or the server is unreachable."""


# --- herdr socket API -------------------------------------------------------


def in_herdr():
    """True when the caller is running inside a herdr-managed pane."""
    return os.environ.get("HERDR_ENV") == "1"


def socket_path():
    """Resolve the herdr server socket the same way the herdr CLI does.

    Explicit override, then named session, then the default.
    """
    override = os.environ.get("HERDR_SOCKET_PATH")
    if override:
        return override

    config = os.environ.get("XDG_CONFIG_HOME") or os.path.expanduser("~/.config")
    session = os.environ.get("HERDR_SESSION")
    if session:
        return os.path.join(config, "herdr", "sessions", session, "herdr.sock")
    return os.path.join(config, "herdr", "herdr.sock")


def request(method, params=None, client_id="dotfiles", timeout=10):
    """Send one request and return its result.

    The server answers a single request per connection, so each call opens and
    closes its own socket.
    """
    payload = json.dumps(
        {"id": client_id, "method": method, "params": params or {}}
    ) + "\n"

    try:
        with socket.socket(socket.AF_UNIX) as sock:
            sock.settimeout(timeout)
            sock.connect(socket_path())
            with sock.makefile("rwb") as stream:
                stream.write(payload.encode())
                stream.flush()
                line = stream.readline()
    except OSError as err:
        raise HerdrError("herdr server unreachable: %s" % err) from err

    if not line:
        raise HerdrError("no response to %s" % method)

    reply = json.loads(line.decode())
    if "error" in reply:
        error = reply["error"]
        raise HerdrError(
            "%s: %s" % (method, error.get("message", json.dumps(error)))
        )
    return reply["result"]


def current_pane_id():
    """The pane to act on.

    Prefer the caller's own pane, which herdr injects into every managed pane.
    Keybinding commands run detached from any pane and have no such variable,
    so those fall back to whichever pane the UI has focused -- which for a
    keypress is exactly the pane the user pressed it in.
    """
    own = os.environ.get("HERDR_PANE_ID")
    if own:
        return own
    return request("pane.current")["pane"]["pane_id"]


def focus_pane(pane_id):
    """Focus a pane by id, and the workspace and tab holding it."""
    request("pane.focus", {"pane_id": pane_id})


# --- Neovim server registry -------------------------------------------------


def registry_dir():
    """Directory holding the socket-per-workspace and socket-per-pane entries.

    $XDG_RUNTIME_DIR is a tmpfs that is cleared on logout, which is exactly the
    lifetime we want. macOS has no such variable, so fall back to a
    user-private directory under $TMPDIR.
    """
    runtime = os.environ.get("XDG_RUNTIME_DIR")
    if runtime and os.path.isdir(runtime):
        base = os.path.join(runtime, "herdr-nvim")
    else:
        tmp = os.environ.get("TMPDIR", "/tmp").rstrip("/")
        base = os.path.join(tmp, "herdr-nvim-%d" % os.getuid())

    os.makedirs(base, mode=0o700, exist_ok=True)
    return base


def _slug(value):
    """herdr ids look like `w1:p2`; a colon is legal in a filename but ugly."""
    return re.sub(r"[^A-Za-z0-9_.-]", "_", value)


def workspace_socket(workspace_id):
    """Socket of the Neovim instance that owns a workspace.

    One per workspace is the whole point: a workspace is a project checkout, so
    every pane in it edits through the same buffers, jumplist and LSP clients.
    """
    return os.path.join(registry_dir(), "ws-%s.sock" % _slug(workspace_id))


def pane_file(workspace_id):
    """File recording which pane hosts a workspace's Neovim server."""
    return os.path.join(registry_dir(), "ws-%s.pane" % _slug(workspace_id))


def read_pane_owner(workspace_id):
    """The pane id hosting this workspace's Neovim, or None."""
    try:
        with open(pane_file(workspace_id)) as handle:
            return handle.read().strip() or None
    except OSError:
        return None


def remote_expr(sock, expr, timeout=5):
    """Evaluate `expr` in the Neovim listening on `sock`; None if it cannot.

    stdin is closed deliberately. A --remote-expr client that inherits a
    terminal on stdin sets up a TUI on stdout and reports the expression's
    value on stderr instead; with no terminal anywhere it prints the value to
    stdout and nothing else. Closing stdin forces the second, parseable shape
    even when the caller is attached to a pane.
    """
    try:
        result = subprocess.run(
            ["nvim", "--server", sock, "--remote-expr", expr],
            stdin=subprocess.DEVNULL,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            timeout=timeout,
        )
    except (OSError, subprocess.TimeoutExpired):
        return None
    if result.returncode != 0:
        return None
    return result.stdout.decode("utf-8", "replace").strip()


def nvim_alive(sock, timeout=5):
    """True when a Neovim server is actually listening on `sock`.

    A crashed or killed Neovim leaves its socket file behind, so the file
    existing proves nothing. Asking the server to evaluate a constant is the
    cheapest round trip that proves it answers.
    """
    if not sock or not os.path.exists(sock):
        return False
    return remote_expr(sock, "1", timeout=timeout) == "1"


def vim_string(value):
    """Quote a Python string as a Vim string literal."""
    return "'%s'" % value.replace("'", "''")
