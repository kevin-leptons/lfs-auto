#!/bin/bash

# using     : run docker and build lfs inside docker
# params    :
#   $1
#       con: enter container environemnt under lfs user
#       tsys: enter virtual-kernel.temporary-system under root user
#       sys: enter virtual-kernel.system under root user
#       "other": run setup imediately
# author    : kevin.leptons@gmail.com

# locate locatin of this script
__dir__="$(dirname "$0")"
script_dir="$(readlink -f $__dir__/script)"

# find all bug of bash script
./find-bug.sh
if [[ $? != 0 ]]; then
    exit 1
fi

# use configuration
# use util
source $script_dir/configuration.sh
source util.sh

# define variables
task_name="lfs-auto"
lfs_disk_path="disk/$lfs_disk_file"

# clear log file
# and log start run
clear_log
log "$task_name.start" 0

# prepare packages
./prepare-package.sh
exit_on_error

# prepare virtual disk
./prepare-disk.sh
exit_on_error

# build container
log "container.setup.start" 0
cd container
docker build -t $docker_name ./
log "container.setup.finish" $?
cd ..

# run docker
# mount hard disk use to build lfs into docker
# $root:root is mean <host-file-system>:<docker-file-system>
log "$task_name.docker.start" 0
docker run -ti --privileged -v $root:$root \
    -v $script_dir:$docker_script_dir $docker_name \
    bash /lfs-script/entry-container.sh $1
log "$task_name.docker.finish" $?

# release disk
sudo umount /mnt/lfs

# successfull
log "$task_name.finish" $?
exit 0
