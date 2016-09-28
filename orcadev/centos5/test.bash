#!/bin/bash

set -e -u -o pipefail
set -x

_main() {
	it_has_gcc

	it_has_libc_objects

	it_has_modern_cmake

	it_has_modern_ccache

	it_has_python27

	it_has_ninja_17

	it_has_executables
}

it_has_gcc() {
	type -p gcc
	type -p g++
	type -p cc
	type -p c++
}

it_has_libc_objects() {
	(
	set -e
	pushd "$(mktemp -d -t simple_compilation.XXX)"
	cat > hello.c <<HELLO
#include <string.h>
int main() { return 0; }
HELLO
	gcc -D_GNU_SOURCE -o hello hello.c
	)
}

it_has_modern_cmake() {
	cmake --version | fgrep --quiet 3.6.1
}

it_has_modern_ccache() {
	ccache --version | fgrep --quiet 'ccache version 3.3.1'
}

it_has_ninja_17() {
	[ "$(ninja --version)" = "1.7.1" ]
}

it_has_python27() {
	[[ "$(python --version 2>&1)" == Python\ 2.7.12 ]]
}

it_has_executables() {
	local EXECUTABLES=(
		vim
		make
		patch
		bzip2
		xz
		unzip
		7za
		pigz
		wget
	)
	for executable in "${EXECUTABLES[@]}"; do
		type -p "${executable}"
	done
}

_main "$@"