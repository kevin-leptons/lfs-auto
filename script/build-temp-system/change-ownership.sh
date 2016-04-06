#!/bin/bash

# using     : change ownership of temp system
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change ownership
sudo chown -R root:root $LFS/tools
