#!/bin/bash

# using     : clean file system of setup system
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"

# use configuration
source configuration.sh

for directory in /sources/*/; do
    rm -vrf $directory
done
