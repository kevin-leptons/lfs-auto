#!/bin/bash

# using     : create status build
# author    : kevin.leptons@gmail.com

# libs
source utils.sh

# variables
task_name="build-status.config"

config_build_status() {
    # create /etc/lfs-release
    echo 7.8 > /etc/lfs-release

    # create /etc/lsb-release
    cat > /etc/lsb-release << "EOF"
    DISTRIB_ID="Linux From Scratch"
    DISTRIB_RELEASE="7.8"
    DISTRIB_CODENAME="<your name here>"
    DISTRIB_DESCRIPTION="Linux From Scratch"
    EOF
}

run_step "$task_name" config_build_status
