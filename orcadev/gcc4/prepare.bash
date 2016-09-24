#!/bin/bash

set -e -u -o pipefail

_main() {
	rsync -a \
		src/orcadev/gcc4/ \
		cmake \
		python \
		gcc4 \
		ninja \
		ccache \
		prepared
}

_main "$@"
