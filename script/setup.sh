#!/bin/bash

# using     : wrap all prepare work. make system ready to build
# author    : kevin.leptons@gmail.com

# use util
source util.sh

# put sources code into correct directory
./source-code.copy.sh
exit_on_error

# setup package of temporary system
./tmp-sys.pack.setup.sh
exit_on_error

# active temporary system
# inside of tmp-sys, continue setup system
./tmp-sys.active.sh
exit_on_error

# enter system
# continue setup system inside
./sys.active.sh
