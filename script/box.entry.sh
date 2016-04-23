#!/bin/bash

# using     : box.entry
#             setup inside of box
#             active box.dev
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"

# working-dir.change
cd /lfs-script

# libs
source configuration.sh
source util.sh

# box.dev.setup
./box.inside.dev.setup.sh
exit_on_error

# box.partition.setup
./box.inside.partition.setup.sh
exit_on_error

# box.dev.active
sudo -u $build_user bash box.dev.entry.sh "$1"
