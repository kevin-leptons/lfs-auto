#!/bin/bash

# using     : prepare lfs user and partition
# user      : root is current user when execute this script
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"

# change to /lfs-script
cd /lfs-script

# require root permision
$__dir__/require-root.sh

# use configuration
# use util
source configuration.sh
source util.sh

# define variables
task_name="container"

# create log directory
# create tmp directory
mkdir -vp $__dir__/log
mkdir -vp /lfs-script/tmp

# clear log files
# log start
clear_log
log "$task_name.start" 0

# create user
./dev-user.create.sh
exit_on_error

# prepare partition
./partition.setup.sh
exit_on_error

# copy sources
./source-code.copy.sh

# chnage ownwership of /lfs-script/tmp
chown lfs:lfs -R /lfs-script/tmp
log "/lfs-script/tmp.chown" $?

# change ownwership of /lfs-script/log
chown lfs:lfs -R $__dir__/log
log "/lfs-script/log.chown" $?

# login as lfs user and continue process
sudo -u $build_user bash box.dev.login.sh "$1"
