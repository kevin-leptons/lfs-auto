#!/bin/bash

# using     : build glibc
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
package_name="glibc"
source_file="glibc-2.22.tar.xz"
source_dir="glibc-2.22"
build_dir="glibc-build"
timezone_file="../tzdata2015f.tar.gz"
test_log_file="/lfs-script/tmp/build-system.glibc.test.log"

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
    log_auto "$package_name.extract.finish" $?
fi
cd $source_dir

# path
log_auto "$package_name.patch.start" 0
patch -Np1 -i ../glibc-2.22-fhs-1.patch &&
patch -Np1 -i ../glibc-2.22-upstream_i386_fix-1.patch
log_auto "$package_name.patch.finish" $?

# create build directory
cd ../
rm -vrf $build_dir
mkdir -vp $build_dir
cd $build_dir
log_auto "$package_name.build-dir.create" $?

# configure
log_auto "$package_name.configure.start" 0
../glibc-2.22/configure    \
      --prefix=/usr          \
      --disable-profile      \
      --enable-kernel=2.6.32 \
      --enable-obsolete-rpc
log_auto "$package_name.configure.finish" $?

# build
log_auto "$package_name.make.start" 0
make
log_auto "$package_name.make.finish" $?

# test
log_auto "$package_name.test.start" 0
make check
grep -i -w "FAIL:*" /sources/gblic-build/tests.sum > $test_log_file
skip_fail=true
while read line_fail; do

    # verify fail are allowed or not
    allowed=false
    while read fail_allowed; do
        if [[ $line_fail == $fail_allowed ]]; then
            allowed=true
            break
        fi
    done < /lfs-script/asset/build-syste.glibc.test.fail.allowed.txt

    # if one fail are not allowd, do not skip fail
    if [[ $allowed == false ]]; then
        skip_fail=false
        break
    fi
done < $test_log_file
log_auto "$package_name.test.finish" 0
if [[ $? != 0 ]]; then

    if [[ $skip_fail == true]]; then
        log_auto "$package_name.test.fail.allow" 0
    else
        log_auto "$package_name.test.fail.allow" 1
    fi
fi

# install
log_auto "$package_name.install.start" 0
make install
log_auto "$package_name.install.finish" $?

# install configuration file
log_auto "$package_name.install-conf-file.start" 0
cp -v ../glibc-2.22/nscd/nscd.conf /etc/nscd.conf &&
mkdir -pv /var/cache/nscd &&
log_auto "$package_name.install-conf-file.finish" $?

# install locale
log_auto "$package_name.install-locale.start" 0
mkdir -pv /usr/lib/locale
localedef -i cs_CZ -f UTF-8 cs_CZ.UTF-8
localedef -i de_DE -f ISO-8859-1 de_DE
localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro
localedef -i de_DE -f UTF-8 de_DE.UTF-8
localedef -i en_GB -f UTF-8 en_GB.UTF-8
localedef -i en_HK -f ISO-8859-1 en_HK
localedef -i en_PH -f ISO-8859-1 en_PH
localedef -i en_US -f ISO-8859-1 en_US
localedef -i en_US -f UTF-8 en_US.UTF-8
localedef -i es_MX -f ISO-8859-1 es_MX
localedef -i fa_IR -f UTF-8 fa_IR
localedef -i fr_FR -f ISO-8859-1 fr_FR
localedef -i fr_FR@euro -f ISO-8859-15 fr_FR@euro
localedef -i fr_FR -f UTF-8 fr_FR.UTF-8
localedef -i it_IT -f ISO-8859-1 it_IT
localedef -i it_IT -f UTF-8 it_IT.UTF-8
localedef -i ja_JP -f EUC-JP ja_JP
localedef -i ru_RU -f KOI8-R ru_RU.KOI8-R
localedef -i ru_RU -f UTF-8 ru_RU.UTF-8
localedef -i tr_TR -f UTF-8 tr_TR.UTF-8
localedef -i zh_CN -f GB18030 zh_CN.GB18030

make localedata/install-locales
log_auto "$package_name.install-locale.finish" $?

# add nsswitch.conf
cp -vp asset/nsswitch.conf /etc/nsswitch.conf
log_auto "/etc/nsswitch.conf.create" $?

# start setup timezone
log_auto "timezone.setup.start" 0

# verify timezone data
if [ -f $timezone_file ]; then
    log_auto "$timezone_file.verify" 0
else
    log_auto "$timezone_file.verify" 1
fi

# extract timezone data
log_auto "timezone.extract.start" 0
tar -vxf $timezone_file
log_auto "timezone.extract.finish" $?

# configure timezone
ZONEINFO=/usr/share/zoneinfo &&
mkdir -pv $ZONEINFO/{posix,right} &&

for tz in etcetera southamerica northamerica europe africa antarctica  \
          asia australasia backward pacificnew systemv; do
    zic -L /dev/null   -d $ZONEINFO       -y "sh yearistype.sh" ${tz} &&
    zic -L /dev/null   -d $ZONEINFO/posix -y "sh yearistype.sh" ${tz} &&
    zic -L leapseconds -d $ZONEINFO/right -y "sh yearistype.sh" ${tz}
done

cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO &&
zic -d $ZONEINFO -p Asia/Ho_Chi_Minh &&
unset ZONEINFO

# create /etc/localtime
cp -v /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime
log_auto "/etc/localtime.create" $?

# finish setup timezone
log_auto "timezone.setup.finish" $?

# create /etc/ld.so.conf
cp asset/ld.so.conf /etc/ld.so.conf
log_auto "/etc/ld.so.conf.create" $?

# create /etc/ld.so.conf.d
mkdir -pv /etc/ld.so.conf.d
log_auto "/etc/ld.so.conf.d.create" $?

# successfully
log_auto "$package_name.setup.finish" $?
exit 0
