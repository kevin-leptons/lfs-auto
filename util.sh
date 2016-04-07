#!/bin/bash

# using     : contains util functions
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"

# define variables
log_file=$__dir__/log/process.log

# using     : current time by format
# return    : date time string format by %Y-%m-%d %H:%M:%S
current_time() {
    echo $(date +"%Y-%m-%d %H:%M:%S")
}

# write information into file and console
# log file in ./log/process.log
# prams:
#   $1: message
#   $2: result in enum { true, false }. true is successfull, false is error
# return: 0 on successfull, 1 on error
log() {

    # get time
    log_time=$(current_time)

    # convert result
    result="?"

    if [[ $2 == true ]]; then
        result="ok"
    fi

    if [[ $2 == false ]];then
        result="no"
    fi

    # log to file
    printf "%s\n" "$log_time" >> $log_file
    printf "%-78s%2s\n\n" "$1" "$result" >> $log_file

    # log to console
    printf "%s\n" "$log_time"
    printf "%-78s%2s\n\n" "$1" "$result"

    # check error
    if [[ $? != 0 ]]; then
        return 0
    fi

    # successfull
    return 0
}

# clear log file
# log file in ./log/process.log
# return: 0 on successfull, 1 on error
clear_log() {

    if [ -f $log_file ]; then
        > $log_file
    fi

    # check error
    if [[ $? != 0 ]]; then
        return 1
    fi

    # successfull
    return 0
}
