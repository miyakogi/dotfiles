#!/usr/bin/env python3

import shutil
import subprocess
import time
from typing import Optional

from i3ipc import Connection, Con

i3 = Connection()
TERM_CLASS = "scratchterm"


def get_class(hidpi: bool) -> str:
    if hidpi:
        return TERM_CLASS + "-dp1"
    else:
        return TERM_CLASS + "-dp2"


def build_cmd(hidpi: bool) -> list[str]:
    """Define command for dropdown terminal."""
    cls = get_class(hidpi)

    cmd = [
        "app2unit",
        "foot",
    ]

    foot_options = [
        "--app-id",
        cls,
        "--override=colors.alpha=0.85",
    ]

    if hidpi:
        foot_options.append("--override=initial-window-size-pixels=3200x1800")
    else:
        foot_options.append("--override=initial-window-size-pixels=1920x1280")

    zellij_cmd = []
    if shutil.which("zellij"):
        zellij_cmd.append("zellij")
        proc = subprocess.run(f"zellij ls | grep -E '{cls}$'", shell=True)
        if proc.returncode == 0:
            zellij_cmd.append("a")
        else:
            zellij_cmd.append("-s")
        zellij_cmd.append(cls)

    return cmd + foot_options + zellij_cmd


def get_window(target_id: str) -> Optional[Con]:
    root = i3.get_tree()
    for win in root:
        if target_id in (win.window_class, win.window_instance, win.app_id):
            return win
    return None


def is_hidpi() -> bool:
    for output in i3.get_outputs():
        if getattr(output, "name") == "DP-1":
            return bool(getattr(output, "focused"))
    return False


def main() -> None:
    hidpi = is_hidpi()
    cls = get_class(hidpi)
    window = get_window(cls)

    if window is None:
        # start dropdown terminal
        cmd = build_cmd(hidpi)
        subprocess.Popen(cmd)

        # wait until terminal window appears (timeout: 1sec)
        for _ in range(100):
            time.sleep(0.01)
            window = get_window(cls)
            if window is not None:
                break

        # maybe failed to start dropdown terminal
        if window is None:
            return

        # add terminal to scratchpad
        window.command(f"[con_mark={cls}] scratchpad show")

    elif getattr(window, "focused"):
        # hide scratchpad
        window.command("move scratchpad")

    else:
        window.command("focus")


if __name__ == "__main__":
    main()
