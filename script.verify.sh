#!/bin/bash

# using     : find grammar bug in other bash script file
# author    : kevin.leptons@gmail.com

# find all bash script file
# then find bug foreach file
for bash_file in $(find ./ -name '*.sh'); do
    bash -n "$bash_file"
    if [[ $? == 0 ]]; then
        printf "%-78s%2s\n\n" "$bash_file" "ok"
    else
        printf "%-78s%2s\n\n" "$bash_file" "no"
        printf "%-78s%2s\n\n" "bash.verify" "no"
        exit 1
    fi
done

# successfully
printf "%-78s%2s\n\n" "bash.verify" "ok"
exit 0
