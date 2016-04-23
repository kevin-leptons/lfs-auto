#!/bin/bash

# using     : this script contains variable use in linux from scratch auto-build
# author    : kevin.leptons@gmail.com

# virtual disk
lfs_disk_file="lfs-disk.img"
lfs_disk_size="32G"

# log
log_build_file=$(realpath "./log/build.log")

# box
docker_name="kevinleptons/lfs-auto"
docker_script_dir="/lfs-script"

# mount point of disk device
# do not use mount point in other disk device mount point
# it is easy to mistake when build or work with file system
# use directory in standard mount point as /mnt or /media
# this directory to know as root of lfs system
root="/mnt/lfs"
