FROM centos:6
ADD libc.conf /etc/ld.so.conf.d/libc.conf
RUN yum upgrade -y \
	&& yum install -y epel-release
RUN yum install -q -y git vim-enhanced nano make gcc-c++ flex bison gdb wget libidn.x86_64 patch gpg

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
	&& export PYTHON_VERSION=2.7.12 \
	&& curl -fSL "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tgz" -o python.tgz \
	&& curl -fSL "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tgz.asc" -o python.tgz.asc \
	&& gpg --batch --verify python.tgz.asc python.tgz \
	&& rm -r python.tgz.asc \
	&& mkdir -p /usr/src/python \
	&& tar -xC /usr/src/python --strip-components=1 -f python.tgz \
	&& rm python.tgz \
	\
	&& cd /usr/src/python \
	&& ./configure \
		--enable-shared \
		--enable-unicode=ucs4 \
	&& make -j$(nproc) \
	&& make install \
	&& ldconfig \
	&& curl -fSL 'https://bootstrap.pypa.io/get-pip.py' | python2 \
	&& pip install --no-cache-dir --upgrade pip \
	&& find /usr/local -depth \
		\( \
		    \( -type d -a -name test -o -name tests \) \
		    -o \
		    \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
		\) -exec rm -rf '{}' + \
	&& rm -rf /usr/src/python ~/.cache

RUN pip install \
	psutil \
	lockfile \
	paramiko \
	epydoc

