#!/usr/bin/env python3

import subprocess
import sys
import time
from typing import Optional

from i3ipc import Connection, Con

i3 = Connection()


def is_running() -> bool:
    proc = subprocess.run(
        ['pgrep', '-c', '-f', 'scratchkonsole'],
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )
    try:
        return int(proc.stdout.decode().strip()) > 0
    except ValueError:
        return False


def is_focused() -> bool:
    if not is_running():
        return False

    focused = i3.get_tree().find_focused()
    return focused.window_class == 'konsole'


def get_window() -> Optional[Con]:
    root = i3.get_tree()
    for win in root:
        if win.window_class == 'konsole':
            return win
    return None


def main():
    window = None

    if not is_running():
        subprocess.Popen([
            'env', 'DROPDOWN=1',
            'konsole', '--title', 'scratchkonsole', '&',
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

    if is_focused():
        # hide scratchpad
        window.command('scratchpad show')
        return

    # Focus the scratchpad on the workspace
    window.command('focus')


if __name__ == '__main__':
    main()
