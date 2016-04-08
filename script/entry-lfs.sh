#!/bin/bash

# using     : prepare lfs user and partition
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"

# require root permision
$__dir__/require-root.sh

# use configuration
source $__dir__/configuration.sh

# call create user
$__dir__/create-build-user.sh

# call prepare partition
$__dir__/prepare-partition.sh

# create log directory
# change ownwer of /lfs-script/log
sudo mkdir -vp $__dir__/log
sudo chown lfs:lfs -R $__dir__/log

# change ownwership of /mnt/lfs
sudo chown lfs:lfs -R /mnt/lfs

# continue with bash with lfs user
sudo -u $build_user bash
