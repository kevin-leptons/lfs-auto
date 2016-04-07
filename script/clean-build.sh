#!/bin/bash

# using     : clean build file system
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
build_temp_system_dir=$__dir__/build-temp-system

# use configuration
source configuration.sh

for directory in $root_sources/*/; do
    rm -vrf $directory
done
