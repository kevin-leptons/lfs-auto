#!/bin/bash

# using     : build gcc package in pass 1
# time      : 8.5 sbu
# params    : none
# return    : 0 on successfull, 1 on error
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
# use util
source $script_dir/configuration.sh
source $script_dir/util.sh

# change working directory to sources directory
cd $root_sources

# define variables
package_name=gcc-pass-1
package_mpfr_name=mpfr
package_gmp_name=gmp
package_mpc_name=mpc
source_file=gcc-5.2.0.tar.bz2
source_dir=gcc-5.2.0
build_dir=gcc-build
mpfr_source_file=../mpfr-3.1.3.tar.xz
gmp_source_file=../gmp-6.0.0a.tar.xz
mpc_source_file=../mpc-1.0.3.tar.gz
mpfr_source_dir=mpfr
gmp_source_dir=gmp
mpc_source_dir=mpc

# log start setup
log_build "$package_name.setup.start" true

# gcc.verify
if [ ! -f $source_file ]; then
    log_build "$package_name:verify" false
    exit 1
else
    log_build "$package_name:verify" true
fi

# gcc.extract
# and change to source directory
if [ ! -d $source_dir ]; then

    log_build "$package_name.extract.start" true

    tar -vxf $source_file

    if [[ $? != 0 ]]; then
        log_build "$package_name.extract.finish" false
        exit 1
    else
        log_build "$package_name.extract.finish" true
    fi
else
    log_build "$package_name.extract.idle" true
fi
cd $source_dir

# mpfr.verify
if [ ! -f $mpfr_source_file ]; then
    log_build "$package_mpfr_name.verify" false
else
    log_build "$package_mpfr_name.verify" true
fi

# mpfr.extract
if [ ! -d $mpfr_source_dir ]; then

    log_build "$package_mpfr_name.extract.start"  true

    tar -vxf $mpfr_source_file

    if [[ $? != 0 ]]; then
        log_build "$package_mpfr_name.extract.finish" false
        exit 1
    else
        log_build "$package_mpfr_name.extract.finish" true
    fi

    mv -v mpfr-3.1.3 $mpfr_source_dir
else
    log_build "$package_mpfr_name.extract.idle" true
fi

# gmp.verify
if [ ! -f $gmp_source_file ]; then
    log_build "$package_gmp_name.verify" false
else
    log_build "$package_gmp_name.verify" true
fi

# gmp.extract
if [ ! -d $gmp_source_dir ]; then

    log_build "$package_gmp_name.extract.start" true

    tar -vxf $gmp_source_file

    if [[ $? != 0 ]]; then
        log_build "$package_gmp_name.extract.finish" false
        exit 1
    else
        log_build "$package_gmp_name.extract.finish" true
    fi

    mv -v gmp-6.0.0 $gmp_source_dir
else
    log_build "$package_gmp_name.extract.idle" true
fi

# mpc verify
if [ ! -f $mpc_source_file ]; then
    log_build "$package_mpc_name.verify" false
else
    log_build "$package_mpc_name.verify" true
fi

# mpc extract
if [ ! -d $mpc_source_dir ]; then

    log_build "$package_mpc_name.extract.start" true

    tar -vxf $mpc_source_file

    if [[ $? != 0 ]]; then
        log_build "$package_mpc_name.extract.finish" false
        exit 1
    else
        log_build "$package_mpc_name.extract.finish" true
    fi

    mv -v mpc-1.0.3 mpc
else
    log_build "$package_mpc_name.extract.idle" true
fi

# configure dependent packages
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

# create and change to build directory
cd ../
mkdir -vp $build_dir
cd $build_dir

# configure
log_build "$package_name.configure.start" true
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
if [[ $? != 0 ]]; then
    log_build "$package_name.configure.finish" false
    exit 1
else
    log_build "$package_name.configure.finish" true
fi

# build
log_build "$package_name.make.start" true
make
if [[ $? != 0 ]]; then
    log_build "$package_name.make.finish" false
    exit 1
else
    log_build "$package_name.make.finish" true
fi

# install
log_build "$package_name.install.start" true
make install
if [[ $? != 0 ]]; then
    log_build "$package_name.install.finish" false
    exit 1
else
    log_build "$package_name.install.finish" true
fi

# successfull
log_build "$package_name.setup.finish" true
exit 0
