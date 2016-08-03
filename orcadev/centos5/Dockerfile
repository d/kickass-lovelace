FROM centos:5
ADD libc.conf /etc/ld.so.conf.d/libc.conf
RUN yum upgrade -q -y \
	&& yum install -q -y epel-release
RUN yum install -q -y git vim-enhanced nano make gcc-c++ gdb wget libidn.x86_64 patch gpg

RUN gpg --keyserver keys.gnupg.net --recv-keys 7BFB4EDA
RUN VERSION=3.6.1 \
	&& set -euxo pipefail \
	&& INSTALLER=cmake-${VERSION}-Linux-x86_64.sh \
	&& CHECKSUM=cmake-${VERSION}-SHA-256.txt \
	&& wget --no-verbose --no-check-certificate --directory-prefix /dev/shm http://cmake.org/files/v${VERSION%.*}/{${INSTALLER},${CHECKSUM}{,.asc}} \
	&& ( \
		cd /dev/shm \
		&& gpg --verify ${CHECKSUM}{.asc,} \
		&& fgrep ${INSTALLER} ${CHECKSUM} | sha256sum --check - \
	) \
	&& sh /dev/shm/${INSTALLER} --prefix=/usr/local --exclude-subdir
