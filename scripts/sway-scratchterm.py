#!/usr/bin/env python3

import subprocess
import time
from typing import Optional

from i3ipc import Connection, Con

i3 = Connection()
TERM_CLASS = 'scratchterm'

# --- Define Command for Dropdown Terminal
# on Wayland, use foot
TERM_CMD = [
    'foot',
    '--app-id', TERM_CLASS,
    '--override=colors.alpha=0.85',
    '--override=pad=2x2',
]


def get_window() -> Optional[Con]:
    root = i3.get_tree()
    for win in root:
        if TERM_CLASS in (win.window_class, win.window_instance, win.app_id):
            return win
    return None


def main() -> None:
    window = get_window()

    if window is None:
        # start dropdown terminal
        subprocess.Popen(TERM_CMD)

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
        window.command('scratchpad show')

    elif window.focused:
        # hide scratchpad
        window.command('scratchpad show')

    else:
        # Focus the scratchpad on the workspace
        if hasattr(window, 'app_id'):
            # Wayland (sway)
            # always open scratchpad on right display (DP-2)
            i3.command('focus output DP-2')
        window.command('focus')


if __name__ == '__main__':
    main()
