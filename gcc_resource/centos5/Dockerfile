FROM centos:5

RUN yum upgrade -q -y \
	&& yum install -q -y epel-release

RUN yum install -q -y \
	gnupg \
	wget \
	gcc-c++ \
	make \
	bzip2 \
	xz

COPY in check /opt/resource/
