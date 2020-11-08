#!/bin/bash
set -e

wget -q https://github.com/giltene/wrk2/archive/master.zip

unzip -qq master.zip
rm master.zip
cd wrk2-master
make
mv wrk ../wrk2
rm -rf wrk2-master
