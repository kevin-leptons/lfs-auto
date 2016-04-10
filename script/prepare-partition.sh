#!/bin/bash

# using     : this script is an part of linux from scratch auto-build
#             section 2.2. preparing a new partition
#             prepare partition, file system for linux from scratch
#             assume that build partition early mount into docker in /mnt/lfs
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"

# use configuration
# use util
source $__dir__/configuration.sh
source $__dir__/util.sh

# define variables
task_name="partition"

# log start
log "$task_name.start"

# create tools directory to build temporary system
mkdir -vp $root_tools
if [[ $? != 0 ]]; then
    log "$root_tools.create" false
    exit 1
else
    log "$root_tools.create" true
fi

# link tools directory to root
sudo ln -svnf $root_tools /tools
if [[ $? != 0 ]]; then
    log "$root_tools.link-root" false
    exit 1
else
    log "$root_tools.link-root" true
fi

# transfer partition own from root to build user
sudo chown -R $build_user_group:$build_user $root /tools
if [[ $? != 0 ]]; then
    log "$root_tools.chown" false
    exit 1
else
    log "$root_tools.chown" true
fi

# successfully
log "$task_name.start"
exit 0
