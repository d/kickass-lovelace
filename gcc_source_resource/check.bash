#!/bin/bash

set -e -u -o pipefail

_main() {
	cat <<VERSION
[
	{"version": "4.9.4"},
	{"version": "5.4.0"},
	{"version": "6.2.0"}
]
VERSION
}

_main "$@"
