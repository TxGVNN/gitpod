FROM gitpod/workspace-full:commit-8fc141dbdd92030a435ead06617c6d37651d8312
USER root
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y build-essential git autoconf texinfo libgnutls28-dev libxml2-dev libncurses5-dev libjansson-dev libgccjit-9-dev libtool-bin libvterm-dev && \
    git clone https://github.com/emacs-mirror/emacs --depth 1 --branch emacs-28 /src/emacs && \
    cd /src/emacs && \
    ./autogen.sh && \
    ./configure --with-x=no --without-gsettings --with-pop=no --with-modules --with-native-compilation --with-json && \
    NATIVE_FULL_AOT=1 make -j8 && make install && \
    rm -rf /src/emacs
COPY setup.sh /usr/local/bin
COPY emcs /usr/local/bin

USER gitpod
WORKDIR /home/gitpod
ENV DOTS_VERSION=3548d5e11900f9b3d467893f619c47c65eac08bc
RUN DEBIAN_FRONTEND=noninteractive sudo apt-get install -y ripgrep global screen tmux tmate socat zip dtach dropbear rsync git-crypt && \
    curl https://raw.githubusercontent.com/TxGVNN/dots/${DOTS_VERSION}/.bashrc >> .bashrc && \
    wget https://raw.githubusercontent.com/TxGVNN/dots/${DOTS_VERSION}/.screenrc && \
    wget https://raw.githubusercontent.com/TxGVNN/dots/${DOTS_VERSION}/.emacs && \
    emacs -q --batch -l ~/.emacs && \
    echo "(setq warning-suppress-types '((comp)))" > ~/.emacs.d/personal.el
