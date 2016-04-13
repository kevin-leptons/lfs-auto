#!/bin/bash

# using     : change ownership of temp system
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
# use util
source $script_dir/configuration.sh
source $script_dir/util.sh

# change ownership
sudo chown -R root:root $LFS/tools
log_auto "/tools.chown" $?
