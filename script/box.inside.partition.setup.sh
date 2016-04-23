#!/bin/bash

# using     : this script is an part of linux from scratch auto-build
#             section 2.2. preparing a new partition
#             prepare partition, file system for linux from scratch
#             assume that build partition early mount into docker in /mnt/lfs
# author    : kevin.leptons@gmail.com

# libs
source configuration.sh
source util.sh

# exit on error
set -e

# create tools directory to build temporary system
mkdir -vp $root_tools

# link tools directory to root
sudo ln -svnf $root_tools /tools

# transfer partition own from root to build user
sudo chown $build_user_group:$build_user $root /tools

# create build directories
mkdir -vp $root_tmp_sources
mkdir -vp "$root_sources/system-build"
sudo chown $build_user_group:$build_user \
    $root_tmp_sources "$root_sources/system-build"
