FROM centos:5
ADD libc.conf /etc/ld.so.conf.d/libc.conf
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
COPY cmake python ccache /usr/local/
ADD gcc4/gcc.tar.gz /usr/local
RUN /sbin/ldconfig
RUN ln -sv gcc /usr/local/bin/cc
