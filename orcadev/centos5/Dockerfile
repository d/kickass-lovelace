FROM centos:5
RUN yum upgrade -y \
	&& yum install -y epel-release
RUN yum install -qy git vim-enhanced nano make gcc-c++ gdb wget libidn.x86_64 patch gpg

RUN gpg --keyserver keys.gnupg.net --recv-keys 7BFB4EDA
RUN VERSION=3.6.1 \
	&& set -euxo pipefail \
	&& wget --no-verbose --no-check-certificate --directory-prefix /dev/shm http://cmake.org/files/v${VERSION%.*}/cmake-${VERSION}-{SHA-256.txt{,.asc},Linux-x86_64.sh} \
	&& ( \
		cd /dev/shm \
		&& gpg --verify cmake-${VERSION}-SHA-256.txt{.asc,} \
		&& fgrep cmake-${VERSION}-Linux-x86_64.sh cmake-${VERSION}-SHA-256.txt | sha256sum --check - \
	) \
	&& sh /dev/shm/cmake-${VERSION}-Linux-x86_64.sh --prefix=/usr/local --exclude-subdir
