#!/bin/bash

# using     : wrap all prepare work. make system ready to build
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"

# use util
source util.sh

# step 1. check host environment
./setup-host-environment.sh
exit_on_error

# step 3. copy sources
./copy-source-code.sh
exit_on_error

# step 4. build programm as tools what use to build when enter lfs root
./build-tools.sh
exit_on_error

# clean old system build before enter system build environment
./clean-build-system.sh
exit_on_error

# step 5. build system
./enter-chroot.sh
exit_on_error

# step 6. install boot loader
# ./install-boot-loader.sh
# exit_on_error
