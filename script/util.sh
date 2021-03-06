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
#   $1: name of task
#   $2: returned value from pre-command
#   $3: message
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

    # convert message
    if [[ $3 == "" ]]; then
        msg="no-message"
    else
        msg=$3
    fi

    # log to file
    printf "%s\n" "$log_time" >> "$log_build_file"
    printf "%-78s%2s\n" "$1" "$result" >> "$log_build_file"
    printf "%s\n\n" $msg >> "$log_build_file"

    # log to console
    printf "%s\n" "$log_time"
    printf "%-78s%2s\n" "$1" "$result"
    printf "%s\n\n" $msg

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
}

# exit process when error
# params:
#   $1: exit code
exit_on_error() {
    if [[ $? != 0 ]]; then
        exit 1
    fi
}

# escape string
# params
#   $1: string to escape
# stdout
#   string escaped
escape_str() {
    echo $1 | sed -e 's/[]\/$*.^|[]/\\&/g'
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
    step_line=$(sed -ne "/^$keywork\s/p" "$index_step_file")
    if [[ $step_line == '' ]]; then
        echo "idle"
        return 0
    fi

    # state of step is ok
    step_ok=$(echo "$step_line" | sed -ne "/ok$/p")
    if [[ $step_ok != '' ]]; then
        echo "ok"
        return 0
    fi

    # state of step is no
    step_no=$(echo "$step_line" | sed -ne "/no$/p")
    if [[ $step_no != '' ]]; then
        echo 'no'
        return 0
    fi

    # state of step is undefined
    echo '?'
    return 0
}

# index state of step
# params
#   $1: name of step
#   $2: 0 is ok, 1 is no
index_step() {

    # escape string
    step_name=$(escape_str $1)

    # remove all index is early exists
    sed -i "/^$step_name.*$/d" "$index_step_file"

    # switch state
    case $2 in
        0 ) state="ok";;
        1 ) state="no";;
        * ) return 0;;
    esac

    # create new index
    printf "%-78s%2s\n\n" "$1" "$state" >> "$index_step_file"
    return 0
}

# run function contains setup instructions
# params
#   $1 required: name of step
#   $2 required: name of setup function
#   $3 optionn: enum { force, <null> }
run_step() {

    state=$(step_state "$1")

    if [[ $state == "idle" || $state == "no" || $3 == "force" ]]; then

        #start
        log "$1.start" 0

        # call setup function
        $2

        # store exit code
        exit_code=$?

        # index step
        index_step "$1" $exit_code

        # finish
        log "$1.finish" $exit_code

    elif [[ $state == "ok" ]]; then
        log "$1.skip" 0
    else
        log "$1.state.undefined" 1
    fi

}

# using     : valid script run as root
#             it use in head of other script to warning that script must run as
#             root
require_root() {
    if [ "$(id -u)" != "0" ]; then
        echo "error: the script must be run as root"
        exit 1
    fi
}

# using     : verify array contain element
# param
#   $1: array, pass by "array_name[@]"
#   $2: element to verify
in_array() {
    local is_contain=1
    local array="${!1}"
    for elem in ${array[@]}; do
        if [[ "$elem" == "$2" ]]; then
            is_contain=0
            break
        fi
    done
    return $is_contain
}

# using     : parse param by name and split by comma to array
# param     :
#   $1: arguments
#   $2: name of parameter to parse
# return    : array
param_name() {
    local value=""
    local params="${!1}"
    local found=1
    for param in ${params[@]}; do
        if [[ $param == "$2=*" ]]; then
            found=0
            break
        fi
    done

    if [[ ! found ]]; then
        exit 1
    else
        echo $params | cut -d"=" -f2 | sed -e 's/,/ /g'
    fi

    return 0
}
