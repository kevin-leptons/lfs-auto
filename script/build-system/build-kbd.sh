#!/bin/bash

# using     : build kbd
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
package_name="sys.kbd"
source_file="../kbd-2.0.3.tar.xz"
source_dir="kbd-2.0.3"

# step.verify
step_verify() {
    [ -f $source_file ]
}

# step.extract
step_extract() {
    tar -vxf $source_file
}

# step.patch
step_patch() {
    patch -Np1 -i ../kbd-2.0.3-backspace-1.patch
}

# step.redundant.remove
step_redundant_remove() {
    sed -i 's/\(RESIZECONS_PROGS=\)yes/\1no/g' configure &&
    sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in
}

# step.configure
step_configure() {
    PKG_CONFIG_PATH=/tools/lib/pkgconfig ./configure \
       --prefix=/usr --disable-vlock
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

# step.doc.install
step_doc_install() {
    mkdir -v       /usr/share/doc/kbd-2.0.3 &&
    cp -R -v docs/doc/* /usr/share/doc/kbd-2.0.3
}

# run
cd $root_system_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
cd $source_dir
run_step "$package_name.patch" step_patch
run_step "$package_name.redundant.remove" step_redundant_remove
run_step "$package_name.configure" step_configure
run_step "$package_name.build" step_build
run_step "$package_name.test" step_test
run_step "$package_name.install" step_install
run_step "$package_name.doc.install" step_doc_install
exit 0
