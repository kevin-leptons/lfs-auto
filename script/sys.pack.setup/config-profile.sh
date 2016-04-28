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
    cp -vp asset/etc.profile /etc/profile
}

run_step "$task_name" config_profile
