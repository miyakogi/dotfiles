#!/usr/bin/env python3

import re
import shutil
import subprocess
import sys
from typing import List

if shutil.which('pulsemixer') is None:
    exit(1)


def get_ff_sink_ids() -> List[str]:
    proc = subprocess.run(
        ['pulsemixer', '--list-sinks'],
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )
    sinks_all = proc.stdout.decode()

    results = []
    for sink in sinks_all.splitlines():
        if 'Name: Firefox' not in sink:
            continue
        m = re.search(r'ID:\s+([\w\d_-]+)', sink)
        if m:
            sink = m.groups(1)[0]
            results.append(sink)

    return results


def get_volume(sink: str) -> str:
    proc = subprocess.run(
        ['pulsemixer', '--id', sink, '--get-volume'],
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )
    return proc.stdout.decode().strip()


def check_ff_volumes() -> str:
    sinks = get_ff_sink_ids()
    for sink in sinks:
        if get_volume(sink) != '100 100':
            return ''
    return ''


def fix_ff_volumes() -> None:
    sinks = get_ff_sink_ids()
    for sink in sinks:
        if get_volume(sink) != '100 100':
            subprocess.run(['pulsemixer', '--id', sink, '--set-volume', '100'])


def main() -> None:
    if 'check' in sys.argv:
        print(check_ff_volumes())  # print for polybar
    elif 'fix' in sys.argv:
        fix_ff_volumes()
    else:
        exit(1)


if __name__ == '__main__':
    main()
