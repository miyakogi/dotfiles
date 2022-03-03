#!/usr/bin/env python3

import os
import subprocess
import time
from typing import Optional

from i3ipc import Connection, Con

i3 = Connection()
TERM_CLASS = 'scratchterm'

# --- Define Command for Dropdown Terminal
# Example (kitty without tmux):
# TERM_CMD = [
#     'kitty',
#     '--class', TERM_CLASS,
#     '--override', 'background_opacity=0.85',
#     '--override', 'window_padding_width=2',
# ]
if os.getenv('WAYLAND_SOCKET') or os.getenv('XDG_SESSION_TYPE') == 'wayland':
    # on wayland, use foot with tmux
    TERM_CMD = [
        'foot',
        '--app-id', TERM_CLASS,
        '--term', 'xterm-256color',  # need true color support
        '--override=colors.alpha=0.7',
        '--override=pad=2x2',
        'scratchterm-tmux',
    ]
else:
    # on Xorg, use alacritty with tmux
    TERM_CMD = [
        'alacritty',
        '--class', TERM_CLASS,
        '--option', 'env.TERM=xterm-256color',  # need true color support
        '--option', 'window.opacity=0.7',
        '--option', 'window.padding.x=2',
        '--option', 'window.padding.y=2',
        '--command', 'scratchterm-tmux',
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
        window.command('focus')


if __name__ == '__main__':
    main()
