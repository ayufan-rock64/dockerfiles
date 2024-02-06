ARG DOCKER_ARCH=
ARG DEBIAN_VERSION=
FROM ${DOCKER_ARCH}debian:${DEBIAN_VERSION}

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
    python3-distutils python3-dev python3-pip python3-pyelftools \
    eatmydata debhelper libelf-dev && \
    ( \
        ( \
            . /etc/os-release && \
            echo deb http://deb.debian.org/debian $(echo "$VERSION_CODENAME")-backports main >> /etc/apt/sources.list.d/backports.list && \
            apt-get update -y && \
            apt-get install -y -t $(echo "$VERSION_CODENAME")-backports golang-go \
        ) || true \
    ) && \
    apt-get autoclean

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -y && \
    apt install -y uuid-dev libgnutls28-dev fdisk gdisk cmake libftdi1-dev libpopt-dev libncurses-dev zstd pv moreutils && \
    apt-get autoclean

ENV USER=root \
    HOME=/root \
    GOPATH=/go \
    PATH=$PATH:/go/bin

RUN git config --system user.email "you@rock64" && \
    git config --system user.name "ROCK64 Shell" && \
    git config --system --add safe.directory "*"

RUN gem install fpm

RUN ( \
        . /etc/os-release && \
        echo deb http://deb.debian.org/debian $(echo "$VERSION_CODENAME")-backports main >> /etc/apt/sources.list.d/backports.list && \
        apt-get update -y && \
        apt-get install -y -t $(echo "$VERSION_CODENAME")-backports golang-go \
    ) || true

RUN go install github.com/github-release/github-release@v0.10.0 && \
    which github-release

RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo && \
    chmod +x /usr/local/bin/repo

RUN git clone https://github.com/linux-rockchip/rkflashtool.git && \
    make -C rkflashtool install && \
    rm -rf rkflashtool

RUN git clone https://github.com/rockchip-linux/rkdeveloptool && \
    cd rkdeveloptool && \
    autoreconf -i && \
    export CXXFLAGS=-Wno-error=format-truncation && \
    ./configure && \
    make install && \
    cd .. && \
    rm -rf rkdeveloptool

RUN git clone https://github.com/Badger-Embedded/badgerd-sdwirec.git && \
    cd badgerd-sdwirec/sdwirec-sw && \
    cmake . && \
    make install && \
    cd ../.. && \
    rm -rf badgerd-sdwirec

ENV LD_LIBRARY_PATH=/usr/aarch64-linux-gnu/lib:$LD_LIBRARY_PATH

# Enable passwordless sudo for users under the "sudo" group
RUN sed -i -e \
      's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' \
      /etc/sudoers
