#!/bin/bash

# using     : wrap all build tools task
# author    : kevin.leptons@bmail.com

# locate location of this script
__dir__="$(dirname "$0")"
build_temp_system_dir=$__dir__/tmp-sys.setup

# use configuration
# use util
source $__dir__/configuration.sh
source $__dir__/util.sh

# define variables
task_name="tmp-sys"

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
    binutils-pass-1 \
    gcc-pass-1 \
    linux-api-headers \
    glibc \
    libstdc++ \
    binutils-pass-2 \
    gcc-pass-2 \
    tcl-core \
    expect \
    dejagnu \
    check \
    ncurses \
    bash \
    bzip2 \
    coreutils \
    diffutils \
    file \
    findutils \
    gawk \
    gettext \
    grep \
    gzip \
    m4 \
    make \
    patch \
    perl \
    sed \
    tar \
    texinfo \
    util-linux \
    xz \
    ownership \
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
