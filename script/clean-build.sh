#!/bin/bash

# using     : clean build file system
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"

# use configuration
# use script
source configuration.sh
source util.sh

log_auto "/sources.build-fs.rm.start" 0

# remove all directory in sources directory
# that is build directory
for directory in $root_sources/*/; do
    sudo rm -vrf $directory
done

log_auto "/sources.build-fs.rm.finish" $?

# successfully
exit 0
