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
task_name="buil-temp-system"

# log start build temp system
log_build "$task_name.start" true

# clean source code and old build
# to avoid error if old build is exists
$__dir__/clean-build.sh
if [[ $? != 0 ]]; then
    log_build "$task_name.clean-build" false
    exit 1
else
    log_build "$task_name.clean-build" true
fi

# clean installed tools
# to avoid error when use wrong tools link from /tools
# and change ownership to lfs
./clean-tmp-system.sh

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
    $build_temp_system_dir/$package.sh
    if [[ $? != 0 ]]; then
        result=error
        break
    fi
done
if [[ $result == error ]]; then
    log_build "$task_name.finish" false
else
    log_build "$task_name.finish" true
fi
