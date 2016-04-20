#!/bin/bash

# using     : build attr
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
package_name="sys.attr"
source_file="../attr-2.4.47.src.tar.gz"
source_dir="attr-2.4.47"

# step.verify
step_verify() {
    [ -f $source_file ]
}

# step.extract
step_extract() {
    tar -vxf $source_file
}

# step.doc.modify
step_doc_modify() {
    sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in &&
    sed -i -e "/SUBDIRS/s|man2||" man/Makefile
}

# step.configure
step_configure() {
    ./configure --prefix=/usr \
       --bindir=/bin \
       --disable-static
}

# step.build
step_build() {
    make
}

# step.test
step_test() {
    make -j1 tests root-tests
}

# step.install
step_install() {
    make install install-dev install-lib &&
    chmod -v 755 /usr/lib/libattr.so
}

# step.libattr.so.mv
step_libattr_so_mv() {
    mv -v /usr/lib/libattr.so.* /lib &&
    ln -sfv ../../lib/$(readlink /usr/lib/libattr.so) /usr/lib/libattr.so
}

# run
cd $root_system_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
cd $source_dir
run_step "$package_name.doc.modify" step_doc_modify
run_step "$package_name.configure" step_configure
run_step "$package_name.build" step_build
run_step "$package_name.test" step_test
run_step "$package_name.install" step_install
run_step "$package.libattr.so.mv" step_libattr_so_mv
exit 0
