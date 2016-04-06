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

# change ownwer of /lfs-script/log
sudo chown lfs:lfs -R /lfs-script/log

# continue with bash with lfs user
sudo -u $build_user bash
