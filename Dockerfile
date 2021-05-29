FROM ubuntu:hirsute
RUN apt update

MAINTAINER Gacel

# ------------------------------------------------------------
# Dowloading dependencies."
# ------------------------------------------------------------

RUN apt -y install gcc-mingw-w64-x86-64
RUN apt -y install golang-1.16

ENV PATH=$PATH:/usr/lib/go-1.16/bin

# Install MC
RUN apt -y install mc
RUN apt update

# GOlang envs.
ENV PATH=$PATH:/usr/lib/go-1.15/bin

CMD /bin/bash
