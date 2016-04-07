#!/bin/bash

# using     : setup host environment
# notes     : tools version will print in format <required:current>
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"

# use configuration
# use util
source $__dir__/configuration.sh
source $__dir__/util.sh

# ?
export LC_ALL=C

# define variables
task_name="verify-host-env"
verify_ok=true
bash_version_req="3.2"
sh_link_req="/bin/bash"
binutils_version_req="2.17"
bison_version_req="2.3"
yacc_link_req="/usr/bin/bison"
bzip2_version_req="1.0.4"
coreutils_version_req="6.9"
diffutils_version_req="2.81"
findutils_version_req="4.2.31"
gawk_version_req="4.0.1"
awk_link_req="/usr/bin/gawk"
gcc_version_req="4.1.2"
glibc_version_req="2.11"
grep_version_req="2.5.1a"
gzip_version_req="1.3.12"
linux_version_req="2.6.32"
m4_version_req="1.4.10"
make_version_req="3.81"
patch_version_req="2.5.4"
perl_version_req="5.8.8"
sed_version_req="4.1.5"
tar_version_req="1.22"
texinfo_version_req="4.7"
xz_version_req="5.0.0"

# log start verify
log_build "$task_name.start" true

# verify bash version
bash_version=$(bash --version | head -n1 | cut -d" " -f4 | cut -d"(" -f1)
if version_gt $bash_version $bash_version_req; then
    log_build \
        "bash.version.verify $bash_version_req#$bash_version" true
else
    verify_ok=false
    "bash.version.verify $bash_version_req#$bash_version" false
fi

# verify /bin/sh link
sh_link=$(readlink -f /bin/sh)
if [[ $sh_link == $sh_link_req ]]; then
    log_build "sh.link.verify $sh_link_req#$sh_link" true
else
    verify_ok=false
    log_build "sh.link.verify $sh_link_req#$sh_link" false
fi

# verify binutils
binutils_version=$(ld --version | head -n1 | cut -d" " -f7-)
if version_gt $binutils_version $binutils_version_req; then
    msg="binutils.version.verify $binutils_version_req#$binutils_version_req"
    log_build "$msg" true
else
    verify_ok=false
    msg="binutils.version.verify $binutils_version_req#$binutils_version_req"
    log_build "$msg" false
fi

# verify bison
bison_version=$(bison --version | head -n1 | cut -d" " -f4)
if version_gt $bison_version $bison_version_req; then
    log_build "bison.version.verify $bison_version_req#$bison_version" true
else
    verify_ok=false
    log_build "bison.version.verify $bison_version_req#$bison_version" true
fi

# verify yacc link to bison
# or yacc is executable
if [ -h /usr/bin/yacc ]; then
    yacc_link=$(readlink -f /usr/bin/yacc)
    if [[ $yacc_link == $yacc_link_req ]]; then
        log_build "yacc.link.verify $yacc_link_req#$yacc_link" true
    else
        verify_ok=false
        log_build "yacc.link.verify $yacc_link_req#$yacc_link" true
    fi
elif [ -x /usr/bin/yacc ]; then
    log_build "yacc.executable.verify" true
else
    verify_ok=false
    log_build "yacc.verify" false
fi

# verify bzip2
bzip2_version=$(bzip2 --version 2>&1 < /dev/null | \
    head -n1 | cut -d" " -f8 | cut -d "," -f1)
if version_gt $bzip2_version $bzip2_version_req; then
    log_build "bzip2.version.verify $bzip2_version_req#$bzip2_version_req" true
else
    verify_ok=false
    log_build "bzip2.version.verify $bzip2_version_req#$bzip2_version_req" false
fi

# verify coreutils
coreutils_version=$(chown --version | head -n1 | cut -d" " -f4)
if version_gt $coreutils_version $coreutils_version_req; then
    log_build \
        "coreutils.version.verify $coreutils_version_req#$coreutils_version" \
        true
else
    verify_ok=false
    log_build \
        "coreutils.version.verify $coreutils_version_req#$coreutils_version" \
        false
fi

# verify diffutils
diffutils_version=$(diff --version | head -n1 | cut -d" " -f4)
if version_gt $diffutils_version $diffutils_version_req; then
    log_build \
    "diffutils.version.verify $diffutils_version_req#$diffutils_version_req" \
    true
else
    verify_ok=false
    log_build \
    "diffutils.version.verify $diffutils_version_req#$diffutils_version_req" \
    false
fi

# verify findutils
findutils_version=$(find --version | head -n1 | cut -d" " -f4)
if version_gt $findutils_version $findutils_version_req; then
    log_build \
    "findutils.version.verify $findutils_version_req#$findutils_version" \
    true
else
    verify_ok=false
    log_build \
    "findutils.version.verify $findutils_version_req#$findutils_version" \
    false
fi

# verify gawk
gawk_version=$(gawk --version | head -n1 | cut -d" " -f3 | cut -d"," -f1)
if version_gt $gawk_version $gawk_version_req; then
    log_build "gawk.version.verify $gawk_version_req#$gawk_version" true
else
    verify_ok=false
    log_build "gawk.version.verify $gawk_version_req#$gawk_version" true
fi

# verify awk link to gawk
if [ -h /usr/bin/awk ]; then
    awk_link=$(readlink -f /usr/bin/awk)
    if [[ $awk_link == $awk_link_req ]]; then
        log_build "awk.link.verify $awk_link_req#$awk_link" true
    else
        verify_ok=false
        log_build "awk.link.verify $awk_link_req#$awk_link" false
    fi
