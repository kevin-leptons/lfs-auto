#!/bin/bash

# using     : build gcc package in pass 1
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
package_name="tmp.gcc-pass-2"
package_mpfr_name="mpfr"
package_gmp_name="gmp"
package_mpc_name="mpc"
source_file="../gcc-5.2.0.tar.bz2"
source_dir="gcc-pass-2"
build_dir="gcc-pass-2-build"
mpfr_source_file="../../mpfr-3.1.3.tar.xz"
gmp_source_file="../../gmp-6.0.0a.tar.xz"
mpc_source_file="../../mpc-1.0.3.tar.gz"
mpfr_source_dir="mpfr"
gmp_source_dir="gmp"
mpc_source_dir="mpc"
simple_program_source="/lfs-script/asset/simple-program.c"
simple_program_dest="/lfs-script/tmp/simple-program"

# step.gcc.verify
step_gcc_verify() {
    [ -f $source_file ]
}

# step.gcc.extract
step_gcc_extract() {
    tar -vxf $source_file
    mv "gcc-5.2.0" $source_dir
}

# step.limit-header.fix
step_limit_header_fix() {
    cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
       `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include-fixed/limits.h
}

# step.gcc.linker.change
step_gcc_linker_change() {
    for file in \
       $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
    do
       cp -uv $file{,.orig}
       sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
          -e 's@/usr@/tools@g' $file.orig > $file
       echo '
          #undef STANDARD_STARTFILE_PREFIX_1
          #undef STANDARD_STARTFILE_PREFIX_2
          #define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
          #define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
       touch $file.orig
    done
}

# step.mpfr.verify
step_mpfr_verify() {
    [ -f $mpfr_source_file ]
}

# step.mpfr.extract
step_mpfr_extract() {
    tar -vxf $mpfr_source_file
    mv -v "mpfr-3.1.3" $mpfr_source_dir
}

# step.gmp.verify
step_gmp_verify() {
    [ -f $gmp_source_file ]
}

# step.gmp.extract
step_gmp_extract() {
    tar -vxf $gmp_source_file
    mv -v "gmp-6.0.0" $gmp_source_dir
}

# step.mpc.verify
step_mpc_verify() {
    [ -f $mpc_source_file ]
}

# step.mpc.extract
step_mpc_extract() {
    tar -vxf $mpc_source_file
    mv -v "mpc-1.0.3" $mpc_source_dir
}

# step.build-dir.mkdir
step_build_dir_mkdir() {
    mkdir -vp $build_dir
}

# configure
step_configure() {
    CC=$LFS_TGT-gcc                                    \
    CXX=$LFS_TGT-g++                                   \
    AR=$LFS_TGT-ar                                     \
    RANLIB=$LFS_TGT-ranlib                             \
    ../$source_dir/configure                             \
        --prefix=/tools                                \
        --with-local-prefix=/tools                     \
        --with-native-system-header-dir=/tools/include \
        --enable-languages=c,c++                       \
        --disable-libstdcxx-pch                        \
        --disable-multilib                             \
        --disable-bootstrap                            \
        --disable-libgomp
}

# step.build
step_build() {
    make
}

# step.install
step_install() {
    make install
}

# link
step_link() {
    ln -sv gcc /tools/bin/cc
}

# test
step_test() {
    cc "$simple_program_source" -o "$simple_program_dest" &&
    readelf -l "$simple_program_dest" | grep ': /tools' | \
        grep "Requesting program interpreter"
}

# run
cd $root_tmp_sources
run_step "$package_name.verify" step_gcc_verify
run_step "$package_name.extract" step_gcc_extract
cd $source_dir
run_step "$package_name.limit-header.fix" step_limit_header_fix
run_step "$package_name.linker.change" step_gcc_linker_change
run_step "$package_name.$package_mpfr_name.verify" step_mpfr_verify
run_step "$package_name.$package_mpfr_name.extract" step_mpfr_extract
run_step "$package_name.$package_gmp_name.verify" step_gmp_verify
run_step "$package_name.$package_gmp_name.extract" step_gmp_extract
run_step "$package_name.$package_mpc_name.verify" step_mpc_verify
run_step "$package_name.$package_mpc_name.extract" step_mpc_extract
cd $root_tmp_sources
run_step "$package_name.build-dir.mkdir" step_build_dir_mkdir
cd $build_dir
run_step "$package_name.configure" step_configure
run_step "$package_name.build" step_build
run_step "$package_name.install" step_install
run_step "$package_name.link" step_link
run_step "$package_name.test" step_test
exit 0
