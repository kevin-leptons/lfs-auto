#!/bin/bash

# using     : build gcc package in pass 1
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd $root_sources

# extract source code
if [ ! -d gcc-5.2.0 ]; then
    tar -xf gcc-5.2.0.tar.bz2
fi

# resolve dependent package
cd gcc-5.2.0
if [ ! -d mpfr ]; then
   tar -xf ../mpfr-3.1.3.tar.xz &&
   mv -v mpfr-3.1.3 mpfr
fi
if [ ! -d gmp ]; then
   tar -xf ../gmp-6.0.0a.tar.xz &&
   mv -v gmp-6.0.0 gmp
fi
if [ ! -d mpc ]; then
   tar -xf ../mpc-1.0.3.tar.gz &&
   mv -v mpc-1.0.3 mpc
fi

# configure dependent package
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
mkdir -vp gcc-build &&
cd gcc-build &&

# configure package
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

# build package
make &&

# install package
make install
