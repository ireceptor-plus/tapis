FROM ubuntu:20.04

LABEL maintainer="iReceptorPlus"

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y --fix-missing \
    git \
    python3 \
    python3-pip \
    python3-sphinx \
    python3-scipy \
    libyaml-dev \
    r-base \
    r-base-dev \
    wget \
    curl \
    jq \
    bsdmainutils

RUN pip3 install \
    pandas \
    biopython \
    matplotlib \
    airr==v1.3.1

# Tapis CLI
RUN cd / && git clone https://github.com/TACC-Cloud/tapis-cli.git
RUN cd /tapis-cli && pip3 install --upgrade .

# old-style Agave CLI
RUN cd / && git clone https://github.com/vdjserver/agave-cli.git
ENV PATH /agave-cli/bin:$PATH

# Copy source
RUN mkdir /irplus-tapis
COPY . /irplus-tapis

