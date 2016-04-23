#!/bin/bash

# using     : wrap all prepare work. make system ready to build
# author    : kevin.leptons@gmail.com

# use util
source util.sh

# step 3. copy sources
./source-code.copy.sh
exit_on_error

# step 4. build programm as tools what use to build when enter lfs root
./tmp-sys.pack.setup.sh
exit_on_error

# active tmp-sys
# inside of tmp-sys, continue setup sys
./tmp-sys.active.sh
exit_on_error

# enter sys
# continue sys.inside.setup
./sys.active.sh
