FROM ubuntu:18.04
LABEL maintainer="marc@gsites.de"

# Base system tools
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yqq install \
    build-essential curl tzdata python-pip software-properties-common

# Add deadsnakes PPA
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update

# Install python versions
RUN DEBIAN_FRONTEND=noninteractive apt-get -yqq install \
    python2.5 python2.6 python2.7 python3.1 python3.2 python3.3 python3.4 python3.5 python3.6 python3.7

# Install simplejson for python2.5
RUN curl https://files.pythonhosted.org/packages/98/87/a7b98aa9256c8843f92878966dc3d8d914c14aad97e2c5ce4798d5743e07/simplejson-3.17.0.tar.gz | \
    tar -xvz && cd simplejson-3.17.0 && python2.5 setup.py install

# Install system-wide python tools (via pip, to get new versions)
RUN pip install -U pip tox

# Use a non-UTC timezone to catch time offset errors
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Run tests as non-root
RUN useradd -ms /bin/bash notroot
USER notroot

# Mount stuff here
VOLUME /src
WORKDIR /src
