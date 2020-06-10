#!/usr/bin/env python3

import subprocess
import i3

max_ws = 0
ws_list = [[x, 0] for x in range(11)]

for ws in i3.get_workspaces():
    ws_tree = i3.filter(num=ws.get('num'))
    ws_list[int(ws.get('num'))][1] = 1

for i in ws_list:
    if i[0] > max_ws and not i[1]:
        subprocess.run(['i3-msg', 'workspace', str(i[0])])
        break
