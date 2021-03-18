FROM centos:7.7.1908

# Install dependencies
RUN yum groupinstall -y "Development Tools" && \
    yum install -y epel-release centos-release-scl && \
    yum install -y cmake3 devtoolset-7-gcc devtoolset-7-gcc-c++ numactl-devel boost-devel wget which && \
    yum clean all \
    && rm -rf /var/cache/yum \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base

COPY . /root/ardb

# Download and build Kreon
# FIXME: Build as "Release"...
WORKDIR /root/ardb/deps
RUN git clone https://github.com/CARV-ICS-FORTH/kreon.git && \
    sed -i "s/14bd35e20438bf8b7c45d37a66c71461d3cdfa94/ac7843ed930a43da34f35eebfa4447c6ac2f34e5/" kreon/CMakeLists.txt && \
    mkdir kreon/build && \
    (cd kreon/build && scl enable devtoolset-7 -- /bin/bash -c "cmake3 -DKREON_BUILD_CPACK=True .. && make DESTDIR=install install") && \
    (cd kreon/scripts && ./pack-staticlib.py ../build/install/usr/local/lib64/) && \
    cp kreon/build/install/usr/local/lib64/libkreon2.a rocksdb-5.14.2/

WORKDIR /root/ardb
RUN make
