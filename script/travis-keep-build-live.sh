#!/bin/bash

time_start=$(date +%s)
while true; do
    time_now=$(date +%s)
    time_ep=$(date -u -d "2000/1/1 $time_now sec - $time_start sec" \
        +"%j days %H:%M:%S.%N")
    echo -ne "building from $time_start, elapsed $time_ep\r"

    sleep 1s
done
