#!/bin/bash

# using     : wrap all prepare work. make system ready to build
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"

# require root permision
$__dir__/require-root.sh

# redirect all data from stdout to /dev/null
exec > /dev/null

# step 1. check host environment
$__dir__/check-host-environment.sh

# step 2. create user to build
$__dir__/create-build-user.sh

# step 3. prepare ervery thing, make lfs ready to build
$__dir__/prepare.sh

# step 4. build programm as tools what use to build when enter lfs root
$__dir__/build-tools.sh

# step 5. build system
# $__dir__/build-system.sh

# step 6. install boot loader
# $__dir__/install-boot-loader.sh
