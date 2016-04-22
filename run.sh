#!/bin/bash

# using     : setup box and use it to setup gnu/linux system
# params    :
#   $1
#       box: enter container environemnt under lfs user
#       tmp-sys: enter virtual-kernel.temporary-system under root user
#       sys: enter virtual-kernel.system under root user
#       "other": run setup imediately
# author    : kevin.leptons@gmail.com

# locate locatin of this script
__dir__="$(dirname "$0")"
script_dir="$(readlink -f $__dir__/script)"

# script.verify
./script.verify.sh
if [[ $? != 0 ]]; then
    exit 1
fi

# libs
source $script_dir/configuration.sh
source util.sh

# variables
task_name="run"
lfs_disk_path="disk/$lfs_disk_file"

# log-file.clear
clear_log
log "$task_name.start" 0

# host.env.setup
./host.env.setup.sh
exit_on_error

# file-system.setup
./file-system.setup.sh
exit_on_error

# box.setup
log "$task_name.box.setup.start" 0
cd box
docker build -t $docker_name ./
log "$task_name.box.setup.finish" $?
cd ..

# box.active
# mount hard disk use to build lfs into docker
# $root:root is mean <host-file-system>:<docker-file-system>
# transfer control to /lfs-script/box.entry.sh
log "$task_name.box.start" 0
docker run -ti --privileged \
    -v $root:$root \
    -v $script_dir:$docker_script_dir $docker_name \
    bash /lfs-script/box.entry.sh $1
log "$task_name.box.finish" $?

# file-system.umount
sudo umount /mnt/lfs

# successfull
log "$task_name.finish" $?
exit 0
