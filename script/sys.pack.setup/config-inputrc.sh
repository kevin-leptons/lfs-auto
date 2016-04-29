#!/bin/bash

# using     : configure inputrc
# author    : kevin.leptons@gmail.com

# bash options
set -e

# libs
source configuration.sh
source util.sh

# variables
task_name="inputrc.configure"

config_inputrc() {
    # create /etc/inputrc
    cp -vp asset/etc.inputrc.sh /etc/inputrc
}

run_step "$task_name" config_inputrc
