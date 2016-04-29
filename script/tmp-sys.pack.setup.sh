#!/bin/bash

# using     : wrap all build tools task
# author    : kevin.leptons@bmail.com

# libs
source configuration.sh
source util.sh

# variables
task_name="tmp-sys.package.setup"
build_temp_system_dir="tmp-sys.pack.setup"

step_tmp_sys_pack_setup() {
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
    for package in ${tool_packages[@]}; do
        $build_temp_system_dir/$package.sh
    done
}

# run
run_step "$task_name" step_tmp_sys_pack_setup
