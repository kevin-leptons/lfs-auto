#!/bin/bash

echo "travis is disabled. travis build will support later"
exit 1

cd script
sudo bash entry-lfs.sh
sudo bash build.sh
