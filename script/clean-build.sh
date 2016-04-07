#!/bin/bash

# using     : clean build file system
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
build_temp_system_dir=$__dir__/build-temp-system

# use configuration
source configuration.sh

# require root permision
# root permision require for some file system operations
$__dir__/require-root.sh
if [[ $? != 0 ]]; then
    exit 1
fi

for directory in $root_sources/*/; do
    sudo rm -vrf $directory
done
