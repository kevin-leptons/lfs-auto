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
        result="ok"
    fi

    if [[ $2 == false ]];then
        result="no"
    fi

    # log to file
    printf "%s\n" "$log_time" >> $log_build_file
    printf "%-78s%2s\n\n" "$1" "$result" >> $log_build_file

    # log to console
    printf "%s\n" "$log_time"
    printf "%-78s%2s\n\n" "$1" "$result"
}

# function compare version string
# params:
#   $1: first version string
#   $2: second version string
# return:
#   0: on first version greater or equal than second version
#   1: on first version less than second version
version_gt() {
    test "$(echo "$@" | tr " " "\n" | sort -V | head -n 1)" != "$1";
}