elif [ -x /usr/bin/awk ]; then
    log_build "awk.executable.verify" true
else
    verify_ok=false
    log_build "awk.verify" false
fi

# verify gcc
gcc_version=$(gcc --version | head -n1 | cut -d" " -f4)
if version_gt $gcc_version $gcc_version_req; then
    log_build "gcc.version.verify $gcc_version_req#$gcc_version" true
else
    verify_ok=false
    log_build "gcc.version.verify $gcc_version_req#$gcc_version" false
fi

# verify g++
gpp_version=$(g++ --version | head -n1 | cut -d" " -f4)
if version_gt $gpp_version $gcc_version_req; then
    log_build "g++.version.verify $gcc_version_req#$gpp_version" true
else
    verify_ok=false
    log_build "g++.version.verify $gcc_version_req#$gpp_version" false
fi

# verify glibc
glibc_version=$(ldd --version | head -n1 | cut -d" " -f5)
if version_gt $glibc_version $glibc_version_req; then
    log_build "glibc.version.verify $glibc_version_req#$glibc_version" true
else
    verify_ok=false
    log_build "glibc.version.verify $glibc_version_req#$glibc_version" false
fi

# verify grep
grep_version=$(grep --version | head -n1 | cut -d" " -f4)
if version_gt $grep_version $grep_version_req; then
    log_build "grep.version.verify $grep_version_req#$grep_version" true
else
    verify_ok=false
    log_build "grep.version.verify $grep_version_req#$grep_version" false
fi

# verify gzip
gzip_version=$(gzip --version | head -n1 | cut -d" " -f2)
if version_gt $gzip_version $gzip_version_req; then
    log_build "gzip.version.verify $gzip_version_req#$gzip_version" true
else
    verify_ok=false
    log_build "gzip.version.verify $gzip_version_req#$gzip_version" false
fi

# verify linux kernel
linux_version=$(cat /proc/version | cut -d" " -f3 | cut -d"-" -f1)
if version_gt $linux_version $linux_version_req; then
    log_build "linux.version.verify $linux_version_req#$linux_version" true
else
    verify_ok=false
    log_build "linux.version.verify $linux_version_req#$linux_version" false
fi

# verify m4
m4_version=$(m4 --version | head -n1 | cut -d" " -f4)
if version_gt $m4_version $m4_version_req; then
    log_build "m4.version.verify $m4_version_req#$m4_version" true
else
    verify_ok=false
    log_build "m4.version.verify $m4_version_req#$m4_version" false
fi

# verify make
make_version=$(make --version | head -n1 | cut -d" " -f3)
if version_gt $make_version $make_version_req; then
    log_build "make.version.verify $make_version_req#$make_version" true
else
    verify_ok=false
    log_build "make.version.verify $make_version_req#$make_version" false
fi

# verify patch
patch_version=$(patch --version | head -n1 | cut -d" " -f3)
if version_gt $patch_version $patch_version_req; then
    log_build "patch.version.verify $patch_version_req#$patch_version" true
else
    verify_ok=false
    log_build "patch.version.verify $patch_version_req#$patch_version" false
fi

# verify perl
perl_version=$(perl -V:version | cut -d"'" -f2)
if version_gt $perl_version $perl_version_req; then
    log_build "perl.version.verify $perl_version_req#$perl_version" true
else
    verify_ok=false
    log_build "perl.version.verify $perl_version_req#$perl_version" false
fi

# verify sed
sed_version=$(sed --version | head -n1 | cut -d" " -f4)
if version_gt $sed_version $sed_version_req; then
    log_build "sed.version.verify $sed_version_req#$sed_version" true
else
    verify_ok=false
    log_build "sed.version.verify $sed_version_req#$sed_version" false
fi

# verify tar
tar_version=$(tar --version | head -n1 | cut -d" " -f4)
if version_gt $tar_version $tar_version_req; then
    log_build "tar.version.verify $tar_version_req#$tar_version" true
else
    verify_ok=false
    log_build "tar.version.verify $tar_version_req#$tar_version" false
fi

# verify texinfo
texinfo_version=$(makeinfo --version | head -n1 | cut -d" " -f4)
if version_gt $texinfo_version $texinfo_version_req; then
    log_build "texinfo.version.verify $texinfo_version_req#$texinfo_version" \
    true
else
    verify_ok=false
    log_build "texinfo.version.verify $texinfo_version_req#$texinfo_version" \
    false
fi

# verify xz
xz_version=$(xz --version | head -n1 | cut -d" " -f4)
if version_gt $xz_version $xz_version_req; then
    log_build "xz.version.verify $xz_version_req#$xz_version" true
else
    verify_ok=false
    log_build "xz.version.verify $xz_version_req#$xz_version" false
fi

# try compiler g++
program_path="tmp/simple-program"
g++ -o $program_path asset/simple-program.c
if [ -x $program_path ]; then
    log_build "g++.compile" true
else
    verify_ok=false
    log_build "g++.compile" false
fi

# verify library
# include: gmp, mpfr, mpc
lib_found=0
for lib in lib{gmp,mpfr,mpc}.la; do
    if find /usr/lib* -name $lib | grep -q $lib; then
        lib_found=$(($lib_found + 1))
    fi
done
if [[ $lib_found == 0 || $lib_found == 3 ]]; then
    log_build "{gmp, mpfr, mpc}.verify" true
else
    log_build "{gmp, mpfr, mpc}.verify" false
fi
unset lib

# finish verify tools
if [[ $verify_ok == true ]]; then
    log_build "$task_name.finish" true
    exit 0
else
    log_build "$task_name.finish" false
    exit 1
fi
