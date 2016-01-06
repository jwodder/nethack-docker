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

COPY docker.hints /tmp/docker.hints

RUN wget -O - http://downloads.sourceforge.net/project/nethack/nethack/3.6.0/nethack-360-src.tgz | \
	tar zxv -C /tmp && \
	cd /tmp/nethack-3.6.0 && \
	mv -i /tmp/docker.hints . && \
	sh sys/unix/setup.sh docker.hints && \
	sed -i -e 's:\(#define SYSCF\>\):/* \1 */:' include/config.h && \
	sed -i -e '/^MANDIR/s:=.*:= /usr/share/man/man6:' doc/Makefile && \
	mkdir -p /usr/share/man/man6 && \
	make all && \
	make install && \
	make manpages && \
	cd /tmp && rm -rf nethack-3.6.0

COPY nethack.sh /usr/games/nethack

ENV PATH       $PATH:/usr/games
ENV HACKPAGER  /usr/bin/less

VOLUME ["/data"]
CMD ["/usr/games/nethack"]
