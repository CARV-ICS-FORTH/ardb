################################################################################
# Builder image
################################################################################
FROM centos:7.7.1908 as ardb-kreon-builder

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

WORKDIR /root
COPY . ardb-kreon

# Build
RUN (cd ardb-kreon && scl enable devtoolset-7 -- /bin/bash -c "./MakeKreonArdb.sh")
RUN strip ardb-kreon/src/ardb-server
RUN strip ardb-kreon/deps/kreon/build/mkfs.kreon

################################################################################
# Ardb-Kreon distribution
################################################################################
FROM centos:7.7.1908 as ardb-kreon

# Install dependencies
RUN yum install -y numactl && \
    yum clean all \
    && rm -rf /var/cache/yum \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base

COPY --from=ardb-kreon-builder /root/ardb-kreon/ardb.conf /etc
COPY --from=ardb-kreon-builder /root/ardb-kreon/src/ardb-server /usr/bin
COPY --from=ardb-kreon-builder /root/ardb-kreon/deps/kreon/build/kreon_lib/mkfs.kreon /usr/bin

RUN sed -ri 's|^home(\s)+..|home /var/ardb|' /etc/ardb.conf && \
    sed -i 's|16379|6379|' /etc/ardb.conf && \
    mkdir -p /var/ardb/data

EXPOSE 6379

WORKDIR /
COPY start.sh /
ENV DATABASE_SIZE 20
CMD ./start.sh
