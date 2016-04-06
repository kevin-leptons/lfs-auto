#!/bin/bash

# using     : this script is an part of linux from scratch auto-build
#             section 2.2. preparing a new partition
#             prepare partition, file system for linux from scratch
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"

# require root permision
source $__dir__/script/require-root.sh

# use configuration
source $__dir__/script/configuration.sh

# check disk device
partition_ok=true
if [ -b $partition_dev ]; then
    echo "disk device '$partition_dev': ok"
else
    partition_ok=false
    echo "disk device '$partition_dev': bad - not exist"
fi

# total result
if [ $partition_ok == true ]; then
    echo "ready: ok"
else
    echo "ready: no"
    exit 1
fi

# create mount point
mkdir -pv $root

# mount disk device
if ! grep -qa $root /proc/mounts; then
    mount -v $partition_dev $root
fi

## prepare tool to build some packages
#mkdir -vp $root_tools
#ln -svnf $root_tools /tools
#
## transfer partition own from root to build user
#chown -R $build_user_group:$build_user $root /tools
