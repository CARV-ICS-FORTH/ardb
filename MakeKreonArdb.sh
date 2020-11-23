make clean
cd ../db_bench/kreon
mkdir build
cd build
cmake3 ..
make
cp kreon_lib/libkreon.a  ../../../ardb/deps/rocksdb-5.14.2/
cp _deps/log-build/liblog.a ../../../ardb/deps/rocksdb-5.14.2/
cd ../../../ardb/deps/rocksdb-5.14.2/
echo "Fetched kreon static lib"
cd ../../
make -j12

echo "Make Done"
