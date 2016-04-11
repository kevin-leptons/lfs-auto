#!/bin/bash

# using     : enter chroot environemnt and transfer control to bash
# author    : kevin.leptons@gmail.com

# use configuration
# use util
source configuration.sh
source util.sh

# define variables
task_name="chroot"

# log start
log "$task_name.start" true

# create directories onto which the file system will be mounted
mkdir -pv $LFS/{dev,proc,sys,run}
log_auto "fs-directory.create" $?

# create initial device nodes
if [ -e "$LFS/dev/console" ]; then
    log_auto "/dev/console.idle" 0
else
    sudo mknod -m 600 $LFS/dev/console c 5 1
    log_auto "/dev/console.create" $?
fi
if [ -e "$LFS/dev/null" ]; then
    log_auto "/dev/null.idle" 0
else
    sudo mknod -m 666 $LFS/dev/null c 1 3
    log_auto "/dev/null.create" $?
fi

# mount and populate /dev
sudo mount -v --bind /dev $LFS/dev
log_auto "/dev.populate" $?

# mount virtual kernel file system
if [ -e $LFS/dev/pts ]; then
    log_auto "/dev/pts.idle" 0
else
    sudo mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
fi
if [ -e $LFS/proc ]; then
    log_auto "/proc.idle" 0
else
    sudo mount -vt proc proc $LFS/proc
fi
if [ -e  $LFS/sys ]; then
    log_auto "/sys.idle" 0
else
    sudo mount -vt sysfs sysfs $LFS/sys
fi
if [ -e $LFS/run ]; then
    log_auto "/run/idle" 0
else
    sudo mount -vt tmpfs tmpfs $LFS/run
fi
if [ -h $LFS/dev/shm ]; then
   mkdir -pv $LFS/$(readlink $LFS/dev/shm)
fi
log_auto "virtual-kernel.mount" $?

# mount script into chroot
mkdir -vp $LFS/lfs-script &&
sudo mount -v --bind /lfs-script $LFS/lfs-script
log_auto "lfs-script.mount" $?

# enter the chroot environemnt
log_auto "chroot.start" 0
sudo chroot "$LFS" /tools/bin/env -i \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='\u:\w\$ '              \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
    /tools/bin/bash /lfs-script/config-chroot.sh --login +h
log_auto "chroot.finish" $?

# reenter the virtual kernel to get affected
log_auto "bash.start" 0
sudo chroot "$LFS" /tools/bin/env -i \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='\u:\w\$ '              \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
    /tools/bin/bash --login +h
log_auto "bash.finish" $?
