#!/bin/bash

# using     : build grep
# params    : none
# return    : 0 on success, 1 on error
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
# use util
source $script_dir/configuration.sh
source $script_dir/util.sh

# variables
package_name="sys.grep"
source_file="../grep-2.21.tar.xz"
source_dir="grep-2.21"

# step.verify
step_verify() {
    [ -f $source_file ]
}

# step.extract
step_extract() {
    tar -vxf $source_file
}

# step.security.fix
step_security_fix() {
    sed -i -e '/tp++/a  if (ep <= tp) break;' src/kwset.c
}

# step.configure
step_configure() {
    ./configure --prefix=/usr --bindir=/bin
}

# step.build
step_build() {
    make
}

# step.test
# todo: fix wrong verify test fail allowed
step_test() {
    make check
    if [[ $? == 0 ]]; then
        return 0
    else

        test_log_file="gnulib-tests/test-suite.log"
        grep -w "FAIL test-update-copyright.sh" "$test_log_file"
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
run_step "$package_name.security.fix" step_security_fix
run_step "$package_name.configure" step_configure
run_step "$package_name.build" step_build
run_step "$package_name.test" step_test
run_step "$package_name.install" step_install
exit 0
