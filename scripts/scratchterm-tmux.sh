#!/usr/bin/env zsh

session_name=dropdown
tmux new -s $session_name >/dev/null 2>&1 || tmux attach -t $session_name
