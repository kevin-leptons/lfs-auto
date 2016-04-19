#!/bin/bash

# using     : build tcl-core
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
package_name="tcl-core"
source_file="tcl-core8.6.4-src.tar.gz"
source_dir="tcl8.6.4"

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
    cd unix
    ./configure --prefix=/tools
}

# step.build
step_make() {
    make
}

# step.test
step_test() {
    TZ=UTC make test
}

# step.install
step_install() {
    make install
}
run_step "$package_name.install" step_install

# step.libtcl.chmod
step_libtcl_chmod() {
    chmod -v u+x /tools/lib/libtcl8.6.so
}

# step.tcl-headers.install
step_tcl_headers_install() {
    make install-private-headers
}

# step.link
step_link() {
    ln -sv tclsh8.6 /tools/bin/tclsh
}

# run
cd $root_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
cd $source_dir
run_step "$package_name.configure" step_configure
run_step "$package_name.build" step_make
run_step "$package_name.test" step_test
run_step "/tools/lib/libtcl8.6.so.chmod" step_libtcl_chmod
run_step "$package_name.header.install" step_tcl_headers_install
run_step "$package_name.link" step_link
exit 0
