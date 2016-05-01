#!/bin/bash

# using     : wrap all prepare work. make system ready to build
# author    : kevin.leptons@gmail.com

# bash options
set -e

# use util
source util.sh

# put sources code into correct directory
./source-code.copy.sh

# setup package of temporary system
./tmp-sys.pack.setup.sh

# active temporary system
# inside of tmp-sys, continue setup system
./tmp-sys.active.sh

# enter system
# continue setup system inside
./sys.active.sh

# install-image.create
# install boot loader
./dist.setup.sh
