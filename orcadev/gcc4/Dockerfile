FROM centos:5
RUN yum upgrade -q -y \
	&& yum install -q -y epel-release
RUN yum install -q -y \
	glibc-devel \
	git \
	vim-enhanced \
	nano \
	make \
	gdb \
	wget \
	patch \
	zlib-devel \
	openssl-devel \
	bzip2 \
	xz \
	unzip \
	p7zip \
	pigz

COPY ninja /usr/local/bin/
COPY cmake python ccache gcc4 /usr/local/
