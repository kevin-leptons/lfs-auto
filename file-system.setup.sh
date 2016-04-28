#!/bin/bash

# using     : create disk file, using to make virtual disk on build
# author    : kevin.leptons@gmail.com

# exit on error
set -e

# libs
source config.sh
source util.sh

# variables
task_name="lfs-disk"
lfs_disk_path=$(realpath ./disk/$lfs_disk_file)

# start
log "$task_name.start" 0

# create directory to store virtual disk
mkdir -vp disk

# create disk image
if [ -f $lfs_disk_path ]; then
    log "lfs-disk.create.idle" 0
else
    # create disk file
    log "lfs-disk.create.start" 0
    fallocate -l $lfs_disk_size $lfs_disk_path
    log "lfs-disk.create.finish" $?

    # format disk file
    log "lfs-disk.format.start" 0
    sudo mkfs.ext4 -F $lfs_disk_path
    log "lfs-disk.format.finish" $?
fi

# create mount point
sudo mkdir -pv $root

# mount disk device
# and exit
if ! grep -qa $root /proc/mounts; then
    sudo mount -v $lfs_disk_path $root
    log "lfs-disk.mount" $?
fi

# exit
log "$task_name.finish" $?
exit 0