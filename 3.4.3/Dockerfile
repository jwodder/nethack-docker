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

RUN wget -O - https://www.nethack.org/download/3.4.3/nethack-343-src.tgz | \
        tar zxv -C /tmp && \
        cd /tmp/nethack-3.4.3 && \
        sh sys/unix/setup.sh && \
        sed -i -e 's/^# *define WIZARD \+"wizard"/#define WIZARD "root"/' \
               include/config.h && \
        sed -i -e 's:/\* \(#define LINUX\) \*/:\1:' \
               -e 's:/\* \(#define VAR_PLAYGROUND\) "[^"]\+" \*/:\1 "/data":' \
               -e 's:/\* \(#define NO_FILE_LINKS\) \*/:\1:' \
               -e 's:/\* \(#define LOCKDIR "[^"]\+"\) \*/:\1:' \
               include/unixconf.h && \
        sed -i -e '/^WINTTYLIB/s/=.*/= -lncurses/' src/Makefile && \
        sed -i -e '/^MANDIR/s:=.*:= /usr/share/man/man6:' doc/Makefile && \
        sed -i -e '/^VARDIR/s:=.*:= /data:' \
               -e '/^\(CHOWN\|CHGRP\)/s/=.*/= true/' \
               -e '/^GAMEPERM/s/=.*/= 0755/' \
               Makefile && \
        mkdir -p /usr/share/man/man6 && \
        make all && \
        make install && \
        make manpages && \
        cd /tmp && rm -rf nethack-3.4.3

COPY nethack.sh /usr/games/nethack

ENV PATH       $PATH:/usr/games
ENV HACKPAGER  /usr/bin/less

VOLUME ["/data"]
CMD ["/usr/games/nethack"]
