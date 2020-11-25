#!/usr/bin/env python3

import asyncio
import subprocess

from i3ipc.aio import Connection
from i3ipc import Event


def echo(string: str) -> None:
    subprocess.run(['echo', string])


async def get_layout(i3: Connection, e: Event) -> None:
    root = await i3.get_tree()
    win = root.find_focused()
    if win.type == 'con' and win.name:
        if win.parent.layout.startswith('split'):
            echo('﩯')
        elif win.parent.layout == 'stacked':
            echo('类')
        elif win.parent.layout == 'tabbed':
            echo('裡')
        else:
            echo('')


async def run() -> None:
    i3 = await Connection().connect()
    i3.on(Event.TICK, get_layout)
    i3.on(Event.WINDOW, get_layout)
    i3.on(Event.WORKSPACE, get_layout)
    while True:
        await asyncio.sleep(1)


asyncio.get_event_loop().run_until_complete(run())
