#!/bin/bash

# using     : configure file system
# author    : kevin.leptons@gmail.com

# libs
source util.sh

# variables
task_name="fs.configure"

config_fs() {
    # create /etc/fstab
    cat > /etc/fstab << "EOF"
    # Begin /etc/fstab

    # file system  mount-point  type     options             dump  fsck
    #                                                              order

    /dev/sdb1     /             ext4     defaults            1     1
    #/dev/<yyy>     swap        swap     pri=1               0     0
    proc           /proc        proc     nosuid,noexec,nodev 0     0
    sysfs          /sys         sysfs    nosuid,noexec,nodev 0     0
    devpts         /dev/pts     devpts   gid=5,mode=620      0     0
    tmpfs          /run         tmpfs    defaults            0     0
    devtmpfs       /dev         devtmpfs mode=0755,nosuid    0     0

    # End /etc/fstab
    EOF
}

run_step "$task_name" config_fs
