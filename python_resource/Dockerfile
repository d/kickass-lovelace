FROM centos:5
RUN yum upgrade -q -y \
	&& yum install -q -y epel-release
RUN yum install -q -y \
	glibc-static \
	git \
	vim-enhanced \
	nano \
	make \
	gcc-c++ \
	gdb \
	wget \
	libidn.x86_64 \
	patch \
	gpg \
	zlib-devel \
	openssl-devel \
	bzip2 \
	xz \
	ccache \
	unzip \
	p7zip \
	pigz

COPY check /opt/resource/check
COPY in /opt/resource/in
