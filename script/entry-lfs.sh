#!/bin/bash

# using     : prepare lfs user and partition
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"

# require root permision
$__dir__/require-root.sh

# use configuration
# use util
source $__dir__/configuration.sh
source $__dir__/util.sh

# define variables
task_name="entry-lfs"

# change to /lfs-script
cd /lfs-script

# create log directory
# create tmp directory
sudo mkdir -vp $__dir__/log
sudo mkdir -vp /lfs-script/tmp

# clear log files
# log start
clear_log

log "$task_name.start" true

# create user
$__dir__/create-build-user.sh
if [[ $? != 0 ]]; then
    log "$task_name.finish" false
    exit 1
fi

# prepare partition
$__dir__/prepare-partition.sh
if [[ $? != 0 ]]; then
    log "$task_name.finish" false
    exit 1
fi

# change ownwership of /mnt/lfs
sudo chown lfs:lfs -R /mnt/lfs
if [[ $? != 0 ]]; then
    log "/mnt/lfs.chown" false
    log "$task_name.finish" false
    exit 1
else
    log "/mnt/lfs.chown" true
fi

# chnage ownwership of /lfs-script/tmp
sudo chown lfs:lfs -R /lfs-script/tmp
if [[ $? != 0 ]]; then
    log "/lfs-script/tmp.chown" false
    log "$task_name.finish" false
    exit 1
else
    log "/lfs-script/tmp.chown" true
fi

# change ownwership of /lfs-script/log
sudo chown lfs:lfs -R $__dir__/log
if [[ $? != 0 ]]; then
    log "/lfs-script/log.chown" false
    log "$task_name.finish" false
    exit 1
else
    log "/lfs-script/log.chown" true
fi

# continue with bash with lfs user
# or start build
# log "bash.start" true
# sudo -u $build_user bash
