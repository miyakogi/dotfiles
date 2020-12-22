#!/usr/bin/env python3

import subprocess
import time
from typing import Optional

from i3ipc import Connection, Con

i3 = Connection()
TERM = 'alacritty'
TERM_CLASS = 'scratchterm'


def get_window() -> Optional[Con]:
    root = i3.get_tree()
    for win in root:
        if win.window_instance == TERM_CLASS:
            return win
    return None


def main() -> None:
    window = get_window()

    if window is None:
        subprocess.Popen([
            TERM,
            '--class', TERM_CLASS,
            '--option', 'env.TERM=xterm-256color',  # need true color support
            '--option', 'background_opacity=0.7',
            '--option', 'window.padding.x=2',
            '--option', 'window.padding.y=2',
            '--command', 'scratchterm-tmux',
        ])
        for _ in range(100):
            time.sleep(0.01)
            window = get_window()
            if window is not None:
                break

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
