#!/bin/bash

# using     : run docker and build lfs inside docker
# author    : kevin.leptons@gmail.com

# locate locatin of this script
__dir__="$(dirname "$0")"
script_dir="$(readlink -f $__dir__/script)"

# use configuration
source $script_dir/configuration.sh

# prepare virtual disk
./prepare-disk.sh &&

# build docker
docker build -t $docker_name $__dir__ &&

# run docker
# mount hard disk use to build lfs into docker
# $root:root is mean <host-file-system>:<docker-file-system>
lfs_disk_path=$(realpath $__dir__/disk/$lfs_disk_file)
docker run -ti --privileged -v $root:$root -v \
   $script_dir:$docker_script_dir $docker_name
