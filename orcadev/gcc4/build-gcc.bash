#!/bin/bash

set -e -u -o pipefail
set -x

build_gcc() {
	local BUILD
	BUILD="/build/gcc"
	mkdir -p "${BUILD}"
	pushd "${BUILD}"

	env CC='ccache cc' CXX='ccache c++' \
		/usr/src/gcc/configure \
		--prefix=/opt/gcc \
		--disable-multilib \
		--enable-languages=c,c++
	make -j4
	env CC='ccache cc' CXX='ccache c++' make install-strip
	rm -r /usr/src/gcc
	rm /gcc.tar.bz2{,.sig}
	rm -r "${BUILD}"
	popd
}

prepare_source() {
	curl -fS "http://ftp.gnu.org/gnu/gcc/gcc-${VERSION}/gcc-${VERSION}.tar.bz2" -o gcc.tar.bz2
	curl -fS "http://ftp.gnu.org/gnu/gcc/gcc-${VERSION}/gcc-${VERSION}.tar.bz2.sig" -o gcc.tar.bz2.sig
	gpg --batch --verify gcc.tar.bz2.sig gcc.tar.bz2
	mkdir -p /usr/src/gcc
	pushd /usr/src/gcc
	tar xf /gcc.tar.bz2 -C /usr/src/gcc --strip-components=1
	./contrib/download_prerequisites
	popd
}

fetch_signing_keys() {
	# https://gcc.gnu.org/mirrors.html
	local keys=(
		B215C1633BCA0477615F1B35A5B3A004745C015A
		B3C42148A44E6983B3E4CC0793FA9B1AB75C61B8
		90AA470469D3965A87A5DCB494D03953902C9419
		80F98B2E0DAB6C8281BDF541A7C8C3B2F71EDF1C
		7F74F97C103468EE5D750B583AB00996FC26A641
		33C235A34C46AA3FFB293709A328C3A2C3C45C06
	)
	for key in "${keys[@]}"; do
		gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"
	done
}

_main() {
	local -r VERSION=4.9.4
	fetch_signing_keys

	time prepare_source
	time build_gcc "${VERSION}"
	time copy_output
}

copy_output() {
	mkdir -p /output
	tar cf /output/gcc.tar.gz --use-compress-program pigz -C /opt/gcc .
}

_main "$@"
