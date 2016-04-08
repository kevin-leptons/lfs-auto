#!/bin/bash

# using     : create disk file, using to make virtual disk on build
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"

# use configuration
# use util
source $__dir__/script/configuration.sh
source $__dir__/util.sh

# define variables
task_name="lfs-disk"
lfs_disk_path=$__dir__/disk/$lfs_disk_file

# log start task
log "$task_name.start" true

# create directory to store virtual disk
mkdir -vp $__dir__/disk

# create disk image
if [ ! -f $lfs_disk_path ]; then

    # create disk file
    log "lfs-disk.create.start" true
    fallocate -v -l $lfs_disk_size $lfs_disk_path
    if [[ $? != 0 ]]; then
        log "lfs-disk.create.finish" false
        exit 1
    else
        log "lfs-disk.create.finish" true
    fi

    # format disk file
    log "lfs-disk.format.start" true
    sudo mkfs.ext4 -F $lfs_disk_path
    if [[ $? != 0 ]]; then
        log "lfs-disk.format.finish" false
        exit 1
    else
        log "lfs-disk.format.finish" true
    fi
else
    log "lfs-disk.create.idle" true
fi

# create mount point
sudo mkdir -pv $root

# mount disk device
# and exit
if ! grep -qa $root /proc/mounts; then
    sudo mount -v $lfs_disk_path $root
fi
if [[ $? != 0 ]]; then
    log "lfs-disk.mount" false
    log "$task_name.finish" false
    exit 1
else
    log "lfs-disk.mount" true
    log "$task_name.finish" true
    exit 0
fi

# exit
