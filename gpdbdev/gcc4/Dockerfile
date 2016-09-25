FROM centos:6

RUN yum upgrade -y \
	&& yum install -y epel-release

RUN yum install -q -y \
	git \
	vim-enhanced \
	nano \
	make \
	glibc-devel \
	flex \
	bison \
	gdb \
	wget \
	patch \
	unzip \
	p7zip \
	pigz

RUN yum install -q -y \
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
	htop \
	perl-Env \
	perl-ExtUtils-Embed \
	libxml2-devel \
	libxslt-devel \
	libffi-devel \
	file

RUN set -ex \
	&& curl -fSL 'https://bootstrap.pypa.io/get-pip.py' | python2 \
	&& pip install --no-cache-dir --upgrade pip

COPY ninja /usr/local/bin/
COPY cmake ccache gcc4 /usr/local/
RUN ln -sv gcc /usr/local/bin/cc
