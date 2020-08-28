#!/bin/sh
# from https://github.com/polybar/polybar-scripts/blob/master/polybar-scripts/system-nvidia-smi/system-nvidia-smi.sh

echo $(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)%
