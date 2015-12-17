FROM debian:jessie
RUN apt-get update && apt-get install -o APT::Install-Recommends=0 \
				      -o APT::Install-Suggests=0 -y \
			bison \
			flex \
			gcc \
			less \
			make \
			man \
			ncompress \
			ncurses-dev \
			wget

RUN wget -O - http://sourceforge.net/projects/nethack/files/nethack/3.4.3/nethack-343-src.tgz | \
	tar zxv -C /tmp && \
	cd /tmp/nethack-3.4.3 && \
	sh sys/unix/setup.sh && \
	sed -i -e 's:/\* \(#define LINUX\) \*/:\1:' \
	       -e 's:/\* \(#define VAR_PLAYGROUND\) "[^"]\+" \*/:\1 "/data":' \
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
