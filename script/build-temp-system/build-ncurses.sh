#!/bin/bash

# using     : build ncurses
# params    : none
# return    : 0 on successfull, 1 on error
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# libs
source $script_dir/configuration.sh
source $script_dir/util.sh

# variables
package_name="tmp.ncurses"
source_file="../ncurses-6.0.tar.gz"
source_dir="ncurses-6.0"

# step.verify
step_verify() {
    [ -f $source_file ]
}

# step.extract
step_extract() {
    tar -vxf $source_file
}

# step.configure.fix
step_prepare() {
        sed -i s/mawk// configure
}

# step.configure
step_configure() {
    ./configure --prefix=/tools \
                --with-shared   \
                --without-debug \
                --without-ada   \
                --enable-widec  \
                --enable-overwrite
}

# step.build
step_build() {
    make
}

# step.install
step_install() {
    make install
}

# run
cd $root_tmp_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
cd $source_dir
run_step "$package_name.configure.fix" step_prepare
run_step "$package_name.configure" step_configure
run_step "$package_name.build" step_build
run_step "$package_name.install" step_install
exit 0
