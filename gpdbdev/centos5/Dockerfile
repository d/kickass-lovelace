FROM centos:5
RUN yum install -y epel-release
RUN yum install -y git vim nano make gcc-c++ gdb wget libidn.x86_64 patch
RUN wget --no-check-certificate https://cmake.org/files/v3.6/cmake-3.6.0-Linux-x86_64.sh --output-document /dev/shm/cmake-installer.sh && \
    sh /dev/shm/cmake-installer.sh --prefix=/usr/local --exclude-subdir
RUN yum install -y \
	sudo \
	passwd \
	openssh-server \
	ed \
	readline-devel \
	zlib-devel \
	curl-devel \
	bzip2-devel \
	python-devel \
	apr-devel \
	libevent-devel \
	openssl-libs \
	openssl-devel \
	libyaml \
	libyaml-devel \
	epel-release \
	htop \
	perl-Env \
	perl-ExtUtils-Embed \
	libxml2-devel \
	libxslt-devel \
	libffi-devel
