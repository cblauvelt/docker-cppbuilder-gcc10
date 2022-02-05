FROM ubuntu:focal

ENV GCC_VERSION=10 \
    CONAN_VERSION="1.44.1" \
    CONAN_PKG_VERSION="0.37.0" \
    CMAKE_VERSION_FULL="3.22.2" \
    CC=/usr/bin/gcc \
    CXX=/usr/bin/g++ \
    DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint ignore=DL3008
RUN apt-get -qq update && apt-get -qq upgrade -y \
    && apt-get -qq install -y --no-install-recommends --no-install-suggests \
       sudo \
       binutils \
       wget \
       git \
       libc6-dev \
       g++-${GCC_VERSION} \
       libgmp-dev \
       libmpfr-dev \
       libmpc-dev \
       nasm \
       dh-autoreconf \
       ninja-build \
       libffi-dev \
       libssl-dev \
       pkg-config \
       subversion \
       zlib1g-dev \
       libbz2-dev \
       libsqlite3-dev \
       libreadline-dev \
       xz-utils \
       curl \
       libncurses5-dev \
       libncursesw5-dev \
       liblzma-dev \
       ca-certificates \
       autoconf-archive \
       python \
       pip \
    && rm -rf /var/lib/apt/lists/* \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-${GCC_VERSION} 100 \
    && update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++-${GCC_VERSION} 100 \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-${GCC_VERSION} 100 \
    && update-alternatives --install /usr/bin/cc cc /usr/bin/gcc-${GCC_VERSION} 100 \
    && ln -s /usr/include/locale.h /usr/include/xlocale.h \
    && curl -fL https://getcli.jfrog.io | sh \
    && mv jfrog /usr/local/bin/jfrog \
    && chmod +x /usr/local/bin/jfrog \
    && groupadd _1000 -g 1000 \
    && groupadd _1001 -g 1001 \
    && groupadd _2000 -g 2000 \
    && groupadd _999 -g 999 \
    && useradd -ms /bin/bash conan -g _1001 -G _1000,_2000,_999 \
    && printf "conan:conan" | chpasswd \
    && adduser conan sudo \
    && printf "conan ALL= NOPASSWD: ALL\\n" >> /etc/sudoers \
    && pip install -q --upgrade --no-cache-dir pip==22.0.2 \
    && pip install -q --no-cache-dir conan==${CONAN_VERSION} conan-package-tools==${CONAN_PKG_VERSION} cmake==${CMAKE_VERSION_FULL}

USER conan
WORKDIR /home/conan    
COPY default-profile .conan/profiles/default
