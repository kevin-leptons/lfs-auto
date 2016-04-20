#!/bin/bash

# using     : build gcc
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
package_name="sys.gcc"
source_file="../gcc-5.2.0.tar.bz2"
source_dir="gcc-5.2.0"
build_dir="gcc-build"
test_log_file="/lfs-script/log/gcc.test.log"
compile_log_file="/lfs-script/log/compile.log"
simple_program_source="/lfs-script/asset/simple-program.c"
simple_program_dest="/lfs-script/tmp/simple-program"

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
    mkdir -vp $build_dir
}

# step.configure
step_configure() {
    SED=sed                       \
    ../gcc-5.2.0/configure        \
       --prefix=/usr            \
       --enable-languages=c,c++ \
       --disable-multilib       \
       --disable-bootstrap      \
       --with-system-zlib
}

# step.build
step_build() {
    make
}

# step.test
step_test() {
    ulimit -s 32768
    make -k check
    ../gcc-5.2.0/contrib/test_summary > $test_log_file
}

# step.install
step_install() {
    make install
}

# step.link
step_link() {
    ln -sv ../usr/bin/cpp /lib &&
    ln -sv gcc /usr/bin/cc &&
    install -v -dm755 /usr/lib/bfd-plugins &&
    ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/5.2.0/liblto_plugin.so \
        /usr/lib/bfd-plugins/
}

# step.cc.compile
step_cc_compile() {
    cc $simple_program_source -o $simple_program_dest \
        -v -Wl,--verbose &> $compile_log_file
    readelf -l $simple_program_dest | grep ': /lib' | \
        grep "Requesting program interpreter"
}

# step./usr/lib/.verify
step_usr_lib_verify() {
    lib_count=$(grep -o '/usr/lib.*/crt[1in].*succeeded' $compile_log_file \
        | wc -l)
    if [[ $lib_count == 3 ]]; then
        return 0
    else
        return 1
    fi
}

# step./usr/include/.verify
step_usr_include_verify() {
    grep -B4 '^ /usr/include' $compile_log_file
}

# step./usr/lib/.verify
step_linker_verify() {
    grep 'SEARCH.*/usr/lib' $compile_log_file |sed 's|; |\n|g'
}

# step./lib/.verify
step_lib_verify() {
    grep "/lib.*/libc.so.6 " $compile_log_file
}

# step.64bits.verify
step_64bits_verify() {
    grep found $compile_log_file
}

# step.misplaced-file.install
step_misplaced_file_install() {
    mkdir -pv /usr/share/gdb/auto-load/usr/lib &&
    mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib
}

# run
cd $root_system_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
run_step "$package_name.build-dir.mkdir" step_build_dir_mkdir
cd $build_dir
run_step "$package_name.configure" step_configure
run_step "$package_name.make" step_build
run_step "$package_name.test" step_test
run_step "$package_name.install" step_install
run_step "$package_name.link" step_link
run_step "$package_name.cc.compile" step_cc_compile
run_step "$package_name./usr/lib/.verify" step_usr_lib_verify
run_step "$package_name./usr/include/.verify" step_usr_include_verify
run_step "$package.linker.verify" step_linker_verify
run_step "$package_name./lib/.verify" step_lib_verify
run_step "$package_name.64bits.verify" step_64bits_verify
rm -v $simple_program_dest $compile_log_file
run_step "$package_name.misplaced-file.install" step_misplaced_file_install
exit 0
