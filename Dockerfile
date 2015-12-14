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

RUN wget -O - http://sourceforge.net/projects/nethack/files/nethack/3.4.3/nethack-343-src.tgz | \
	tar zxv -C /tmp && \
	cd /tmp/nethack-3.4.3 && \
	sh sys/unix/setup.sh && \
	sed -i -e 's:/\* \(#define LINUX\) \*/:\1:' include/unixconf.h && \
	sed -i -e '/^WINTTYLIB/s/=.*/= -lncurses/' src/Makefile && \
	sed -i -e '/^MANDIR/s:=.*:= /usr/share/man/man6:' doc/Makefile && \
	mkdir -p /usr/share/man/man6 && \
	make all && \
	make install && \
	make manpages && \
	cd /tmp && rm -rf nethack-3.4.3

ENV PATH       $PATH:/usr/games
ENV HACKPAGER  /usr/bin/less

# `/root` seems to have special protections that keep NetHack from reading any
# config files in it, so we'll create a user account whose files NetHack _can_
# read.
RUN useradd -d /home/wizard -m -U -s /bin/bash wizard
USER wizard

CMD ["/usr/games/nethack"]
