#!/bin/bash

# using     : this script is an part of linux from scratch auto-build
#             section 2.2. preparing a new partition
#             prepare partition, file system for linux from scratch
#             assume that build partition early mount into docker in /mnt/lfs
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"

# libs
source $__dir__/configuration.sh
source $__dir__/util.sh

# variables
task_name="box.partition"

# start
log "$task_name.setup.start" 0

# create tools directory to build temporary system
mkdir -vp $root_tools
log "$root_tools.create" $?

# link tools directory to root
sudo ln -svnf $root_tools /tools
log "$root_tools.link" $?

# transfer partition own from root to build user
sudo chown $build_user_group:$build_user $root /tools
log "$root_tools.chown" $?

# create build directories
mkdir -vp $root_tmp_sources
mkdir -vp "$root_sources/system-build"
sudo chown $build_user_group:$build_user \
    $root_tmp_sources "$root_sources/system-build"
log "build-dir.mkdir" $?

# create index file
if [ ! -f $index_step_file ]; then
    touch $index_step_file
fi
chown $build_user_group:$build_user $index_step_file
log "$index_step_file.touch" $?

# /lfs-script/tmp.chown
chown lfs:lfs /lfs-script/tmp
log "/lfs-script/tmp.chown" $?

# /lfs-script/log.chown
chown lfs:lfs /log
log "/lfs-script/log.chown" $?

# successfully
log "$task_name.setup.finish" $?
exit 0
