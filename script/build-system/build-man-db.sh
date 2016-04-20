#!/bin/bash

# using     : build man-db
# params    : none
# return    : 0 on success, 1 on error
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# libs
source $script_dir/configuration.sh
source $script_dir/util.sh

# variables
package_name="sys.man-db"
source_file="../man-db-2.7.2.tar.xz"
source_dir="man-db-2.7.2"

# step.verify
step_verify()) {
    [ -f $source_file ]
}

# step.extract
step_extract() {
    tar -vxf $source_file
}

# setp.configure
step_configure() {
    ./configure --prefix=/usr                        \
       --docdir=/usr/share/doc/man-db-2.7.2 \
       --sysconfdir=/etc                    \
       --disable-setuid                     \
       --with-browser=/usr/bin/lynx         \
       --with-vgrind=/usr/bin/vgrind        \
       --with-grap=/usr/bin/grap
}

# step.build
step_build() {
    make
}

# step.test
step_test() {
    make check
}

# install
step_install() {
    make install
}

# run
cd $root_system_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
cd $source_dir
run_step "$package_name.configure" step_configure
run_step "$package_name.build" step_build
run_step "$package_name.test" step_test
run_step "$package_name.install" step_install
exit 0
