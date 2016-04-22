#!/bin/bash

# using     : install bootscript in system
# author    : kevin.leptons@gmail.com

# locate location of this script
cd /lfs-script
__dir__="$(dirname "$0")"

# libs
source $__dir__/configuration.sh
source $__dir__/util.sh

# warning task is not implemented
log "bootscript.install.must-be-implement" 1
