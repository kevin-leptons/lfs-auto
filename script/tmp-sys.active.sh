#!/bin/bash

# using     : active temporary-system, this is part of tmp-sys.setup
#             active tmp-sys and call inside setup
# author    : kevin.leptons@gmail.com

# libs
source configuration.sh
source util.sh

# variables
task_name="tmp-sys.inside"

# start
log "$task_name.setup.start" 0

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
# transfer control to tmp-sys.entry.sh
log "chroot.start" 0
sudo chroot "$LFS" /tools/bin/env -i \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='\u:\W\$ '              \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
    /tools/bin/bash /lfs-script/tmp-sys.entry.sh "$1" --login +h
log "chroot.finish" $?
