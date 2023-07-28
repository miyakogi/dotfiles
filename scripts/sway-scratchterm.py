#!/usr/bin/env python3

import subprocess
import time
from typing import Optional

from i3ipc import Connection, Con

i3 = Connection()
TERM_CLASS = "scratchterm"
TERM_CLASS1 = TERM_CLASS + "-dp1"
TERM_CLASS2 = TERM_CLASS + "-dp2"

# --- Define Command for Dropdown Terminal
TERM_CMD = [
    "foot",
    "--override=colors.alpha=0.85",
]

override_font = "--override=font=JetBrainsMono Nerd Font"

TERM_CMD1 = TERM_CMD + ["--app-id", TERM_CLASS1, override_font + ":size=21"]
TERM_CMD2 = TERM_CMD + ["--app-id", TERM_CLASS2, override_font + ":size=12"]


def get_window() -> Optional[Con]:
    root = i3.get_tree()
    target_id = TERM_CLASS1 if is_hidpi() else TERM_CLASS2
    for win in root:
        if target_id in (win.window_class, win.window_instance, win.app_id):
            return win
    return None


def is_hidpi() -> bool:
    for output in i3.get_outputs():
        if getattr(output, "name") == "DP-1":
            return bool(getattr(output, "focused"))
    return False


def fit_monitor(window: Con):
    new_size = "width 3200 height 1800" if is_hidpi() else "width 1600 height 900"
    window.command(f"resize set {new_size}")


def main() -> None:
    window = get_window()

    if window is None:
        # start dropdown terminal
        cmd = TERM_CMD1 if is_hidpi() else TERM_CMD2
        subprocess.Popen(cmd)

        # wait until terminal window appears (timeout: 1sec)
        for _ in range(100):
            time.sleep(0.01)
            window = get_window()
            if window is not None:
                break

        # maybe failed to start dropdown terminal
        if window is None:
            return

        # add terminal to scratchpad
        fit_monitor(window)
        window.command("scratchpad show")

    elif getattr(window, "focused"):
        # hide scratchpad
        fit_monitor(window)
        window.command("scratchpad show")

    else:
        window.command("focus")
        fit_monitor(window)


if __name__ == "__main__":
    main()
