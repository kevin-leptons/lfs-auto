#!/bin/bash

# using     : execute bashrc, and continue setup instructions
# user      : lfs is current user when execute this script
# author    : kevin.leptons@gmail.com

# execute bashrc
# and change to /lfs-script
source ~/.bashrc
cd /lfs-script

# call build instructions
./build.sh
