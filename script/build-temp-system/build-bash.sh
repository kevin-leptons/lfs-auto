#!/bin/bash

# using     : build bash
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
package_name="bash"
source_file="../bash-4.3.30.tar.gz"
source_dir="bash-4.3.30"

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
    ./configure --prefix=/tools --without-bash-malloc
}

# step.build
step_build() {
    make
}

# step.test
step_test() {
    make tests
}

# step.install
step_install() {
    make install
}

# step.link
step_link() {
    ln -sv bash /tools/bin/s
}

# run
cd $root_tmp_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
cd $source_dir
run_step "$package_name.configure" step_configure
run_step "$package_name.build" step_build
run_step "$package_name.test" step_test
run_step "$package_name.install" step_install
run_step "$package_name.link" step_link
exit 0
