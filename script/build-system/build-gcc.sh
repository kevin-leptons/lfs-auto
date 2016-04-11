#!/bin/bash

# using     : build gcc
# params    : none
# return    : 0 on success, 1 on error
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
# use util
source $script_dir/configuration.sh
source $script_dir/util.sh

# define variables
package_name="gcc"
source_file="gcc-5.2.0.tar.bz2"
source_dir="gcc-5.2.0"
build_dir="gcc-build"
test_log_file="/lfs-script/log/gcc.test.log"

# log start
log_auto "$package_name.setup.start" 0

# change working directory to sources directory
cd /sources

# verify
if [ -f $source_file ]; then
    log_auto "$package_name.verify" 0
else
    log_auto "$package_name.verify" 1
fi

# extract source code and change to source directory
if [ -d $source_dir ]; then
    log_auto "$package_name.extract.idle" 0
else
    log_auto "$package_name.extract.start" 0
    tar -vxf $source_file
    log_auto "$package_name.extract.start" $?
fi

# create build directory
mkdir -vp $build_dir
cd $build_dir

# configure
log_auto "$package_name.configure.start" 0
SED=sed                       \
../gcc-5.2.0/configure        \
   --prefix=/usr            \
   --enable-languages=c,c++ \
   --disable-multilib       \
   --disable-bootstrap      \
   --with-system-zlib
log_auto "$package_name.configure.finish" $?

# build
log_auto "$package_name.make.start" 0
make
log_auto "$package_name.make.finish" $?

# test
log_auto "$package_name.test.start" 0
ulimit -s 32768
make -k check
../gcc-5.2.0/contrib/test_summary > $test_log_file
log_auto "$package_name.test.finish" $?

# install
log_auto "$package_name.install.start" 0
make install
log_auto "$package_name.install.finish" $?

# link
ln -sv ../usr/bin/cpp /lib &&
ln -sv gcc /usr/bin/cc &&
install -v -dm755 /usr/lib/bfd-plugins &&
ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/5.2.0/liblto_plugin.so \
    /usr/lib/bfd-plugins/
log_auto "$package_name.link" $?

# compile simple program
echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
log_auto "gcc.compile" $?

# read elf
readelf -l a.out | grep ': /lib' | grep "Requesting program interpreter"
log_auto "gcc.readelf" $?

# make sure use correct startfiles
lib_count=$(grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log | wc)
if [[ $lib_count == 3 ]]; then
    log_auto "gcc.lib.verify" 0
else
    log_auto "gcc.lib.verify" 1
else

# make sure correct header files
grep -B4 '^ /usr/include' dummy.log
log_auto "/usr/include/.verify" $?

# verify linker
grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
log_auto "/usr/lib/.verify" $?

# verify correct library
grep "/lib.*/libc.so.6 " dummy.log
log_auto "/lib/lib.so.6.verify" $?

# verify 64bits
grep found dummy.log
log_auto "found.verify" $?

rm -v dummy.c a.out dummy.log

# install misplaced file
mkdir -pv /usr/share/gdb/auto-load/usr/lib &&
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib
log_build "$package.install-misplaced-file" $?

# successfully
log_auto "$package_name.setup.finish" $?
exit 0
