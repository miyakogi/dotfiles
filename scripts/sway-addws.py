#!/usr/bin/env python3

"""
Switch to the first empty workspace of current output.
This script requires python-i3ipc package.
"""

from i3ipc import Connection

i3 = Connection()
ws_list = {num: False for num in range(1, 21)}
icons = {
    1: "一",  # DP-1
    2: "二",  # DP-1
    3: "三",  # DP-1
    4: "四",  # DP-1
    5: "五",  # DP-1
    6: "六",  # DP-1
    7: "七",  # DP-1
    8: "八",  # DP-1
    9: "九",  # DP-1
    10: "十",  # DP-1
    11: "一",  # DP-2
    12: "二",  # DP-2
    13: "三",  # DP-2
    14: "四",  # DP-2
    15: "五",  # DP-2
    16: "六",  # DP-2
    17: "七",  # DP-2
    18: "八",  # DP-2
    19: "九",  # DP-2
    20: "十",  # DP-2
}

for ws in i3.get_tree().workspaces():
    ws_list[ws.num] = bool(ws.leaves())

dp1 = next(filter(lambda o: o.focused, i3.get_outputs())).name == "DP-1"
for i in range(1, 11) if dp1 else range(11, 21):
    if not ws_list[i]:
        i3.command(f"workspace {i}:{icons[i]}")
        break
