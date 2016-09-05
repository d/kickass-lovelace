#!/bin/bash

set -e -u -o pipefail
set -x

_main() {
	local image_id
	time image_id=$(build_image)

	set_ccache_size
	# use global variable `container_id` because signal handlers
	container_id=$(create_container "${image_id}")
	trap 'cleanup' EXIT

	docker start "${container_id}"
	docker attach "${container_id}"
	time docker cp "${container_id}":/output/gcc.tar.gz .
}

set_ccache_size() {
	docker run --rm \
		--volume gpdbccache:/ccache \
		--env CCACHE_DIR=/ccache \
		--env CCACHE_UMASK=0000 \
		yolo/orcadev:centos5 \
		ccache -M 8G
}

build_image() {
	docker build --quiet .
}

cleanup() {
	docker rm --force "${container_id}"
}

create_container() {
	docker create -ti \
		--volume gpdbccache:/ccache \
		--volume ~/src/pvtl/kickass-lovelace:/kickass-lovelace:ro \
		--env CCACHE_DIR=/ccache \
		--env CCACHE_UMASK=0000 \
		"${image_id}" \
		/kickass-lovelace/orcadev/gcc5/build-gcc.bash
}

_main "$@"
