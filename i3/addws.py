#!/usr/bin/env python3

from i3ipc import Connection

i3 = Connection()
ws_list = {num: False for num in range(1, 11)}

for ws in i3.get_tree().workspaces():
    ws_list[ws.num] = bool(ws.leaves())

for num, exist in sorted(ws_list.items()):
    if not exist:
        i3.command('workspace {}'.format(num))
        break
