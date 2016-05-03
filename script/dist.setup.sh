#!/bin/bash

# using     : pack system into an image
# params    : list of distribution to build
# author    : kevin.leptons@gmail.com

# bash options
set -e

# libs
source configuration.sh
source util.sh

# variables
task_name="dist"
dist_setup_dir="dist.setup"
dist_list="$@"

# dist.emtpy
if [[ dist_list == "" ]]; then
    (>&2 echo "distribution list is not specify")
    exit 1
fi

# dist.ghost
if in_array dist_list[@] ghost; then
    $dist_setup_dir/dist.ghost.setup.sh
fi

# dist.live
if in_array dist_list[@] live; then
    $dist_setup_dir/dist.live.setup.sh
fi

# run
exit $?
