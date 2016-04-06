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

# extract source code and change to source code directory
rm -rf gcc-5.2.0 &&
tar -xf gcc-5.2.0.tar.bz2 &&
cd gcc-5.2.0 &&

# fix limit header
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
   `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include-fixed/limits.h &&

# change gcc dynamic link to /tools
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

# resolve dependent packages
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

# create build directory
cd ../
rm -rf gcc-build
mkdir -vp gcc-build
cd gcc-build

# configure
CC=$LFS_TGT-gcc                                    \
CXX=$LFS_TGT-g++                                   \
AR=$LFS_TGT-ar                                     \
RANLIB=$LFS_TGT-ranlib                             \
../gcc-5.2.0/configure                             \
    --prefix=/tools                                \
    --with-local-prefix=/tools                     \
    --with-native-system-header-dir=/tools/include \
    --enable-languages=c,c++                       \
    --disable-libstdcxx-pch                        \
    --disable-multilib                             \
    --disable-bootstrap                            \
    --disable-libgomp &&

# build
make &&

# install
make install &&

# link
ln -sv gcc /tools/bin/cc

# test
# this is not way to get test result
# todo: make other way to get test result
echo 'int main() {}' > dummy.c
cc dummy.c
readelf -l a.out | grep ': /tools'
rm -v dummy.c a.out
