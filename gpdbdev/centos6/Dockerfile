FROM centos:6
RUN yum upgrade -y \
	&& yum install -y epel-release
RUN yum install -q -y git vim-enhanced nano make gcc-c++ flex bison gdb wget libidn.x86_64 patch gpg ccache

RUN gpg --keyserver keys.gnupg.net --recv-keys 7BFB4EDA
RUN VERSION=3.6.1 \
	&& set -euxo pipefail \
	&& wget --no-verbose --directory-prefix /dev/shm http://cmake.org/files/v${VERSION%.*}/cmake-${VERSION}-{SHA-256.txt{,.asc},Linux-x86_64.sh} \
	&& ( \
		cd /dev/shm \
		&& gpg --verify cmake-${VERSION}-SHA-256.txt{.asc,} \
		&& fgrep cmake-${VERSION}-Linux-x86_64.sh cmake-${VERSION}-SHA-256.txt | sha256sum --check - \
	) \
	&& sh /dev/shm/cmake-${VERSION}-Linux-x86_64.sh --prefix=/usr/local --exclude-subdir

RUN yum install -q -y \
	sudo \
	passwd \
	openssh-server \
	ed \
	readline-devel \
	zlib-devel \
	curl-devel \
	bzip2-devel \
	python-devel \
	apr-devel \
	libevent-devel \
	openssl-libs \
	openssl-devel \
	libyaml \
	libyaml-devel \
	epel-release \
	htop \
	perl-Env \
	perl-ExtUtils-Embed \
	libxml2-devel \
	libxslt-devel \
	libffi-devel \
	file

# gpg: key 18ADD4FF: public key "Benjamin Peterson <benjamin@python.org>" imported
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys C01E1CAD5EA2C4F0B8E3571504C367C218ADD4FF

RUN set -ex \
	&& curl -fSL 'https://bootstrap.pypa.io/get-pip.py' | python2 \
	&& pip install --no-cache-dir --upgrade pip

RUN pip install \
	psutil \
	lockfile \
	paramiko \
	epydoc

