#!/usr/bin/env python3

from functools import partial
import subprocess
import sys
import time

from i3ipc import Connection

run = partial(
    subprocess.run,
    stdout=subprocess.PIPE,
    stderr=subprocess.STDOUT,
)

i3 = Connection()


def is_running() -> bool:
    proc = run(
        ['pgrep', '-c', '-f', 'scratchkonsole'],
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )
    return int(proc.stdout.decode().strip()) > 0


def is_focused() -> bool:
    if not is_running():
        return False

    focused = i3.get_tree().find_focused()
    return focused.window_class == 'konsole'


def main():
    if not is_running():
        subprocess.Popen([
            'env', 'DROPDOWN=1',
            'konsole', '--title', 'scratchkonsole', '&',
        ])
        time.sleep(0.3)
        run([
            'i3-msg', '-q', '[class="konsole"]', 'scratchpad', 'show',
        ])

        if 'hide' in sys.argv:
            run([
                'i3-msg', '-q', '[class="konsole"]', 'scratchpad', 'show',
            ])
        return

    if is_focused():
        run([
            'i3-msg', '-q', '[class="konsole"]', 'scratchpad', 'show',
        ])
        return

    # Focus the scratchpad on the workspace
    run([
        'i3-msg', '-q', '[class="konsole"]', 'focus',
    ])


if __name__ == '__main__':
    main()
