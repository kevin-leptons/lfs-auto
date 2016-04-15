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
task_name="entry-lfs"

# create log directory
# create tmp directory
mkdir -vp $__dir__/log
mkdir -vp /lfs-script/tmp

# clear log files
# log start
clear_log
log "$task_name.start" 0

# create user
./create-build-user.sh

# prepare partition
./prepare-partition.sh

# change ownwership of /mnt/lfs
chown lfs:lfs -R /mnt/lfs
log "/mnt/lfs.chown" $?

# chnage ownwership of /lfs-script/tmp
chown lfs:lfs -R /lfs-script/tmp
log "/lfs-script/tmp.chown" $?

# change ownwership of /lfs-script/log
chown lfs:lfs -R $__dir__/log
log "/lfs-script/log.chown" $?

# prepare handle error
build_output="log/out.log"
set -e
dump_output() {
    echo "last 500 line of stdout"
    tail -500 $build_output
}
error_handle() {
    echo "error"
    dump_output
    exit 1
}
# trap "error_handle" ERR
# bash travis-keep-build-live.sh &
# keep_live_id=$!

# login into lfs user
# call build instruction
# sudo -u $build_user bash build.sh > /dev/null 2> $build_output
sudo -u $build_user bash

# kill $keep_live_id
# dump_output
