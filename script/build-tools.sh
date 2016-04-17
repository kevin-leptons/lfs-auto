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

# clean source code and old build
# to avoid error if old build is exists
./clean-build.sh
exit_on_error

# clean installed tools
# to avoid error when use wrong tools link from /tools
# and change ownership to lfs
./clean-tmp-system.sh
exit_on_error

# list all script to build packages
# each script not contains extension
tool_packages=( \
    build-binutils-pass-1 \
    build-gcc-pass-1 \
    install-linux-api-header \
    build-glibc \
    build-libstdc++ \
    build-binutils-pass-2 \
    build-gcc-pass-2 \
    build-tcl-core \
    build-expect \
    build-dejagnu \
    build-check \
    build-ncurses \
    build-bash \
    build-bzip2 \
    build-coreutils \
    build-diffutils \
    build-file \
    build-findutils \
    build-gawk \
    build-gettext \
    build-grep \
    build-gzip \
    build-m4 \
    build-make \
    build-patch \
    build-perl \
    build-sed \
    build-tar \
    build-texinfo \
    build-util-linux \
    build-xz \
    change-ownership \
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
