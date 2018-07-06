FROM arm64v8/ubuntu:bionic

RUN apt-get update -y && \
    apt-get install -y python git-core gnupg flex bison gperf build-essential \
    zip curl zlib1g-dev rsync \
    libncurses5-dev ccache \
    libgl1-mesa-dev libxml2-utils xsltproc unzip mtools u-boot-tools \
    htop iotop sysstat iftop pigz bc device-tree-compiler lunzip \
    dosfstools sudo cpio nano vim kmod kpartx wget bsdtar \
    pxz ruby-dev debootstrap multistrap libssl-dev parted \
    live-build linaro-image-tools jq locales \
    gawk swig libpython-dev libusb-1.0-0-dev \
    pkg-config autoconf golang-go \
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

RUN apt-get install -y libffi-dev
RUN gem install fpm
RUN go get github.com/aktau/github-release

RUN which github-release

# Enable passwordless sudo for users under the "sudo" group
RUN sed -i -e \
      's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' \
      /etc/sudoers
