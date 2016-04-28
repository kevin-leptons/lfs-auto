#!/bin/bash

# using     : configure systemv
# author    : kevin.leptons@gmail.com

# libs
source configuration.sh
source util.sh

# variables
task_name="systemv.configure"

config_systemv() {
    # create /etc/initab
    cp -vp asset/etc.inittab /etc/inittab
}

run_step "$task_name" config_systemv
