FROM centos:5
ADD libc.conf /etc/ld.so.conf.d/libc.conf
RUN yum install -y epel-release
RUN yum install -y git vim-enhanced nano make gcc-c++ gdb wget libidn.x86_64 patch
RUN wget --no-check-certificate https://cmake.org/files/v3.6/cmake-3.6.0-Linux-x86_64.sh --output-document /dev/shm/cmake-installer.sh && \
    sh /dev/shm/cmake-installer.sh --prefix=/usr/local --exclude-subdir
RUN yum install -y \
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

RUN yum install -y gpg
# https://gcc.gnu.org/mirrors.html
RUN set -ex \
	&& for key in \
	B215C1633BCA0477615F1B35A5B3A004745C015A \
	B3C42148A44E6983B3E4CC0793FA9B1AB75C61B8 \
	90AA470469D3965A87A5DCB494D03953902C9419 \
	80F98B2E0DAB6C8281BDF541A7C8C3B2F71EDF1C \
	7F74F97C103468EE5D750B583AB00996FC26A641 \
	33C235A34C46AA3FFB293709A328C3A2C3C45C06; do \
		gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
	done

# "download_prerequisites" pulls down a bunch of tarballs and extracts them,
# but then leaves the tarballs themselves lying around
RUN buildDeps='flex' GCC_VERSION=6.1.0 \
	&& set -ex \
	&& yum install -y $buildDeps \
	&& curl -fSL "http://ftpmirror.gnu.org/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.bz2" -o gcc.tar.bz2 \
	&& curl -fSL "http://ftpmirror.gnu.org/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.bz2.sig" -o gcc.tar.bz2.sig \
	&& gpg --batch --verify gcc.tar.bz2.sig gcc.tar.bz2 \
	&& mkdir -p /usr/src/gcc \
	&& tar -xf gcc.tar.bz2 -C /usr/src/gcc --strip-components=1 \
	&& rm gcc.tar.bz2* \
	&& cd /usr/src/gcc \
	&& ./contrib/download_prerequisites \
	&& { rm *.tar.* || true; } \
	&& dir="$(mktemp -d)" \
	&& cd "$dir" \
	&& /usr/src/gcc/configure \
		--disable-multilib \
		--enable-languages=c,c++ \
	&& make -j16 \
	&& make install-strip \
	&& cd .. \
	&& rm -rf "$dir"

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
	&& make -j16 \
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
