#!/bin/bash

# using     : wrap all build tools task
# author    : kevin.leptons@bmail.com

# locate location of this script
__dir__="$(dirname "$0")"
build_temp_system_dir=$__dir__/build-temp-system

# use configuration
# use util
source $__dir__/configuration.sh
source $__dir__/util.sh

# define variables
task_name="temp-system"

# log start build temp system
log "$task_name.setup.start" 0

# clean installed tools
# to avoid error when use wrong tools link from /tools
# and change ownership to lfs
# ./clean-tmp-system.sh
# exit_on_error

# list all script to build packages
# each script not contains extension
tool_packages=( \
    001.binutils-pass-1 \
    002.gcc-pass-1 \
    003.linux-api-headers \
    004.glibc \
    005.libstdc++ \
    006.binutils-pass-2 \
    007.gcc-pass-2 \
    008.tcl-core \
    009.expect \
    010.dejagnu \
    011.check \
    012.ncurses \
    013.bash \
    014.bzip2 \
    015.coreutils \
    016.diffutils \
    017.file \
    018.findutils \
    019.gawk \
    020.gettext \
    021.grep \
    022.gzip \
    023.m4 \
    024.make \
    025.patch \
    026.perl \
    027.sed \
    028.tar \
    029.texinfo \
    030.util-linux \
    031.xz \
    032.ownership \
)

# build each package
# log is generate by internal build script
result=done
for package in ${tool_packages[@]}; do

    # call setup script
    $build_temp_system_dir/$package.sh
    exit_on_error

done

# successfully
log "$task_name.setup.finish" $?
exit 0
