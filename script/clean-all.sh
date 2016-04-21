#!/bin/bash

# using     : clean all build file system
# warning   : run this script in lfs user
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"

# libs
source configuration.sh
source util.sh

# clean /tools
sudo rm -rf /mnt/lfs/tools/*

# clean system
./clean-system.sh

# clean build
sudo rm -rf /mnt/lfs/sources/tmp-build
sudo rm -rf /mnt/lfs/sources/system-build
