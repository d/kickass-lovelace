FROM centos:6
RUN yum upgrade -y \
	&& yum install -y epel-release
RUN yum install -q -y \
	git \
	vim-enhanced \
	nano \
	make \
	gcc-c++ \
	flex \
	bison \
	gdb \
	wget \
	libidn.x86_64 \
	patch \
	gpg \
	ccache \
	unzip

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

RUN wget https://github.com/ninja-build/ninja/releases/download/v1.7.1/ninja-linux.zip --output-document /tmp/ninja-linux.zip \
	&& unzip /tmp/ninja-linux.zip -d /usr/local/bin \
	&& rm /tmp/ninja-linux.zip
