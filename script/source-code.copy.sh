#!/bin/bash

# using     : copy lfs source code from /lfs/sources
#             source code is early put in /lfs/sources
# author    : kevin.leptons@gmail.com

# libs
source configuration.sh
source util.sh

# variables
task_name="sources"

# log start
log "$task_name.copy.start" 0

# copy sources from /sources to /mnt/lfs/sources
mkdir -vp $root_sources
cp -vpn /lfs/sources/* $root_sources

# successfully
log "$task_name.copy.finish" $?
exit 0
