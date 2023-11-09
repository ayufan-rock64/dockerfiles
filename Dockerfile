ARG DOCKER_ARCH=
FROM ${DOCKER_ARCH}debian:bookworm

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -y && \
    apt-get install -y git-core gnupg flex bison gperf build-essential \
    zip curl zlib1g-dev rsync ccache \
    libgl1-mesa-dev libxml2-utils xsltproc unzip mtools u-boot-tools \
    htop iotop sysstat iftop pigz bc device-tree-compiler lunzip \
    dosfstools gcc-aarch64-linux-gnu g++-aarch64-linux-gnu \
    gcc-arm-linux-gnueabi g++-arm-linux-gnueabi ccache \
    sudo cpio nano vim kmod kpartx wget libarchive-tools qemu-user-static \
    xz-utils ruby-dev debootstrap multistrap libssl-dev parted \
    live-build jq locales \
    gawk swig libusb-1.0-0-dev \
    pkg-config autoconf golang-go \
    python3-distutils python3-dev \
    eatmydata && \
    apt-get autoclean

RUN locale-gen en_US.UTF-8

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    USER=root \
    HOME=/root \
    GOPATH=/go \
    PATH=$PATH:/go/bin

RUN git config --global user.email "you@rock64" && \
    git config --global user.name "ROCK64 Shell"

RUN gem install fpm

RUN go install github.com/github-release/github-release@v0.10.0 && \
    which github-release

RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo && \
    chmod +x /usr/local/bin/repo

# Missing?
# RUN git clone https://github.com/rockchip-linux/rkflashtool && \
#     make -C rkflashtool install && \
#     rm -rf rkflashtool

RUN git clone https://github.com/rockchip-linux/rkdeveloptool && \
    cd rkdeveloptool && \
    autoreconf -i && \
    export CXXFLAGS=-Wno-error=format-truncation && \
    ./configure && \
    make install && \
    cd .. && \
    rm -rf rkdeveloptool

ENV LD_LIBRARY_PATH=/usr/aarch64-linux-gnu/lib:$LD_LIBRARY_PATH

# Enable passwordless sudo for users under the "sudo" group
RUN sed -i -e \
      's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' \
      /etc/sudoers
