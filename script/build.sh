#!/bin/bash

# using     : wrap all prepare work. make system ready to build
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"

# step 1. check host environment
$__dir__/setup-host-environment.sh

# step 3. copy sources
$__dir__/copy-source-code.sh

# step 4. build programm as tools what use to build when enter lfs root
$__dir__/build-tools.sh

# step 5. build system
$__dir__/clean-build-system.sh
$__dir__/enter-chroot.sh

# step 6. install boot loader
# $__dir__/install-boot-loader.sh
