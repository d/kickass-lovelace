FROM centos:5
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
		--enable-unicode=ucs4 \
	&& make -j8 install \
	&& curl -fSL 'https://bootstrap.pypa.io/get-pip.py' | python2 \
	&& pip install --no-cache-dir --upgrade pip \
	&& find /usr/local -depth \
		\( \
		    \( -type d -a -name test -o -name tests \) \
		    -o \
		    \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
		\) -exec rm -rf '{}' + \
	&& rm -rf /usr/src/python ~/.cache

RUN set -exuo pipefail \
	&& VERSION=3.3.1 \
	&& curl -fSL "https://www.samba.org/ftp/ccache/ccache-${VERSION}.tar.bz2" -o /tmp/ccache.tar.bz2 \
	&& mkdir -p /usr/src/ccache \
	&& tar xf /tmp/ccache.tar.bz2 --strip-components=1 -C /usr/src/ccache \
	&& mkdir -p /build/ccache \
	&& cd /build/ccache \
	&& /usr/src/ccache/configure \
	&& make -j8 install \
	&& cd / \
	&& rm -r /build/ccache /usr/src/ccache /tmp/ccache.tar.bz2

RUN wget https://github.com/ninja-build/ninja/releases/download/v1.7.1/ninja-linux.zip --output-document /tmp/ninja-linux.zip \
	&& unzip /tmp/ninja-linux.zip -d /usr/local/bin \
	&& rm /tmp/ninja-linux.zip


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

# Signing key for binutils and coreutils
RUN gpg --keyserver keys.gnupg.net --recv-keys 4AE55E93 306037D9

RUN set -exuo pipefail \
	&& VERSION=2.26 \
	&& curl -fS "http://ftp.gnu.org/gnu/binutils/binutils-${VERSION}.tar.gz" -o binutils.tar.gz \
	&& curl -fS "http://ftp.gnu.org/gnu/binutils/binutils-${VERSION}.tar.gz.sig" -o binutils.tar.gz.sig \
	&& gpg --batch --verify binutils.tar.gz.sig binutils.tar.gz \
	&& mkdir -p /usr/src/binutils \
	&& tar xf binutils.tar.gz -C /usr/src/binutils --strip-components=1 \
	&& BUILD="$(mktemp -d)" \
	&& pushd "${BUILD}" \
	&& /usr/src/binutils/configure \
	&& make -j16 \
	&& make install \
	&& rm -r /usr/src/binutils \
	&& popd \
	&& rm binutils.tar.gz{,.sig} \
	&& rm -r "${BUILD}"

RUN set -exuo pipefail \
	&& VERSION=8.25 \
	&& curl -fS "http://ftp.gnu.org/gnu/coreutils/coreutils-${VERSION}.tar.xz" -o coreutils.tar.xz \
	&& curl -fS "http://ftp.gnu.org/gnu/coreutils/coreutils-${VERSION}.tar.xz.sig" -o coreutils.tar.xz.sig \
	&& gpg --batch --verify coreutils.tar.xz.sig coreutils.tar.xz \
	&& mkdir -p /usr/src/coreutils \
	&& xzcat coreutils.tar.xz | tar x -C /usr/src/coreutils --strip-components=1 \
	&& BUILD="$(mktemp -d)" \
	&& pushd "${BUILD}" \
	&& env FORCE_UNSAFE_CONFIGURE=1 /usr/src/coreutils/configure \
	&& make \
	&& make install \
	&& rm -r /usr/src/coreutils \
	&& popd \
	&& rm /coreutils.tar.xz{,.sig} \
	&& rm -r "${BUILD}"

# "download_prerequisites" pulls down a bunch of tarballs and extracts them,
# but then leaves the tarballs themselves lying around
RUN GCC_VERSION=4.9.4 \
	&& set -exuo pipefail \
	&& curl -fSL "http://ftpmirror.gnu.org/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.bz2" -o gcc.tar.bz2 \
	&& curl -fSL "http://ftpmirror.gnu.org/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.bz2.sig" -o gcc.tar.bz2.sig \
	&& gpg --batch --verify gcc.tar.bz2.sig gcc.tar.bz2 \
	&& mkdir -p /usr/src/gcc \
	&& tar -xf gcc.tar.bz2 -C /usr/src/gcc --strip-components=1 \
	&& rm gcc.tar.bz2* \
	&& pushd /usr/src/gcc \
	&& ./contrib/download_prerequisites \
	&& { rm *.tar.* || true; } \
	&& popd \
	&& dir="$(mktemp -d)" \
	&& pushd "$dir" \
	&& /usr/src/gcc/configure \
		--disable-multilib \
		--enable-languages=c,c++ \
	&& make -j"$(nproc)" \
	&& make install-strip \
	&& popd \
	&& rm -r /usr/src/gcc \
	&& rm -rf "$dir"

