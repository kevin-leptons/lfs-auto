#!/bin/bash

# using     : clean file system of setup system
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"

# use configuration
# use util
source configuration.sh
source util.sh

# clean all directory in sources directory
# it is old build
for directory in /sources/*/; do
    rm -vrf $directory
done
log "system.old-build.clean" $?

# successfully
exit 0
