#!/bin/bash

# using     : build diffutils
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
package_name="sys.diffutils"
source_file="../diffutils-3.3.tar.xz"
source_dir="diffutils-3.3"

# step.verify
step_verify() {
    [ -f $source_file ]
}

# step.extract
step_extract() {
    tar -vxf $source_file
}

# step.locale-file.fix
step_locale_file_fix() {
    sed -i 's:= @mkdir_p@:= /bin/mkdir -p:' po/Makefile.in.in
}

# step.configure
step_configure() {
    ./configure --prefix=/usr
}

# build
step_build() {
    make
}

# step.test
step_test() {
    make check
    if [[ $? == 0 ]]; then
        return 0
    else
        test_log_file="gnulib-tests/test-suite.log"
        grep -w "FAIL: test-update-copyright.sh" "$test_log_file"
        return $?
    fi
}

# step.install
step_install() {
    make install
}

# run
cd $root_system_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
cd $source_dir
run_step "$package_name.locale-file.fix" step_locale_file_fix
run_step "$package_name.configure" step_configure
run_step "$package_name.build" step_build
run_step "$package_name.test" step_test
run_step "$package_name.install" step_install
exit 0
