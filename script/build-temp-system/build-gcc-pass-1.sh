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
package_name="gcc-pass-1"
package_mpfr_name="mpfr"
package_gmp_name="gmp"
package_mpc_name="mpc"
source_file="gcc-5.2.0.tar.bz2"
source_dir="gcc-5.2.0"
build_dir="gcc-build"
mpfr_source_file="../mpfr-3.1.3.tar.xz"
gmp_source_file="../gmp-6.0.0a.tar.xz"
mpc_source_file="../mpc-1.0.3.tar.gz"
mpfr_source_dir="mpfr"
gmp_source_dir="gmp"
mpc_source_dir="mpc"

# step.gcc.verify
step_gcc_verify() {
    [ -f $source_file ]
    return $?
}

# step.gcc.extract
step_gcc_extract() {
    tar -vxf $source_file
    cd $source_dir
}

# step.mpfr.verify
step_mpfr_verify() {
    [ -f $mpfr_source_file ]
    return $?
}

# step.mpfr.extract
step_mpfr_extract() {
    tar -vxf $mpfr_source_file
    mv -v mpfr-3.1.3 $mpfr_source_dir
}

# step.gmp.verify
step_gmp_verify() {
    [ -f $gmp_source_file ]
    return $?
}

# step.gmp.extract
step_gmp_extract() {
    tar -vxf $gmp_source_file
    mv -v gmp-6.0.0 $gmp_source_dir
}

# step.mpc.verify
step_mpc_verify() {
    [ -f $mpc_source_file ]
    return $?
}

# step.mpc.extract
step_mpc_extract() {
    tar -vxf $mpc_source_file
    mv -v mpc-1.0.3 $mpc_source_dir
}

# step.gcc-linker.change
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
    return $?
}

# step.build-dir.mkdir
step_build_dir_mkdir() {
    cd ../
    mkdir -vp $build_dir
    cd $build_dir
}

# step.configure
step_configure() {
    ../gcc-5.2.0/configure                             \
        --target=$LFS_TGT                              \
        --prefix=/tools                                \
        --with-glibc-version=2.11                      \
        --with-sysroot=$LFS                            \
        --with-newlib                                  \
        --without-headers                              \
        --with-local-prefix=/tools                     \
        --with-native-system-header-dir=/tools/include \
        --disable-nls                                  \
        --disable-shared                               \
        --disable-multilib                             \
        --disable-decimal-float                        \
        --disable-threads                              \
        --disable-libatomic                            \
        --disable-libgomp                              \
        --disable-libquadmath                          \
        --disable-libssp                               \
        --disable-libvtv                               \
        --disable-libstdcxx                            \
        --enable-languages=c,c++
}

# step.build
step_build() {
    make
}

# step.install
step_install() {
    make install
}

# run
cd $root_sources
run_step "$package_name.verify" step_gcc_verify
run_step "$package_name.extract" step_gcc_extract
run_step "$package_mpfr_name.verify" step_mpfr_verify
run_step "$package_mpfr_name.extract" step_mpfr_extract
run_step "$package_gmp_name.verify" step_gmp_verify
run_step "$package_gmp_name.extract" step_gmp_extract
run_step "$package_mpc_name.verify" step_mpc_verify
run_step "$package_mpc_name.extract" step_mpc_extract
run_step "$package_name.linker.change" step_gcc_linker_change
run_step "$package_name.build-dir.mkdir" step_build_dir_mkdir
run_step "$package_name.configure" step_configure
run_step "$package_name.make" step_build
run_step "$package_name.install" step_install
exit 0
