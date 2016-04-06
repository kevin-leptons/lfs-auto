#!/bin/bash

# using     : build gcc package in pass 1
# params    : none
# return    : 0 on successfull, 1 on error
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd $root_sources

# define variables
source_file=gcc-5.2.0.tar.bz2
source_dir=gcc-5.2.0
build_dir=gcc-build
mpfr_source_file=../mpfr-3.1.3.tar.xz
gmp_source_file=../gmp-6.0.0a.tar.xz
mpc_source_file=../mpc-1.0.3.tar.gz
mpfr_source_dir=mpfr
gmp_source_dir=gmp
mpc_source_dir=mpc

# verify source file
if [ ! -f $source_file ]; then
    echo "error: source file " $source_file " is not exist"
fi

# extract source file
if [ ! -d $source_dir ]; then
    tar -xf $source_file
fi
if $?; then
    echo "error: extract source file " $source_file
    echo $?
    exit 1
fi

# resolve dependent package
cd $source_dir

if [ ! -d $mpfr_source_dir ]; then

   tar -xf $mpfr_source_file
   if $?; then
       echo "error: extract source file " $mpfr_source_file
       echo $?
       exit 1
   fi

   mv -v mpfr-3.1.3 $mpfr_source_dir
fi

if [ ! -d gmp ]; then

    tar -xf ../gmp-6.0.0a.tar.xz
    if $?; then
        echo "error: extract source file " $gmp_source_file
        echo $?
        exit 1
    fi

    mv -v gmp-6.0.0 gmp
fi

if [ ! -d mpc ]; then

   tar -xf ../mpc-1.0.3.tar.gz
   if $?; then
       echo "error: extract source file " $mpc_source_file
       echo $?
       exit 1
   fi

   mv -v mpc-1.0.3 mpc
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
cd gcc-build

# configure
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
if $?; then
    echo "error: configure " $source_file
    echo $?
    exit 1
fi

# build
make
if $?; then
    echo "error: make " $source_file
    echo $?
    exit 1
fi

# install
make install
if $?; then
    echo "error: install " $source_file
    echo $?
    exit 1
fi

# successfull
exit 0
