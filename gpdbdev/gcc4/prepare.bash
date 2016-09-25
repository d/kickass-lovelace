#!/bin/bash

set -e -u -o pipefail

_main() {
	local DIRECTORIES=(
		src/gpdbdev/gcc4/
		cmake
		gcc4
		ccache
	)
	unzip ninja/ninja-linux.zip -d prepared
	rsync -a "${DIRECTORIES[@]}" prepared
}

_main "$@"
