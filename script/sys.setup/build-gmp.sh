#!/bin/bash

# using     : build gmp
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
package_name="sys.gmp"
source_file="../gmp-6.0.0a.tar.xz"
source_dir="gmp-6.0.0"

# step.verify
step_verify() {
    [ -f $source_file ]
}

# step.extract
step_extract() {
    tar -vxf $source_file
}

# step.configure
step_configure() {
    ./configure --prefix=/usr    \
       --enable-cxx     \
       --disable-static \
       --docdir=/usr/share/doc/gmp-6.0.0a
}

# step.build
step_build() {
    make &&
    make html
}

# step.test
step_test() {
    make check 2>&1 | tee gmp-check-log &&
    awk '/tests passed/{total+=$2} ; END{print total}' gmp-check-log
}

# step.install
step_install() {
    make install &&
    make install-html
}

# run
cd $root_system_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
cd $source_dir
run_step "$package_name.configure" step_configure
run_step "$package_name.make" step_build
run_step "$package_name.test" step_test
run_step "$package_name.install" step_install
exit 0
