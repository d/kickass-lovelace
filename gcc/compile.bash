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
	# in newer versions of tar we would be able to use
	# --use-compress-program 'xz -T 0 --best'
	env XZ_OPT='-T 0 --best' tar cf gcc/gcc.tar.xz --use-compress-program xz -C staging .
}

_main "$@"
