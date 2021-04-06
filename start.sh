#!/bin/bash

SIZE=${DATABASE_SIZE:-20}

fallocate -l ${SIZE}GB /var/ardb/data/kreon.dat
mkfs.kreon /var/ardb/data/kreon.dat 0 `wc -c < /var/ardb/data/kreon.dat`
ardb-server /etc/ardb.conf
