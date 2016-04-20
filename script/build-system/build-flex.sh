#!/bin/bash

# using     : build flex
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
package_name="sys.flex"
source_file="../flex-2.5.39.tar.xz"
source_dir="flex-2.5.39"

# step.verify
step_verify() {
    [ -f $source_file ]
}

# step.extract
step_extract() {
    tar -vxf $source_file
}

# step.regression-tests.skip
step_regression_test_skip() {
    sed -i -e '/test-bison/d' tests/Makefile.in
}

# step.configure
step_configure() {
    ./configure --prefix=/usr --docdir=/usr/share/doc/flex-2.5.39
}

# step.build
step_build() {
    make
}

# step.test
step_test() {
    make check
}

# step.install
step_install() {
    make install
}

# step.link
step_link() {
    ln -sv flex /usr/bin/lex
}

# run
cd $root_system_sources
run_step "$package_name" step_verify
run_step "$package_name.extract" step_extract
cd $source_dir
run_step "$package_name.regression-tests.skip" step_regression_test_skip
run_step "$package_name.configure" step_configure
run_step "$package_name.build" step_build
run_step "$package_name.test" step_test
run_step "$package_name.install" step_install
run_step "$package_name.link" step_link
exit 0
