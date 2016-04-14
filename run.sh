#!/bin/bash

# using     : run docker and build lfs inside docker
# params    :
# author    : kevin.leptons@gmail.com

# locate locatin of this script
__dir__="$(dirname "$0")"
script_dir="$(readlink -f $__dir__/script)"

# use configuration
# use util
source $script_dir/configuration.sh
source $__dir__/util.sh

# define variables
task_name="lfs-auto"
lfs_disk_path="disk/$lfs_disk_file"

# clear log file
# and log start run
clear_log
log "$task_name.start" true

# prepare packages
./prepare-package.sh
if [[ $? != 0 ]]; then
    log "$task_name.finish" false
    exit 1
fi

# prepare virtual disk
./prepare-disk.sh
if [[ $? != 0 ]]; then
    log "$task_name.finish" false
    exit 1
fi

# pull docker
docker pull $docker_name
log_auto "$docker_name.pull" $?

# run docker
# mount hard disk use to build lfs into docker
# $root:root is mean <host-file-system>:<docker-file-system>
log "$task_name.docker.start" true
docker run -ti --privileged -v $root:$root -v \
   $script_dir:$docker_script_dir $docker_name
if [[ $? != 0 ]]; then
    log "$task_name.docker.finish" false
    log "$task_name.finish" false
    exit 1
fi

# successfull
log "$task_name.docker.finish" true
log "$task_name.finish" true
exit 0
