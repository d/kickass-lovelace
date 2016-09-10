#!/bin/bash

set -e -u -o pipefail
set -x

build_binutils() {
	local VERSION
	VERSION=$1

	curl -fS "http://ftp.gnu.org/gnu/binutils/binutils-${VERSION}.tar.gz" -o binutils.tar.gz
	curl -fS "http://ftp.gnu.org/gnu/binutils/binutils-${VERSION}.tar.gz.sig" -o binutils.tar.gz.sig
	gpg --batch --verify binutils.tar.gz.sig binutils.tar.gz
	mkdir -p /usr/src/binutils
	tar xf binutils.tar.gz -C /usr/src/binutils --strip-components=1
	BUILD="/build/binutils"
	mkdir -p "${BUILD}"
	pushd "${BUILD}"
	env CC='ccache cc' CXX='ccache c++' /usr/src/binutils/configure --prefix=/opt/binutils
	make -j4
	make install
	rm -r /usr/src/binutils
	popd
	rm binutils.tar.gz{,.sig}
	rm -r "${BUILD}"
}

fetch_signing_keys() {
	# Signing key for binutils and coreutils
	gpg --keyserver keys.gnupg.net --recv-keys 4AE55E93 306037D9
}

_main() {
	local -r VERSION=2.26
	fetch_signing_keys
	time build_binutils "${VERSION}"
	time copy_output
}

copy_output() {
	mkdir -p /output
	tar cf /output/binutils.tar -C /opt/binutils .
	xz --best /output/binutils.tar
}

_main "$@"
