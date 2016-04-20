#!/bin/bash

# using     : build glibc
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
package_name="sys.glibc"
source_file="../glibc-2.22.tar.xz"
patch_fhs_file="../../glibc-2.22-fhs-1.patch"
patch_upstream_file="../../glibc-2.22-upstream_i386_fix-1.patch"
source_dir="glibc-2.22"
build_dir="glibc-build"
timezone_file="../../tzdata2015f.tar.gz"
test_log_file="/lfs-script/tmp/build-system.glibc.test.log"
test_sum_file="$root_system_sources/$build_dir/tests.sum"
fail_allowed_file="/lfs-script/asset/build-syste.glibc.test.fail.allowed.txt"

# step.verify
step_verify() {
    [ -f $source_file ]
}

# step.extract
step_extract() {
    tar -vxf $source_file
}

# step.patch
step_patch() {
    patch -Np1 -i $patch_fhs_file &&
    patch -Np1 -i $patch_upstream_file
}

# step.build-dir.mkdir
step_build_dir_mkdir() {
    mkdir -vp $build_dir
}

# step.configure
step_configure() {
    ../glibc-2.22/configure    \
          --prefix=/usr          \
          --disable-profile      \
          --enable-kernel=2.6.32 \
          --enable-obsolete-rpc
}

# step.build
step_build() {
    make
}

# step.test
step_test() {
    make check
    if [[ $? == 0 ]]; then
        return 0
    else

        # filters fail into log file
        grep -w "FAIL:*" $test_sum_file > $test_log_file

        # verify fail are allowed or not
        skip_fail=0
        while read line_fail; do

            # verify fail are allowed or not
            allowed=false
            while read fail_allowed; do
                if [[ $line_fail == $fail_allowed ]]; then
                    allowed=true
                    break
                fi
            done < $fail_allowed_file

            # if one fail are not allowed, do not skip fail
            if [[ $allowed == false ]]; then
                skip_fail=1
                break
            fi
        done < $test_log_file

        return $skip_fail
    fi
}

# step./etc/ld.so.conf.touch
step_ld_so_conf_touch() {
    touch /etc/ld.so.conf
}

# step.install
step_install() {
    make install
}

# step./etc/nscd.conf.cp
step_nscd_conf_cp() {
    cp -v ../glibc-2.22/nscd/nscd.conf /etc/nscd.conf &&
    mkdir -pv /var/cache/nscd
}

# step./usr/lib/locale.def
step_locale_def() {
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
}

# step./etc/nsswitch.conf.cp
step_nsswitch_cp() {
    cp -vp /lfs-script/asset/nsswitch.conf /etc/nsswitch.conf
}

# start setup timezone
log "timezone.setup.start" 0

# step.timezone.verify
step_timezone_verify() {
    [ -f $timezone_file ]
}

# step.timezone.extract
step_timezone_extract() {
    tar -vxf $timezone_file
}

# step.timezone.configure
step_timezone_configure() {
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
}

# step./etc/localtime.cp
step_localtime_cp() {
    cp -v /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime
}

# step./etc/ld.so.conf.cp
step_ld_so_conf_cp() {
    cp /lfs-script/asset/ld.so.conf /etc/ld.so.conf
}

# step./etc/ld.so.conf.d.mkdir
step_ld_so_conf_d_mkdir() {
    mkdir -pv /etc/ld.so.conf.d
}

# run
cd $root_system_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
cd $source_dir
run_step "$package_name.patch" step_patch
cd $root_system_sources
run_step "$package_name.build-dir.mkdir" step_build_dir_mkdir
cd $build_dir
run_step "$package_name.configure" step_configure
run_step "$package_name.make" step_build
run_step "$package_name.test" step_test
run_step "$package_name.ld-so-conf.touch" step_ld_so_conf_touch
run_step "$package_name.install" step_install
run_step "$package_name.nscd.conf.cp" step_nscd_conf_cp
run_step "$package_name.locale.def" step_locale_def
run_step "$package_name.nsswitch.cp" step_nsswitch_cp
run_step "$package_name.timezone.verify" step_timezone_verify
run_step "$package_name.timezone.extract" step_timezone_extract
run_step "$package_name.timezone.configure" step_timezone_configure
run_step "$package_name.localtime.cp" step_localtime_cp
run_step "$package_name.ld.so.conf.cp" step_ld_so_conf_cp
run_step "$package_name.ld.so.conf.d.mkdir" step_ld_so_conf_d_mkdir
exit 0
