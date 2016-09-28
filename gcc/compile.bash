#!/bin/bash

set -e -u -o pipefail
set -o posix
set -x

_main() {
	mkdir build
	mkdir staging

	build_gcc
	copy_output
}

build_gcc() {
	(
	cd build
	../gcc_source/configure \
		--disable-multilib \
		--enable-languages=c,c++ \
		--prefix "${PWD}"/../staging
	make -j8 -l16
	make install-strip
	)
}

copy_output() {
	tar cf gcc/gcc.tar.gz --use-compress-program pigz -C staging .
}

_main "$@"
