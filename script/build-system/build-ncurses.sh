#!/bin/bash

# using     : build ncurses
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
package_name="sys.ncurses"
source_file="../ncurses-6.0.tar.gz"
source_dir="ncurses-6.0"

# step.verify
step_verify() {
    [ -f $source_file ]
}

# step.extract
step_extract() {
    tar -vxf $source_file
}

# step.static-lib.disable
step_static_lib_disable() {
    sed -i '/LIBTOOL_INSTALL/d' c++/Makefile.in
}

# step.configure
step_configure() {
    ./configure --prefix=/usr           \
       --mandir=/usr/share/man \
       --with-shared           \
       --without-debug         \
       --without-normal        \
       --enable-pc-files       \
       --enable-widec
}

# step.build
step_build() {
    make
}

# step.install
step_install() {
    make install
}

# step.lib.move
step_lib_move() {
    mv -v /usr/lib/libncursesw.so.6* /lib
}

# step.link
step_link() {
    ln -sfv ../../lib/$(readlink /usr/lib/libncursesw.so) \
        /usr/lib/libncursesw.so &&

    for lib in ncurses form panel menu ; do
       rm -vf                    /usr/lib/lib${lib}.so
       echo "INPUT(-l${lib}w)" > /usr/lib/lib${lib}.so
       ln -sfv ${lib}w.pc        /usr/lib/pkgconfig/${lib}.pc
    done

    rm -vf                     /usr/lib/libcursesw.so &&
    echo "INPUT(-lncursesw)" > /usr/lib/libcursesw.so &&
    ln -sfv libncurses.so      /usr/lib/libcurses.so
}

# step.doc.install
step_doc_install() {
    mkdir -v       /usr/share/doc/ncurses-6.0 &&
    cp -v -R doc/* /usr/share/doc/ncurses-6.0
}

# run
cd $root_system_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
cd $source_dir
run_step "$package_name.static-lib.disable" step_static_lib_disable
run_step "$package_name.configure" step_configure
run_step "$package_name.build" step_build
run_step "$package_name.install" step_install
run_step "$package_name.lib.move" step_lib_move
run_step "$package_name.link" step_link
run_step "$package_name.doc.install" step_doc_install
exit 0
