FROM centos:5
RUN yum upgrade -q -y \
	&& yum install -q -y epel-release
RUN yum install -q -y \
	gnupg \
	make \
	gcc \
	zlib-devel \
	bzip2

COPY check in /opt/resource/

