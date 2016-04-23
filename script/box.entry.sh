#!/bin/bash

# using     : box.entry
#             setup inside of box
#             active box.dev
# author    : kevin.leptons@gmail.com

# exit when error
set -e

# working-dir.change
cd /lfs-script

# libs
source configuration.sh

# box.dev.setup
./box.inside.dev.setup.sh

# box.partition.setup
./box.inside.partition.setup.sh

# box.dev.active
sudo -u $build_user bash box.dev.entry.sh "$1"
