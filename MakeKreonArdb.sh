#!/bin/bash

#Build Kreon
rm -rf deps/kreon
cd deps
git clone git@carvgit.ics.forth.gr:gxanth/kreon.git -b cursors
cd kreon
mkdir build
cd build
cmake3 ..
make DESTDIR=install -j install
cd ../scripts
./pack-staticlib.py ../build/install/usr/local/lib64/

cd ../../../

#This command always fails in order to download dependencies
make -j $(nproc)

#Copy libs inside rocksDB
cd deps/kreon/build
cp install/usr/local/lib64/libkreon2.a ../../rocksdb-5.14.2/

cd ../../../
make -j $(nproc)
