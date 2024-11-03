# Use a modern and supported Debian base image for 2024
FROM debian:bookworm-slim

# Set environment variables for non-interactive apt commands
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies all in one layer to reduce image size
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    ca-certificates \
    libfftw3-dev \
    ffmpeg \
    libavcodec-dev \
    libavformat-dev \
    libavutil-dev \
    libswresample-dev \
    && rm -rf /var/lib/apt/lists/*

# Install libkeyfinder from the Mixxx DJ maintained version
WORKDIR /tmp
RUN git clone https://github.com/mixxxdj/libkeyfinder.git && \
    cd libkeyfinder && \
    git checkout 2.2.8 && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr -DBUILD_TESTING=OFF -S . -B build && \
    cmake --build build --parallel "$(nproc)" && \
    cmake --install build && \
    cd .. && \
    rm -rf libkeyfinder

# Install keyfinder-cli
RUN git clone https://github.com/evanpurkhiser/keyfinder-cli.git && \
    cd keyfinder-cli && \
    make && \
    make PREFIX=/usr install && \
    cd .. && \
    rm -rf keyfinder-cli

# Create working directory for audio files
WORKDIR /audio

# Set the entrypoint to keyfinder-cli
ENTRYPOINT ["keyfinder-cli"]
# Default command (can be overridden)
CMD ["--help"]