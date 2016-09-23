FROM centos:5
RUN yum upgrade -q -y \
	&& yum install -q -y epel-release
RUN yum install -q -y \
	glibc-static \
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

COPY cmake /usr/local/
COPY python /usr/local
COPY ccache /usr/local
COPY gcc /usr/local
RUN unzip ninja/ninja-linux.zip -d /usr/local/bin
