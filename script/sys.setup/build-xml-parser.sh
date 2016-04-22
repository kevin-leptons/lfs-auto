#!/bin/bash

# using     : build xml-parser
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
package_name="sys.xml-parser"
source_file="../XML-Parser-2.44.tar.gz"
source_dir="XML-Parser-2.44"

# step.verify
step_verify() {
    [ -f $source_file ]
}

# step.extract
step_extract() {
    tar -vxf $source_file
}

# step.prepare
step_prepare() {
    perl Makefile.PL
}

# step.build
step_build() {
    make
}

# step.test
step_test() {
    make test
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
run_step "$package_name.prepare" step_prepare
run_step "$package_name.build" step_build
run_step "$package_name.test" step_test
run_step "$package_name.install" step_install
exit 0
