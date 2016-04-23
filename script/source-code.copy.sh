#!/bin/bash

# using     : copy lfs source code from /lfs/sources
#             require
#              - ./prepare-partition.sh run successfully
#              - wget-list.txt put int same directory with this script
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"

# use configuration
# use util
source $__dir__/configuration.sh
source $__dir__/util.sh

# define variables
task_name="lfs-source"

# log start
log "$task_name.copy.start" 0

# copy sources from /sources to /mnt/lfs/sources
mkdir -vp /mnt/lfs/sources
cp -vpn /lfs/sources/* /mnt/lfs/sources

# successfully
log "$task_name.copy.finish" $?
exit 0
