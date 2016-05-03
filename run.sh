#!/bin/bash

# using     : setup box and use it to setup gnu/linux system
# params    :
#   $1
#       box: enter container environemnt under lfs user
#       tmp-sys: enter virtual-kernel.temporary-system under root user
#       sys: enter virtual-kernel.system under root user
#       "other": run setup imediately
# author    : kevin.leptons@gmail.com

# bash options
set -e

# script.verify
./script.verify.sh

# enssential-dir.mkdir
mkdir -vp log tmp disk

# libs
source config.sh
source util.sh

# variables
task_name="lfs"
lfs_disk_path="disk/$lfs_disk_file"
script_dir=$(realpath ./script)

# log-file.clear
clear_log
log "$task_name.start" 0

# host.pack.setup
./host.pack.setup.sh

# host.fs.setup
./host.fs.setup.sh

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
    -v "$root":"$root" \
    -v "$script_dir":"$docker_script_dir" "$docker_name" \
    bash /lfs-script/box.entry.sh "$@"
log "$task_name.box.finish" $?

# file-system.umount
sudo umount /mnt/lfs
log "lfs-disk.umount" $?

# successfull
log "$task_name.finish" $?
exit 0
