#!/usr/bin/env python3

from i3ipc import Connection

i3 = Connection()
ws_list = {num: False for num in range(1, 11)}
# icons = {
#     1: '',
#     2: '',
#     3: '',
#     4: '',
#     5: '',
#     6: '',
#     7: '',
#     8: '',
#     9: '',
#     10: '者',
# }
icons = {
    1: '一',
    2: '二',
    3: '三',
    4: '四',
    5: '五',
    6: '六',
    7: '七',
    8: '八',
    9: '九',
    10: '十',
}

for ws in i3.get_tree().workspaces():
    ws_list[ws.num] = bool(ws.leaves())

for num, exist in sorted(ws_list.items()):
    if not exist:
        i3.command('workspace "{}:{}"'.format(num, icons.get(num)))
        break
