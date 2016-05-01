#!/bin/bash

# using     : setup file system from system has built
# params    : none
# return    : 0 on success, 1 on error
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# libs
source $script_dir/configuration.sh
source $script_dir/util.sh

# run with lfs user
# file system has own by root
# require root premision to run
require_root

# variables
task_name="dist.src.setup"

# step.dist-dir.mkdir
step_dist_dir_mkdir() {
    rm -rf $dist_src_dir
    mkdir -vp $dist_src_dir
    mkdir -vp "$root/sources/dist-build"
}

# step.src.cp
step_src_cp() {
    cp -vpr $root/{bin,boot,dev,etc,home,lib,lib64,media,mnt,opt} $dist_src_dir
    cp -vpr $root/{proc,root,run,sbin,srv,sys,tmp,usr,var} $dist_src_dir
}

# run
run_step "$task_name.dist-dir.mkdir" step_dist_dir_mkdir
run_step "$task_name.src.cp" step_src_cp
exit 0
