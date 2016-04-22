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
log "$task_name.start" 0

# create directories onto which the file system will be mounted
sudo mkdir -pv $LFS/{dev,proc,sys,run}
log "fs-directory.create" $?

# create initial device nodes
sudo mknod -m 600 $LFS/dev/console c 5 1
sudo mknod -m 666 $LFS/dev/null c 1 3
log "dev-node.create" 0

# mount and populate /dev
sudo mount -v --bind /dev $LFS/dev
log "/dev.mount" $?

# mount virtual kernel file system
sudo mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
sudo mount -vt proc proc $LFS/proc
sudo mount -vt sysfs sysfs $LFS/sys
sudo mount -vt tmpfs tmpfs $LFS/run
if [ -h $LFS/dev/shm ]; then
   sudo mkdir -pv $LFS/$(readlink $LFS/dev/shm)
fi
log "virtual-kernel.mount" $?

# mount script into chroot
mkdir -vp $LFS/lfs-script &&
sudo mount -v --bind /lfs-script $LFS/lfs-script
log "lfs-script.mount" $?

# enter the chroot environemnt
log "chroot.start" 0
echo "\$LFS=$LFS"
sudo chroot "$LFS" /tools/bin/env -i \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='\u:\w\$ '              \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
    /tools/bin/bash /lfs-script/config-chroot.sh "$1" --login +h
log "chroot.finish" $?
