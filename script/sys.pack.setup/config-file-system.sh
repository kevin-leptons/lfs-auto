#!/bin/bash

# using     : configure file system
# author    : kevin.leptons@gmail.com

# libs
source util.sh

# variables
task_name="sys.fs.configure"

config_fs() {
    cp -vpu asset/etc.fstab /etc/fstab
}

run_step "$task_name" config_fs force
