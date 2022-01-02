#!/usr/bin/env bash

session_name=dropdown
tmux new -s $session_name &>/dev/null || tmux attach -t $session_name
