#!/bin/bash

_main() {
	local -a SHELLCHECK_OPTS
	SHELLCHECK_OPTS=("$@")

	shell_scripts | xargs shellcheck "${SHELLCHECK_OPTS[@]}"
}

shell_scripts() {
	find . -name '*.bash' -perm -001
	find . -name 'in' -or -name 'check' -or -name 'out' -perm -001
}

_main "$@"
