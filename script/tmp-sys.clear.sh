#!/bin/bash

# using     : clean /tools
# warning   : run this script in lfs user
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"

# use configuration
# use util
source configuration.sh
source util.sh

# clean installed tools
# to avoid error when use wrong tools link from /tools
log "/tools.rm.start" 0
sudo rm -rf $root_tools
mkdir -vp $root_tools
log "/tools.rm.finish" $?

# change ownership of /tools to lfs
sudo chown lfs:lfs $root_tools
log "/tools.chown" $?
