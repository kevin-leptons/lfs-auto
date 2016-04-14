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

# redirect all data from stdout to /dev/null
# exec > /dev/null

# change to /lfs-script
cd /lfs-script

# create log directory
# create tmp directory
sudo mkdir -vp $__dir__/log
sudo mkdir -vp /lfs-script/tmp

# clear log files
# log start
clear_log
log_auto "$task_name.start" 0

# create user
./create-build-user.sh

# prepare partition
./prepare-partition.sh

# change ownwership of /mnt/lfs
sudo chown lfs:lfs -R /mnt/lfs
log_auto "/mnt/lfs.chown" $?

# chnage ownwership of /lfs-script/tmp
sudo chown lfs:lfs -R /lfs-script/tmp
log_auto "/lfs-script/tmp.chown" $?

# change ownwership of /lfs-script/log
sudo chown lfs:lfs -R $__dir__/log
log_auto "/lfs-script/log.chown" $?

# call build instruction
./build.sh
