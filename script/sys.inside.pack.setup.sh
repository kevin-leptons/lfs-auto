#!/bin/bash

# using     : setup inside of system
# author    : kevin.leptons@gmail.com

# bash options
set -e

# locate location of this script
cd /lfs-script

# libs
source configuration.sh
source util.sh

# variables
task_name="sys.inside.setup"

# unset hash
set +h

# start
log "$task_name.start" 0

packages=( \
    lfs-bootscripts \
    config-network \
    config-systemv \
    config-profile \
    config-inputrc \
    config-shell \
    config-file-system \
    kernel \
    config-grub \
    create-status-build \
)

# build each package
# log is generate by internal build script
result=done
for package in ${packages[@]}; do
    $build_sysem_dir/$package.sh
done

# successfull
log "$task_name.setup.finish" $?
exit 0
