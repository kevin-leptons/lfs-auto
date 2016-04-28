#!/bin/bash

# using     : entry of box.dev
#             setup inside of box.dev
#             fork process depend on params
# author    : kevin.leptons@gmail.com

# bash options
set -e

# working-dir.change
cd /lfs-script

# libs
source configuration.sh
source util.sh

# update shell
source ~/.bashrc

# create build directories
mkdir -vp "$root_tmp_sources" "$root_sources/system-build"

# continue process depend on params
# allow jump to entry of tmp-sys or sys
case "$1" in

    # transfer control to user under shell
    "box" )
        log "box.dev.enter" 0
        bash;;

    # enter tmp-sys, transfer control to user under shell
    # only enter when tmp-sys has build successfully
    "tmp-sys" )
        tmp_state=$(step_state "tmp-sys.pack.setup.finish")
        if [[ $tmp_state != "ok" ]]; then
            log "tmp-sys.active" 1 "tmp-sys.pack.setup.no"
        fi
        bash tmp-sys.active.sh bash;;

    # enter sys, transfer control to user under shell
    # only enter when sys has build successfully
    "sys" )
        sys_state=$(step_state "sys.pack.setup.finish")
        if [[ $sys_state != "ok" ]]; then
            log "sys.active" 1 "sys.pack.setup.no"
        fi
        bash sys.active.sh bash;;

    # continue setup imediately
    * ) bash setup.sh;;
esac
