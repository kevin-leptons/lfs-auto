#!/bin/bash

# using     : clean build processing
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"

# remove extra file
rm -rf /tmp/*

# reentering without tools and remove static library
sudo chroot "$LFS" /usr/bin/env -i              \
   HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
   PATH=/bin:/usr/bin:/sbin:/usr/sbin     \
   /bin/bash /lfs-script/build-system/remove-static-lib.sh --login


