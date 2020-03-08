FROM debian:buster
RUN apt-get update && apt-get install -y --no-install-recommends \
                        bison \
                        ca-certificates \
                        flex \
                        gcc \
                        less \
                        make \
                        man \
                        ncompress \
                        ncurses-dev \
                        wget && \
        apt-get clean && rm -rf /var/lib/apt/lists/*

COPY docker.hints /usr/src/docker.hints

ENV NETHACK_DOWNLOAD_URL https://www.nethack.org/download/3.6.6/nethack-366-src.tgz

RUN set -x && \
        cd /usr/src && \
        mkdir nethack && \
        wget -O - "$NETHACK_DOWNLOAD_URL" | \
        tar zxv -C nethack --strip-components 1 && \
        cd nethack && \
        mv -i /usr/src/docker.hints . && \
        sh sys/unix/setup.sh docker.hints && \
        sed -i -e '/^MANDIR/s:=.*:= /usr/share/man/man6:' doc/Makefile && \
        mkdir -p /usr/share/man/man6 && \
        make all && \
        make install && \
        make manpages && \
        cd /usr/src && rm -rf nethack

COPY nethack.sh /usr/games/nethack

ENV PATH       $PATH:/usr/games
ENV HACKPAGER  /usr/bin/less

VOLUME ["/data"]
CMD ["/usr/games/nethack"]
