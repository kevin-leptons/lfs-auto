#!/bin/bash

# using     : this script contains variable use in linux from scratch auto-build
# author    : kevin.leptons@gmail.com

# specifications about user will use to build lfs
build_user="lfs"
build_user_group="lfs"
build_user_password="lfs"
build_user_home="/home/$build_user"
build_user_profile_file="build_user_profile"
build_user_bashrc_file="build_user_bashrc"
docker_name="kevinleptons/lfs-auto"
docker_lfs_auto="/mnt/lfs-auto"
docker_script_dir="/lfs-script"
lfs_script_dir="/lfs-script"

# disk device where lfs partition locate
# must chose new partition without any important data
# then lfs auto-build will format it to use
partition_dev="/dev/sdb1"

# mount point of disk device
# do not use mount point in other disk device mount point
# it is easy to mistake when build or work with file system
# use directory in standard mount point as /mnt or /media
# this directory to know as root of lfs system
root="/mnt/lfs"

# directory store source code
# source code will download from internet by wget program and wget-list file
# wget-list file contains list of source code file to download
root_sources="$root/sources"
root_tmp_sources="$root_sources/tmp-build"
root_system_sources="/sources/system-build"

# directory store tools to build some packages
root_tools="$root/tools"

# hard disk will install lfs system to boot
boot_disk="/dev/sdb"
boot_grub_disk="hd1"
boot_root="/dev/sdb1"

# lfs virtual disk
lfs_disk_file="lfs-disk.img"
lfs_disk_size="64G"

# log files
log_host_package_file="log/host-package.log"
log_build_file=$(realpath "log/build.log")
index_step_file=$(realpath "tmp/step-index.txt")
