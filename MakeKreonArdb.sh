#Build Kreon
cd deps
git clone git@carvgit.ics.forth.gr:evolve/kreon.git
cd kreon
mkdir build
cd build
cmake3 ..
make

#Copy libs inside rocksDB
cp kreon_lib/libkreon.a ../../rocksdb-5.14.2/
cp _deps/log-build/liblog.a ../../rocksdb-5.14.2/

#Build Ardb-Kreon
cd ../../..
make -j18
