#!/bin/bash

set -e -u -o pipefail

_main() {
	local STDOUT
	exec {STDOUT}>&1
	exec 1>&2

	local destination
	destination=$1

	load_gcc_signing_keys

	# "download_prerequisites" pulls down a bunch of tarballs and extracts them,
	# but then leaves the tarballs themselves lying around
	local GCC_VERSION=4.9.4

	curl -fSL "http://ftpmirror.gnu.org/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.bz2" -o gcc.tar.bz2
	curl -fSL "http://ftpmirror.gnu.org/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.bz2.sig" -o gcc.tar.bz2.sig
	gpg --batch --verify gcc.tar.bz2.sig gcc.tar.bz2
	tar -xf gcc.tar.bz2 -C "${destination}" --strip-components=1
	pushd "${destination}"
	./contrib/download_prerequisites
	popd

	cat >&${STDOUT} <<METADATA
	{
		"version": {
			"version": "${GCC_VERSION}"
		}
	}
METADATA
}

load_gcc_signing_keys() {
	# https://gcc.gnu.org/mirrors.html
	local GCC_KEYS=(
	B215C1633BCA0477615F1B35A5B3A004745C015A
	B3C42148A44E6983B3E4CC0793FA9B1AB75C61B8
	90AA470469D3965A87A5DCB494D03953902C9419
	80F98B2E0DAB6C8281BDF541A7C8C3B2F71EDF1C
	7F74F97C103468EE5D750B583AB00996FC26A641
	33C235A34C46AA3FFB293709A328C3A2C3C45C06
	)
	for key in "${GCC_KEYS[@]}"; do
		gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"
	done
}

_main "$@"
