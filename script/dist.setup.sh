#!/bin/bash

# using     : pack system into an image
# author    : kevin.leptons@gmail.com

# bash options
set -e

# libs
source configuration.sh
source util.sh

# variables
task_name="dist.pack"
dist_setup_dir="dist.setup"

step_dist_setup() {

    # list all script to build package in system
    # each script not contains extension
    packages=( \
        src.setup \
        syslinux.install\
        image.pack
    )

    # build each package
    # log is generate by internal build script
    for package in ${packages[@]}; do
        $dist_setup_dir/$package.sh
    done
}

# run
run_step "$task_name" step_dist_setup
exit 0
