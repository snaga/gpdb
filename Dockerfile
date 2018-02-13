FROM centos:7
MAINTAINER Satoshi Nagayasu <snaga@uptime.jp>

# curl
ADD curl-7.58.0.tar.gz /tmp
# cmake
ADD cmake-3.10.2-Linux-x86_64.sh /tmp
# GPDB
ADD 5.4.1.tar.gz /tmp

RUN yum install -y gcc make openssl-devel && \
    pushd /tmp/curl-7.58.0 && \
      ./configure --with-ssl && \
      make && \
      make install && \
    popd

RUN pushd /tmp && \
      sh cmake-3.10.2-Linux-x86_64.sh --skip-license --prefix=/usr && \
    popd

RUN curl -kL https://bootstrap.pypa.io/get-pip.py | python && \
    pip install conan && \
    yum install -y gcc-c++ xerces-c xerces-c-devel && \
    pushd /tmp/gpdb-5.4.1 && \
      pushd depends && \
        ./configure && \
        make && \
        make install_local && \
      popd && \
    popd

# NOTE:
# https://github.com/greenplum-db/gpdb/blob/master/README.linux.md

RUN pushd /tmp/gpdb-5.4.1 && \
      yum install -y perl perl-ExtUtils-Embed readline-devel zlib-devel \
                     apr apr-devel libevent-devel libxml2-devel bzip2-devel \
                     bison flex python-devel && \
      echo /usr/local/lib > /etc/ld.so.conf.d/gpdb.conf && \
      ldconfig && \
      ./configure --with-perl --with-python --with-libxml --with-gssapi --prefix=/usr/local/gpdb && \
      make && \
      make install && \
    popd
