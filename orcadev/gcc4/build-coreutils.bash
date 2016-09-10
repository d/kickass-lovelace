#!/bin/bash

set -e -u -o pipefail
set -x

build_coreutils() {
	local VERSION
	VERSION=$1

	curl -fS "http://ftp.gnu.org/gnu/coreutils/coreutils-${VERSION}.tar.xz" -o coreutils.tar.xz
	curl -fS "http://ftp.gnu.org/gnu/coreutils/coreutils-${VERSION}.tar.xz.sig" -o coreutils.tar.xz.sig
	gpg --batch --verify coreutils.tar.xz.sig coreutils.tar.xz
	mkdir -p /usr/src/coreutils
	xzcat coreutils.tar.xz | tar x -C /usr/src/coreutils --strip-components=1
	BUILD="/build/coreutils"
	mkdir -p "${BUILD}"
	pushd "${BUILD}"
	env CC='ccache cc' CXX='ccache c++' FORCE_UNSAFE_CONFIGURE=1 /usr/src/coreutils/configure --prefix=/opt/coreutils
	make -j4
	make install
	rm -r /usr/src/coreutils
	popd
	rm coreutils.tar.xz{,.sig}
	rm -r "${BUILD}"
}

fetch_signing_keys() {
	# Signing key for binutils and coreutils
	gpg --keyserver keys.gnupg.net --recv-keys 4AE55E93 306037D9
}

_main() {
	local -r VERSION=8.25
	fetch_signing_keys
	time build_coreutils "${VERSION}"
	time copy_output
}

copy_output() {
	mkdir -p /output
	tar cf /output/coreutils.tar -C /opt/coreutils .
	xz --best /output/coreutils.tar
}

_main "$@"
