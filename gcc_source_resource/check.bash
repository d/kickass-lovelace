#!/bin/bash

set -e -u -o pipefail

_main() {
	cat <<VERSION
[{"version": "4.9.4"}]
VERSION
}

_main "$@"
