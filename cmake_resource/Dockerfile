FROM alpine
RUN apk update
RUN apk add \
	bash \
	coreutils \
	openssl \
	gnupg

ADD check /opt/resource/check
ADD in /opt/resource/in
