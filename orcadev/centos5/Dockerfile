FROM centos:5
ADD libc.conf /etc/ld.so.conf.d/libc.conf
RUN yum upgrade -q -y \
	&& yum install -q -y epel-release
RUN yum install -q -y \
	glibc-static \
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
	ccache \
	unzip \
	p7zip \
	pigz

RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 7BFB4EDA
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


# gpg: key 18ADD4FF: public key "Benjamin Peterson <benjamin@python.org>" imported
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys C01E1CAD5EA2C4F0B8E3571504C367C218ADD4FF

RUN set -ex \
	&& PYTHON_VERSION=2.7.12 \
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
	&& make -j8 install \
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

RUN wget https://github.com/ninja-build/ninja/releases/download/v1.7.1/ninja-linux.zip --output-document /tmp/ninja-linux.zip \
	&& unzip /tmp/ninja-linux.zip -d /usr/local/bin
