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

# define variables
task_name="change ownership"

# change ownership
sudo chown -R root:root $LFS/tools
if [[ $? != 0 ]]; then
    log_build "$task_name" false
else
    log_build "$task_name" true
fi
