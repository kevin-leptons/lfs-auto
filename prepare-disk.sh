#!/bin/bash

# using     : create disk file, using to make virtual disk on build
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"

# use configuration
source $__dir__/script/configuration.sh

# define variables
lfs_disk_path=$__dir__/disk/$lfs_disk_file

# create directory to store virtual disk
if [ ! -d $__dir__/disk ]; then
    mkdir -vp $__dir__/disk
fi

# create disk image
if [ ! -f $lfs_disk_path ]; then
    fallocate -v -l $lfs_disk_size $lfs_disk_path
    sudo mkfs.ext4 -F $lfs_disk_path
fi

# create mount point
sudo mkdir -pv $root

# mount disk device
if ! grep -qa $root /proc/mounts; then
    sudo mount -v $lfs_disk_path $root
fi
