#!/bin/bash

# using     : clean file system of new system
# warning   : run this script in lfs user
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"

# use configuration
# use util
source configuration.sh
source util.sh

# remove file system of new system
cd $root &&
rm -vrf bin \
    boot \
    dev \
    etc \
    home \
    lib \
    lib64 \
    media \
    opt \
    proc \
    root \
    run \
    sbin \
    srv \
    sys \
    tmp \
    usr \
    var
log_auto "system.clear" $?

# successfully
exit 0
