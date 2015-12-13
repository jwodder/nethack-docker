# cf. <https://registry.hub.docker.com/u/matsuu/nethack/dockerfile/>

FROM debian:jessie
RUN apt-get update && apt-get install -y --no-install-recommends \
			bison \
			flex \
			gcc \
			less \
			make \
			man \
			ncompress \
			ncurses-dev \
			wget

RUN wget -O - http://downloads.sourceforge.net/project/nethack/nethack/3.6.0/nethack-360-src.tgz | \
	tar zxv -C /tmp && \
	cd /tmp/nethack-3.6.0 && \
	sed -i -e '/^WINTTYLIB/s/=.*/= -lncurses/' sys/unix/hints/unix && \
	sh sys/unix/setup.sh sys/unix/hints/unix && \
	sed -i -e 's:\(#define SYSCF\>\):/* \1 */:' include/config.h && \
	sed -i -e 's:/\* \(#define LINUX\) \*/:\1:' include/unixconf.h && \
	sed -i -e '/^MANDIR/s:=.*:= /usr/share/man/man6:' doc/Makefile && \
	mkdir -p /usr/share/man/man6 && \
	make all && \
	make install && \
	make manpages && \
	cd /tmp && rm -rf nethack-3.6.0

ENV PATH       $PATH:/usr/games
ENV HACKPAGER  /usr/bin/less

# `/root` seems to have special protections that keep NetHack from reading any
# config files in it, so we'll create a user account whose files NetHack _can_
# read.
RUN useradd -d /home/wizard -m -U -s /bin/bash wizard
USER wizard

CMD ["/usr/games/nethack"]
