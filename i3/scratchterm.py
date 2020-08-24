#!/usr/bin/env python3

import subprocess
import sys
import time
from typing import Optional

from i3ipc import Connection, Con

i3 = Connection()
TERM = 'kitty'
TERM_CLASS = 'scratchkitty'


def is_running() -> bool:
    proc = subprocess.run(
        ['pgrep', '-c', '-f', TERM_CLASS],
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )
    try:
        return int(proc.stdout.decode().strip()) > 0
    except ValueError:
        return False


def get_window() -> Optional[Con]:
    root = i3.get_tree()
    for win in root:
        if win.window_class == TERM_CLASS:
            return win
    return None


def main() -> None:
    window = None

    if not is_running():
        subprocess.Popen([
            'env', 'DROPDOWN=1', TERM,
            '--class', TERM_CLASS,
            '--override', 'background_opacity=0.7',
            '--override', 'window_padding_width=0',
        ])
        for _ in range(100):
            time.sleep(0.01)
            window = get_window()
            if window is not None:
                break

        if window is None:
            return

        # add konsole to scratchpad
        window.command('scratchpad show')

        if 'hide' in sys.argv:
            # hide scratchpad
            window.command('scratchpad show')
        return

    window = get_window()
    if window is None:
        return

    if window.focused:
        # hide scratchpad
        window.command('scratchpad show')
    else:
        # Focus the scratchpad on the workspace
        window.command('focus')


if __name__ == '__main__':
    main()
