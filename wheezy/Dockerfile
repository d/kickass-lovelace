FROM debian:wheezy
RUN apt-get update
RUN apt-get install -y build-essential g++ git gdb vim nano wget
RUN wget https://cmake.org/files/v3.4/cmake-3.4.0-Linux-x86_64.sh --output-document /dev/shm/cmake-installer.sh && \
    sh /dev/shm/cmake-installer.sh --prefix=/usr/local --exclude-subdir
