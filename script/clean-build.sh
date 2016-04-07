#!/bin/bash

# using     : clean build file system
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"

# use configuration
source configuration.sh

for directory in $root_sources/*/; do
    sudo rm -vrf $directory
done
