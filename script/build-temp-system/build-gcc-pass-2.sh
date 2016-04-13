#!/bin/bash

# using     : build gcc package in pass 1
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

# variables
package_name="gcc-pass-2"
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
simple_program_source="/lfs-script/asset/simple-program.c"
simple_program_dest="/lfs-script/tmp/simple-program"

# change working directory to sources directory
cd $root_sources

# start
log_auto "$package_name.setup.start" 0

# gcc.verify
if [ -f $source_file ]; then
    log_auto "$package_name:verify" 0
else
    log_auto "$package_name:verify" 1
fi

# gcc.extract
# and change to source directory
if [ -d $source_dir ]; then
    log_auto "$package_name.extract.idle" 0
else
    log_auto "$package_name.extract.start" 0
    tar -vxf $source_file
    log_auto "$package_name.extract.finish" $?
fi
cd $source_dir

# fix limit header
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
   `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include-fixed/limits.h
log_auto "$package_name.limit-header.fix" $?

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
log_auto "$package_name.gcc-dynamic-link.change-to-tools" $?

# mpfr.verify
if [ -f $mpfr_source_file ]; then
    log_auto "$package_mpfr_name.verify" 0
else
    log_auto "$package_mpfr_name.verify" 1
fi

# mpfr.extract
if [ -d $mpfr_source_dir ]; then
    log_auto "$package_mpfr_name.extract.idle" 0
else
    log_auto "$package_mpfr_name.extract.start" 0
    tar -vxf $mpfr_source_file
    log_auto "$package_mpfr_name.extract.finish" $?
    mv -v mpfr-3.1.3 $mpfr_source_dir
fi

# gmp.verify
if [ -f $gmp_source_file ]; then
    log_auto "$package_gmp_name.verify" 0
else
    log_auto "$package_gmp_name.verify" 1
fi

# gmp.extract
if [ -d $gmp_source_dir ]; then
    log_auto "$package_gmp_name.extract.idle" 0
else
    log_auto "$package_gmp_name.extract.start" 0
    tar -vxf $gmp_source_file
    log_auto "$package_gmp_name.extract.finish" $?
    mv -v gmp-6.0.0 $gmp_source_dir
fi

# mpc verify
if [ -f $mpc_source_file ]; then
    log_auto "$package_mpc_name.verify" 0
else
    log_auto "$package_mpc_name.verify" 1
fi

# mpc extract
if [ -d $mpc_source_dir ]; then
    log_auto "$package_mpc_name.extract.idle" 0
else
    log_auto "$package_mpc_name.extract.start" 0
    tar -vxf $mpc_source_file
    log_auto "$package_mpc_name.extract.finish" $?
    mv -v $mpc_source_dir
fi

# create and change to build directory
cd ../
rm -rf $build_dir
mkdir -vp $build_dir
cd $build_dir

# configure
log_auto "$package_name.configure.start" 0
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
    --disable-libgomp
log_auto "$package_name.configure.finish" $?

# build
log_auto "$package_name.make.start" 0
make
log_auto "$package_name.make.finish" $?

# install
log_auto "$package_name.install.start" 0
make install
log_auto "$package_name.install.finish" $?

# link
ln -sv gcc /tools/bin/cc
log_auto "$package_name.link" $?

# test
cc "$simple_program_source" -o "$simple_program_dest" &&
readelf -l "$simple_program_dest" | grep ': /tools' | \
    grep "Requesting program interpreter"
log_auto "$package_name.compile" $?

# successfull
log_auto "$package_name.setup.finish" $?
exit 0
