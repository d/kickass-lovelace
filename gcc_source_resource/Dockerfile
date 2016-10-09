FROM alpine
RUN apk update
RUN apk add \
	bash \
	curl \
	tar \
	gnupg \
	jq
COPY in.bash /opt/resource/in
COPY check.bash /opt/resource/check
