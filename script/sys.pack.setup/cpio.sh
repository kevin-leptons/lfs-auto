#!/bin/bash

# using     : build cpio
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
package_name="sys.cpio"
source_file="../cpio-2.12.tar.bz2"
source_dir="cpio-2.12"

# verify
step_verify() {
    [ -f $source_file ]
}

# extract
step_extract() {
    tar -xf $source_file
}

# configure
step_configure() {
    ./configure --prefix=/usr \
            --bindir=/bin \
            --enable-mt   \
            --with-rmt=/usr/libexec/rmt
}

# make
step_build() {
    make
    makeinfo --html            -o doc/html      doc/cpio.texi
    makeinfo --html --no-split -o doc/cpio.html doc/cpio.texi
    makeinfo --plaintext       -o doc/cpio.txt  doc/cpio.texi
}

# test
step_test() {
    make check
}

# install
step_install() {
    make install
    install -v -m755 -d /usr/share/doc/cpio-2.12/html
    install -v -m644    doc/html/* \
                        /usr/share/doc/cpio-2.12/html
    install -v -m644    doc/cpio.{html,txt} \
                        /usr/share/doc/cpio-2.12
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
