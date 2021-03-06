FROM ubuntu:groovy

MAINTAINER Gacel

RUN apt update

RUN echo "------------------------------------------------------------"
RUN echo "Dowloading dependencies."
RUN echo "------------------------------------------------------------"

RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata
RUN apt-get install -y --no-install-recommends gnustep gnustep-devel

RUN apt update && apt -y install \
	# optional
	vim \
	mc \
	# required for downloading external libraries
	curl \
	unzip \
	# dependencies
	git \
	musl \
	musl-dev \
	musl-tools \
	libopenal1\
	libopenal-dev  \
	libgl1-mesa-dev \
	xorg-dev  \
	libasound2-dev\
	golang-1.15-go \
	# github.com/sqweek/dialog
	gobjc \
	libcairo2-dev \
	libcairo-gobject2 \
	libglib2.0-dev \
	libgtk-3-dev\
	# cross compile for windows
	tofrodos \
	gcc-mingw-w64-i686 \
	gcc-mingw-w64-x86-64 \
	# cross compile for mac
	clang \
	lldb \
	wget \
	cmake \
	pkg-config
RUN echo ""

RUN echo "------------------------------------------------------------"
RUN echo "Dowloading OSXCross."
RUN echo "------------------------------------------------------------"
# cross compile mac dependencies
ENV OSXCROSS_SDK_VERSION 10.11
ENV OSXCROSS_SDK_URL https://github.com/apriorit/osxcross-sdks/raw/master/MacOSX${OSXCROSS_SDK_VERSION}.sdk.tar.xz

RUN ln -f -s /usr/bin/clang-11 /usr/bin/clang && ln -f -s /usr/bin/clang++-11 /usr/bin/clang++
RUN SDK_VERSION=$OSXCROSS_SDK_VERSION \
	mkdir /opt/osxcross && \
	cd /opt && \
	git clone https://github.com/tpoechtrager/osxcross.git && \
	cd osxcross && \
	./tools/get_dependencies.sh \
	&& curl -L -o ./tarballs/MacOSX${OSXCROSS_SDK_VERSION}.sdk.tar.xz \
	${OSXCROSS_SDK_URL} \
	&& yes | PORTABLE=true ./build.sh && \
	./build_compiler_rt.sh
RUN echo ""

RUN echo "------------------------------------------------------------"
RUN echo "Configuring environment variables."
RUN echo "------------------------------------------------------------"

RUN ld-musl-config

# GOlang envs.
ENV PATH=$PATH:/usr/lib/go-1.15/bin
ENV CGO_ENABLED=1

# MacOS cross compile envs.
# ENV GOOS=darwin
# ENV GOARCH=amd64
# ENV CC=o64-clang 
# ENV CXX=o64-clang++
ENV PATH=$PATH:/opt/osxcross/target/bin
ENV PATH=$PATH:/opt/osxcross/target/SDK/MacOSX${OSXCROSS_SDK_VERSION}.sdk/usr/include
ENV PATH=$PATH:/opt/osxcross/target/SDK/MacOSX${OSXCROSS_SDK_VERSION}.sdk/usr

# Windows crosscompile envs.
# export CC=x86_64-w64-mingw32-gcc
# export CXX=x86_64-w64-mingw32-g++
CMD /bin/bash

RUN echo ""
RUN echo "------------------------------------------------------------"
RUN echo "Finished! =)"
RUN echo "------------------------------------------------------------"
