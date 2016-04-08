#!/bin/bash

# using     : run docker and build lfs inside docker
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

# log start run
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

# build docker
docker build -t $docker_name $__dir__
if [[ $? != 0 ]]; then
    log "$task_name.finish" false
    exit 1
fi

# run docker
# mount hard disk use to build lfs into docker
# $root:root is mean <host-file-system>:<docker-file-system>
lfs_disk_path=$(realpath $__dir__/disk/$lfs_disk_file)
docker run -ti --privileged -v $root:$root -v \
   $script_dir:$docker_script_dir $docker_name
if [[ $? != 0 ]]; then
   log "$task_name.finish" false
   exit 1
fi

# successfull
log "$task_name.finish" true
exit 0
