#!/bin/bash

# using     : clear build directories
# author    : kevin.leptons@gmail.com

# libs
source configuration.sh
source util.sh

# remove build directories
sudo rm -rf /mnt/lfs/sources/tmp-build
sudo rm -rf /mnt/lfs/sources/system-build
mkdir -vp /mnt/lfs/sources/tmp-build
mkdir -vp /mnt/lfs/sources/system-build
