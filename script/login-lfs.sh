#!/bin/bash

# using     : execute bashrc, and continue setup instructions
# user      : lfs is current user when execute this script
# author    : kevin.leptons@gmail.com

# execute bashrc
# and change to /lfs-script
source ~/.bashrc
cd /lfs-script

# prepare handle error
build_output="log/out.log"
set -e
dump_output() {
    echo "last 500 line of stdout"
    tail -500 $build_output
}
error_handle() {
    echo "error"
    dump_output
    exit 1
}

# start keep live task
# when error, terminal process
# trap "error_handle" ERR
# bash travis-keep-build-live.sh &
# keep_live_id=$!

# call build instructions
./build.sh

# # exit
# kill $keep_live_id
# dump_output
# exit 0
