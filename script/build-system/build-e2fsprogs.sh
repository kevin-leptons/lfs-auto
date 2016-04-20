#!/bin/bash

# using     : build e2fsprogs
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
package_name="sys.e2fsprogs"
source_file="../e2fsprogs-1.42.13.tar.gz"
source_dir="e2fsprogs-1.42.13"

# step.verify
step_verify() {
    [ -f $source_file ]
}

# step.extract
step_extract() {
    tar -vxf $source_file
}

# step.build-dir.mkdir
step_build_dir_mkdir() {
    mkdir -vp build
}

# step.configure
step_configure() {
    LIBS=-L/tools/lib                    \
    CFLAGS=-I/tools/include              \
    PKG_CONFIG_PATH=/tools/lib/pkgconfig \
    ../configure --prefix=/usr           \
       --bindir=/bin           \
       --with-root-prefix=""   \
       --enable-elf-shlibs     \
       --disable-libblkid      \
       --disable-libuuid       \
       --disable-uuidd         \
       --disable-fsck
}

# step.build
step_build() {
    make
}

# step.test
step_test() {
    ln -sfv /tools/lib/lib{blk,uu}id.so.1 lib &&
    make LD_LIBRARY_PATH=/tools/lib check
}

# step.install
step_install() {
    make install &&
    make install-libs &&
    chmod -v u+w /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a
}

# step.info.intall
step_info_install() {
    gunzip -v /usr/share/info/libext2fs.info.gz &&
    install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info
}

# step.doc.install
step_doc_install() {
    makeinfo -o      doc/com_err.info ../lib/et/com_err.texinfo &&
    install -v -m644 doc/com_err.info /usr/share/info &&
    install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info
}

# run
cd $root_system_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
cd $build_dir
run_step "$package_name.build-dir.mkdir" step_build_dir_mkdir
run_step "$package_name.configure" step_configure
run_step "$package_name.build" step_build
run_step "$package_name.test" step_test
run_step "$package_name.install" step_install
run_step "$package_name.info.install" step_info_install
run_step "$package_name.doc.install" step_doc_install
exit 0
