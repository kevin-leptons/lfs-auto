#!/bin/bash

# using     : this script is an part of linux from scratch auto-build
#             section 2.2. preparing a new partition
#             prepare partition, file system for linux from scratch
#             assume that build partition early mount into docker in /mnt/lfs
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"

# require root permision
$__dir__/require-root.sh

# use configuration
source $__dir__/configuration.sh

# prepare tool to build some packages
mkdir -vp $root_tools
ln -svnf $root_tools /tools

# transfer partition own from root to build user
chown -R $build_user_group:$build_user $root /tools
