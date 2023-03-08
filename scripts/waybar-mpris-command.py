#!/usr/bin/env python

import asyncio
import re
import sys

RE_AMP = re.compile(r'\&(?!amp;)')

COMMAND = [
    'waybar-mpris',
    '--autofocus',
    '--order', 'SYMBOL:TITLE:ARTIST',
    '--pause', '',
    '--play', '',
]


async def main():
    proc = await asyncio.subprocess.create_subprocess_exec(
        *COMMAND,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.DEVNULL,
    )

    # type check
    if proc.stdout is None:
        return

    while proc.returncode is None:
        try:
            line = (await proc.stdout.readline()).decode()
            sys.stdout.buffer.write(RE_AMP.sub(r'&amp;', line).encode())
            sys.stdout.buffer.flush()
        except KeyboardInterrupt:
            proc.terminate()
            break


if __name__ == '__main__':
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        pass
