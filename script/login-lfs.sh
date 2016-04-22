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

    # use bash
    "host" )
        echo "lfs.enter ok"
        source ~/.profile
        bash;;

    # use virtual-kernel.temporary-system
    "tsys" ) bash "enter-chroot.sh" "bash";;

    # use virtual-kernel.system
    "sys" ) bash "enter-system.sh" "bash";;

    # setup
    * ) bash "./build.sh";;
esac
