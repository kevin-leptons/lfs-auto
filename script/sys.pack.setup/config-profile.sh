#!/bin/bash

# using     : configure profile
# author    : kevin.leptons@gmail.com

# libs
source configuration.sh
source util.sh

# variables
task_name="sys.profile.configure"

config_profile() {
    # create /etc/profile
    cp -vp asset/etc.profile.sh /etc/profile
}

run_step "$task_name" config_profile
