#!/bin/bash

# using     : prepare build system
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"

# use configuration
source $__dir__/configuration.sh

# create directories onto which the systems will be mounted
mkdir -pv $LFS/{dev,proc,sys,run}

# create initial device nodes
sudo mknod -m 600 $LFS/dev/console c 5 1
sudo mknod -m 666 $LFS/dev/null c 1 3

# mount and populate /dev
sudo mount -v --bind /dev $LFS/dev

# mount virutal kernel file system
sudo mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
sudo mount -vt proc proc $LFS/proc
sudo mount -vt sysfs sysfs $LFS/sys
sudo mount -vt tmpfs tmpfs $LFS/run
if [ -h $LFS/dev/shm ]; then
   sudo mkdir -pv $LFS/$(readlink $LFS/dev/shm)
fi

# mount script into chroot
mkdir -vp $LFS/lfs-script
sudo mount -v --bind /lfs-script $LFS/lfs-script

# enter chroot environment
sudo chroot "$LFS" /tools/bin/env -i \
       HOME=/root                  \
       TERM="$TERM"                \
       PS1='\u:\w\$ '              \
       PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
       /tools/bin/bash /lfs-script/entry-chroot.sh \
       --login +h

