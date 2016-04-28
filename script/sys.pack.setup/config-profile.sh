#!/bin/bash

# using     : configure profile
# author    : kevin.leptons@gmail.com

# libs
source configuration.sh
source util.sh

# variables
task_name="profile.configure"

config_profile() {
    # create /etc/profile
    cat > /etc/profile << "EOF"
    # Begin /etc/profile

    export LANG=en_US.UTF-8

    # End /etc/profile
    EOF
}

run_step "$task_name" config_profile
