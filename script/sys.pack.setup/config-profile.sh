#!/bin/bash

# using     : configure profile
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# create /etc/profile
cat > /etc/profile << "EOF"
# Begin /etc/profile

export LANG=en_US.UTF-8

# End /etc/profile
EOF
