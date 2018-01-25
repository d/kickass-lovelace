FROM centos:5 AS base

RUN rm -v /etc/yum.repos.d/CentOS*.repo /etc/yum.repos.d/libselinux.repo
ADD CentOS-Vault.repo /etc/yum.repos.d

RUN yum upgrade -q -y \
	&& yum install -q -y epel-release

RUN yum install -q -y \
	wget \
	gpg \
	unzip

FROM base AS cmake
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 7BFB4EDA
ENV VERSION=3.6.3
ENV INSTALLER=cmake-${VERSION}-Linux-x86_64.sh
ENV CHECKSUM=cmake-${VERSION}-SHA-256.txt
RUN wget --no-verbose --no-check-certificate --directory-prefix / http://cmake.org/files/v${VERSION%.*}/{${INSTALLER},${CHECKSUM}{,.asc}}
WORKDIR /
RUN gpg --verify ${CHECKSUM}{.asc,}
RUN fgrep ${INSTALLER} ${CHECKSUM} | sha256sum --check -
RUN mkdir /opt/cmake
RUN sh ./${INSTALLER} --prefix=/opt/cmake --exclude-subdir

FROM base AS ninja
RUN wget https://github.com/ninja-build/ninja/releases/download/v1.8.2/ninja-linux.zip --output-document /tmp/ninja-linux.zip
RUN mkdir -vp /opt/ninja/bin
RUN unzip /tmp/ninja-linux.zip -d /opt/ninja/bin

FROM base AS toolchain_sans_cc
RUN yum install -q -y \
	git \
	vim-enhanced \
	nano \
	make \
	glibc-devel \
	gdb \
	wget \
	libidn.x86_64 \
	patch \
	gpg \
	zlib-devel \
	openssl-devel \
	bzip2 \
	xz \
	unzip \
	p7zip \
	pigz

FROM toolchain_sans_cc AS old_cc
RUN yum install -q -y \
	gcc-c++

FROM ubuntu AS pip
RUN apt-get update -q
RUN apt-get install -y wget
RUN mkdir /opt/pip
RUN wget 'https://bootstrap.pypa.io/get-pip.py' --output-document /opt/pip/get-pip.py

FROM old_cc AS python
# gpg: key 18ADD4FF: public key "Benjamin Peterson <benjamin@python.org>" imported
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys C01E1CAD5EA2C4F0B8E3571504C367C218ADD4FF
ENV PYTHON_VERSION=2.7.14
RUN curl -fSL "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tgz" -o python.tgz
RUN curl -fSL "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tgz.asc" -o python.tgz.asc
RUN gpg --batch --verify python.tgz.asc python.tgz
RUN mkdir -p /usr/src/python
RUN tar -xC /usr/src/python --strip-components=1 -f python.tgz
WORKDIR /usr/src/python
RUN ./configure \
	--enable-unicode=ucs4
# Oh boy CentOS 5, how I miss nproc
RUN make -j$(getconf _NPROCESSORS_ONLN) -l$((2 * $(getconf _NPROCESSORS_ONLN))) install DESTDIR=/opt/python

FROM old_cc AS ccache
ENV VERSION=3.3.1
RUN curl -fSL "https://www.samba.org/ftp/ccache/ccache-${VERSION}.tar.bz2" -o /tmp/ccache.tar.bz2
RUN mkdir -p /usr/src/ccache
RUN tar xf /tmp/ccache.tar.bz2 --strip-components=1 -C /usr/src/ccache
RUN mkdir -p /build/ccache
WORKDIR /build/ccache
RUN mkdir /opt/ccache
RUN /usr/src/ccache/configure
# Oh boy CentOS 5, how I miss nproc
RUN make -j$(getconf _NPROCESSORS_ONLN) -l$((2 * $(getconf _NPROCESSORS_ONLN))) install DESTDIR=/opt/ccache

FROM old_cc AS gcc
# https://gcc.gnu.org/mirrors.html
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys \
	B215C1633BCA0477615F1B35A5B3A004745C015A \
	B3C42148A44E6983B3E4CC0793FA9B1AB75C61B8 \
	90AA470469D3965A87A5DCB494D03953902C9419 \
	80F98B2E0DAB6C8281BDF541A7C8C3B2F71EDF1C \
	7F74F97C103468EE5D750B583AB00996FC26A641 \
	33C235A34C46AA3FFB293709A328C3A2C3C45C06
ENV GCC_VERSION=4.9.4
RUN curl -fSL "http://ftpmirror.gnu.org/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.bz2" -o gcc.tar.bz2
RUN curl -fSL "http://ftpmirror.gnu.org/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.bz2.sig" -o gcc.tar.bz2.sig
RUN gpg --batch --verify gcc.tar.bz2.sig gcc.tar.bz2
ENV SRC_DIR=/src/gcc-${GCC_VERSION}
RUN mkdir -vp ${SRC_DIR}
RUN tar -xf gcc.tar.bz2 -C ${SRC_DIR} --strip-components=1
RUN cd ${SRC_DIR} \
	&& ./contrib/download_prerequisites
ENV BUILD_DIR=/build/gcc-${GCC_VERSION}
RUN mkdir -vp ${BUILD_DIR}
RUN pushd ${BUILD_DIR} \
	&& ${SRC_DIR}/configure \
		--disable-multilib \
		--enable-languages=c,c++
# Oh boy CentOS 5, how I miss nproc
RUN make -s -j$(getconf _NPROCESSORS_ONLN) -l$((2 * $(getconf _NPROCESSORS_ONLN))) -C ${BUILD_DIR}
RUN make -s -j$(getconf _NPROCESSORS_ONLN) -l$((2 * $(getconf _NPROCESSORS_ONLN))) -C ${BUILD_DIR} install-strip DESTDIR=/opt/gcc

FROM toolchain_sans_cc AS deploy
WORKDIR /
COPY --from=python /opt/python /
COPY --from=pip /opt/pip/get-pip.py /opt
RUN python2 /opt/get-pip.py
RUN pip install packaging

COPY --from=ninja /opt/ninja /usr/local/
COPY --from=cmake /opt/cmake /usr/local/
COPY --from=ccache /opt/ccache /
COPY --from=gcc /opt/gcc /
RUN ldconfig /usr/local/lib64

FROM deploy AS test
COPY test.bash /
RUN /test.bash

FROM deploy
