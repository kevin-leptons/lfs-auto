#!/bin/bash

# using     : contains util function
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source configuration.sh

# using     : current time by format
# return    : date time string format by %Y-%m-%d %H:%M:%S
current_time() {
    echo $(date +"%Y-%m-%d %H:%M:%S")
}

# using     : write information to log file. exit if error
# params    :
#   $1: message name
#   $2: returned value from pre-command
# exit on $1 != 0
log() {

    # get time
    log_time=$(current_time)

    # convert result
    result="?"

    if [[ $2 == 0 ]]; then
        result="ok"
    else
        result="no"
    fi

    # log to file
    printf "%s\n" "$log_time" >> "$log_build_file"
    printf "%-78s%2s\n\n" "$1" "$result" >> "$log_build_file"

    # log to console
    printf "%s\n" "$log_time"
    printf "%-78s%2s\n\n" "$1" "$result"

    # exit if error
    if [[ $2 != 0 ]]; then
        exit 1
    fi

    # successfull
    return 0
}

# clear log file
# log file in ./log/build.log
# return: 0 on successfull, 1 on error
clear_log() {

    if [ -f $log_build_file ]; then
        > $log_build_file
    fi

    # check error
    if [[ $? != 0 ]]; then
        return 1
    fi

    # successfull
    return 0
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
    echo $?
}

# function compare version string
# params:
#   $1: first version string
#   $2: second version string
# return:
#   0: on first version less than second version
#   1: on first version greater than second version
version_lt() {
    test "$(echo "$@" | tr " " "\n" | sort -V | head -n 1)" == "$1";
    echo $?
}

# function compare two string
# params:
#   $1: first string
#   $2: second string
# return:
#     0: on two string are same
#     1: on two string are different
str_eq() {
    [[ "$1" == "$2" ]]
    echo $?
}

# exit process when error
# params:
#   $1: exit code
exit_on_error() {
    if [[ $? != 0 ]]; then
        exit 1
    fi
}

# check state of step of building
# params
#   $1: name of step
# return
#   0 on successfull
#   1 on error
# stdout
#   'idle': step is not run
#   'ok': step is completed
#   'no': step is not completed
#   '?': state of step is undefined
step_state() {

    # escape string
    keywork=$(echo $1 | sed -e 's/[]\/$*.^|[]/\\&/g' )

    # state of step is idle
    step_line=$(sed -ne "/$keywork/p" "$log_build_file")
    if [[ $step_line == '' ]]; then
        echo "idle"
        exit 0
    fi

    # state of step is ok
    step_ok=$(echo "$step_line" | sed -ne "/ok$/p")
    if [[ $step_ok != '' ]]; then
        echo "ok"
        exit 0
    fi

    # state of step is no
    step_no=$(echo "$step_line" | sed -ne "/no$/p")
    if [[ $step_no != '' ]]; then
        echo 'no'
        exit 0
    fi

    # state of step is undefined
    echo '?'
    exit 0
}
