#!/bin/bash

# using     : build expat
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
package_name="sys.expat"
source_file="../expat-2.1.0.tar.gz"
source_dir="expat-2.1.0"

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
    ./configure --prefix=/usr --disable-static
}

# step.build
step_build() {
    make
}

# test
step_test() {
    make check
}

# step.install
step_install() {
    make install
}

# step.doc.install
step_doc_install() {
    install -v -dm755 /usr/share/doc/expat-2.1.0 &&
    install -v -m644 doc/*.{html,png,css} /usr/share/doc/expat-2.1.0
}

# run
cd $root_system_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
cd $source_dir
run_step "$package_name.configure" step_configure
run_step "$package_name.build" step_build
run_step "$package_name.test" step_test
run_step "$package_name" step_install
run_step "$package_name.doc.install" step_doc_install
exit 0
