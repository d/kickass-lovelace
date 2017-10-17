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
ENV VERSION=3.6.1
ENV INSTALLER=cmake-${VERSION}-Linux-x86_64.sh
ENV CHECKSUM=cmake-${VERSION}-SHA-256.txt
RUN wget --no-verbose --no-check-certificate --directory-prefix / http://cmake.org/files/v${VERSION%.*}/{${INSTALLER},${CHECKSUM}{,.asc}}
WORKDIR /
RUN gpg --verify ${CHECKSUM}{.asc,}
RUN fgrep ${INSTALLER} ${CHECKSUM} | sha256sum --check -
RUN mkdir /opt/cmake
RUN sh ./${INSTALLER} --prefix=/opt/cmake --exclude-subdir

FROM base AS ninja
RUN wget https://github.com/ninja-build/ninja/releases/download/v1.7.1/ninja-linux.zip --output-document /tmp/ninja-linux.zip
RUN mkdir -vp /opt/ninja/bin
RUN unzip /tmp/ninja-linux.zip -d /opt/ninja/bin

FROM base AS toolchain
RUN yum install -q -y \
	git \
	vim-enhanced \
	nano \
	make \
	gcc-c++ \
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


FROM ubuntu AS pip
RUN apt-get update -q
RUN apt-get install -y wget
RUN mkdir /opt/pip
RUN wget 'https://bootstrap.pypa.io/get-pip.py' --output-document /opt/pip/get-pip.py

FROM toolchain AS python
# gpg: key 18ADD4FF: public key "Benjamin Peterson <benjamin@python.org>" imported
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys C01E1CAD5EA2C4F0B8E3571504C367C218ADD4FF
ENV PYTHON_VERSION=2.7.12
RUN curl -fSL "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tgz" -o python.tgz
RUN curl -fSL "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tgz.asc" -o python.tgz.asc
RUN gpg --batch --verify python.tgz.asc python.tgz
RUN rm -r python.tgz.asc
RUN mkdir -p /usr/src/python
RUN tar -xC /usr/src/python --strip-components=1 -f python.tgz
RUN rm python.tgz
WORKDIR /usr/src/python
RUN ./configure \
	--enable-unicode=ucs4
RUN make -j8 install DESTDIR=/opt/python

FROM toolchain AS ccache
ENV VERSION=3.3.1
RUN curl -fSL "https://www.samba.org/ftp/ccache/ccache-${VERSION}.tar.bz2" -o /tmp/ccache.tar.bz2
RUN mkdir -p /usr/src/ccache
RUN tar xf /tmp/ccache.tar.bz2 --strip-components=1 -C /usr/src/ccache
RUN mkdir -p /build/ccache
WORKDIR /build/ccache
RUN mkdir /opt/ccache
RUN /usr/src/ccache/configure
RUN make -j8 install DESTDIR=/opt/ccache

FROM toolchain
WORKDIR /
COPY --from=ninja /opt/ninja /usr/local/
COPY --from=cmake /opt/cmake /usr/local/
COPY --from=python /opt/python /
COPY --from=ccache /opt/ccache /
COPY --from=pip /opt/pip/get-pip.py /opt
RUN python2 /opt/get-pip.py
