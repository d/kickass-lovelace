#!/bin/bash

set -e -u -o pipefail

_main() {
	it_has_gcc4

	it_has_modern_cmake

	it_has_python27

	it_has_ninja_17

	it_has_executables
}

it_has_gcc4() {
	gcc --version | fgrep --quiet 4.9.4
	g++ --version | fgrep --quiet 4.9.4
}

it_has_modern_cmake() {
	cmake --version | fgrep --quiet 3.6.1
}

it_has_ninja_17() {
	[ "$(ninja --version)" = "1.7.1" ]
}

it_has_python27() {
	[[ "$(python --version 2>&1)" == Python\ 2.7.12 ]]
}

it_has_executables() {
	local EXECUTABLES=(
		gpg
		vim
		make
		patch
		bzip2
		xz
		unzip
		p7zip
		pigz
		wget
	)
}

_main "$@"
