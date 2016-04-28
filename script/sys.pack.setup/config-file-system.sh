#!/bin/bash

# using     : configure file system
# author    : kevin.leptons@gmail.com

# libs
source util.sh

# variables
task_name="fs.configure"

config_fs() {
    cp -vp asset/etc.fstab /etc/fstab
}

run_step "$task_name" config_fs
