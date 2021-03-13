#!/bin/bash

#Build Ardb-Kreon this will command will fail but we need to run it to download the basic dependencies and create folders we will need later
make -j18

#Build Kreon
rm -rf deps/kreon
cd deps
git clone git@carvgit.ics.forth.gr:evolve/kreon.git
cd kreon
mkdir build
cd build
cmake3 .. -DKREON_BUILD_CPACK=True
make DESTDIR=install -j install
cd ../scripts
./pack-staticlib.py ../build/install/usr/local/lib64/

#Copy libs inside rocksDB
cd ../build/
cp install/usr/local/lib64/libkreon2.a ../../rocksdb-5.14.2/

cd ../../../
#Build again to resolve the error from ardb's make...
make -j18
