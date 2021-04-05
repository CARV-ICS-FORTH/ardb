#!/bin/bash

# Build Kreon
rm -rf deps/kreon
(cd deps && git clone https://github.com/CARV-ICS-FORTH/kreon.git)
mkdir deps/kreon/build && (cd deps/kreon/build && cmake3 .. && make)

# Build Ardb
make server
