#!/bin/bash

# using     : contains util function
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# using     : current time by format
# return    : date time string format by %Y-%m-%d %H:%M:%S
current_time() {
    echo $(date +"%Y-%m-%d %H:%M:%S")
}

# using     : write information to log file
# params    :
#   $1: message
#   $2: result in enum { true, false }. true is successfull, false is error
log_build() {

    # get time
    log_time=$(current_time)

    # convert result
    result="?"

    if [[ $2 == true ]]; then
        result="done"
    fi

    if [[ $2 == false ]];then
        result="error"
    fi

    # log to file
    printf "%s\n" "$log_time" >> $log_build_file
    printf "%-75s%5s\n\n" "$1" "$result" >> $log_build_file

    # log to console
    printf "%s\n" "$log_time"
    printf "%-75s%5s\n" "$1" "$result"
}
