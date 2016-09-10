#!/bin/bash

set -e -u -o pipefail
set -x

_main() {
	# use global variable `container_id` because signal handlers
	container_id=$(create_container)
	trap 'cleanup' EXIT
	docker start "${container_id}"

	trap 'print_log' ERR
	time wait_for_build
	trap - ERR

	time docker cp "${container_id}":/output/coreutils.tar.xz .
}

wait_for_build() {
	local -i exit_status
	exit_status=$(docker wait "${container_id}")
	return "${exit_status}"
}

print_log() {
	docker logs "${container_id}"
}

cleanup() {
	docker rm --force "${container_id}"
}

create_container() {
	docker create \
		--volume gpdbccache:/ccache \
		--volume ~/src/pvtl/kickass-lovelace:/kickass-lovelace:ro \
		--env CCACHE_DIR=/ccache \
		--env CCACHE_UMASK=0000 \
		yolo/orcadev:centos5 \
		/kickass-lovelace/orcadev/gcc4/build-coreutils.bash
}

_main "$@"
