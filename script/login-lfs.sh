#!/bin/bash

# using     : execute bashrc, and continue setup instructions
# user      : lfs is current user when execute this script
# author    : kevin.leptons@gmail.com

# execute bashrc
# and change to /lfs-script
source ~/.bashrc
cd /lfs-script

# active script depend on params
case "$1" in
    "bash" )
        echo "lfs.enter ok"
        source ~/.profile
        bash;;
    "vkernel" ) bash "enter-chroot.sh" "bash";;
    * ) bash "./build.sh";;
esac
