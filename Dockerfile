# Use a modern and supported Debian base image for 2024
FROM debian:bookworm-slim

# Set environment variables for non-interactive apt commands
ENV DEBIAN_FRONTEND=noninteractive

# Ensure the sources.list file exists and update it
RUN [ -f /etc/apt/sources.list ] || echo 'deb http://deb.debian.org/debian bookworm main' > /etc/apt/sources.list && \
    sed -i 's|http://deb.debian.org/debian|mirror://mirrors.debian.org/debian|' /etc/apt/sources.list

# Install dependencies
RUN apt update && \
    apt install -y --no-install-recommends \
        build-essential \
        qtbase5-dev \
        libboost-all-dev \
        libfftw3-dev \
        libavutil-dev \
        libavresample-dev \
        libavcodec-dev \
        libavformat-dev

# Ensure curl is installed for downloading purposes (optional if needed later)
RUN apt update && apt install -y curl && apt clean && rm -rf /var/lib/apt/lists/*

# install libKeyFinder
RUN cd /tmp && \
    git clone https://github.com/ibsh/libKeyFinder.git && \
    cd libKeyFinder && \
    qmake LibKeyFinder.pro && \
    make && \
    make install && \
    rm -rf /tmp/libKeyFinder

# install keyfinder-cli
RUN cd /tmp && \
    git clone https://github.com/EvanPurkhiser/keyfinder-cli.git && \
    cd keyfinder-cli && \
    make && make install

COPY entrypoint.sh /usr/local/bin/entrypoint
COPY test-files /test
COPY test.sh /test.sh

ENTRYPOINT ["entrypoint"]
