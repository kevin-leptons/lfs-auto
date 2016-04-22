#!/bin/bash

# using     : clear build directories
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"

# libs
source configuration.sh
source util.sh

# remove
sudo rm -rf /mnt/lfs/sources/tmp-build
sudo rm -rf /mnt/lfs/sources/system-build
mkdir -vp /mnt/lfs/sources/tmp-build
mkdir -vp /mnt/lfs/sources/system-build
