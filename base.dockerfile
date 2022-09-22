# This is the only version of Debian with official packages for both:
# * Java 8, used by the runtime tests (see javaHome in product/runtime/build.gradle).
# * Java 11, used by piptest because it's required by Android Gradle plugin 7.0 and later.
FROM debian:stretch-20210902
# RUN echo "deb http://deb.debian.org/debian stretch-backports main" >> /etc/apt/sources.list
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
COPY sources.list /etc/apt/

SHELL ["/bin/bash", "-c"]
WORKDIR /root

RUN apt-get update && \
    apt-get install -y openjdk-8-jdk-headless openjdk-11-jdk-headless unzip wget
RUN echo "progress=dot:giga" > .wgetrc

# Install the same minor Python version as Chaquopy uses.
RUN apt-get update && \
    apt-get install -y gcc libbz2-dev libffi-dev liblzma-dev libsqlite3-dev libssl-dev \
                       zlib1g-dev make

COPY Python-3.8.7.tgz /root/
RUN tar -xf Python-3.8.7.tgz && \
    cd Python-3.8.7 && \
    ./configure && \
    make -j $(nproc) && \
    make install && \
    cd .. && \
    rm -r Python-3.8.7*

COPY commandlinetools-linux-6609375_latest.zip /root/
RUN mkdir -p android-sdk/cmdline-tools && \
    unzip -q -d android-sdk/cmdline-tools commandlinetools-linux-6609375_latest.zip && \
    rm commandlinetools-linux-6609375_latest.zip
