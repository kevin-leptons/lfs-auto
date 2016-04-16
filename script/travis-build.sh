#!/bin/bash

# using     : start build in travis environemnt
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

# redirect stdout to /dev/null
exec > /dev/nul

# add lfs user to sudores
sudo echo "lfs ALL=(ALL:ALL) ALL" >> /etc/sudoers

# create log directory
# create tmp directory
sudo mkdir -vp log
sudo mkdir -vp tmp

# clear log files
# log start
clear_log

log "$task_name.start" 0

# create user
./create-build-user.sh

# prepare partition
./prepare-partition.sh

# change ownwership of /mnt/lfs
sudo chown lfs:lfs -R /mnt/lfs
log "/mnt/lfs.chown" $?

# chnage ownwership of /lfs-script/tmp
sudo chown lfs:lfs -R tmp
log "tmp.chown" $?

# change ownwership of /lfs-script/log
sudo chown lfs:lfs -R log
log "log.chown" $?

# call build instruction
./build.sh
