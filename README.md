[NetHack](http://www.nethack.org) is a [roguelike](https://en.wikipedia.org/wiki/Roguelike) computer game in which a brave young `@` goes forth to acquire the Amulet of Yendor and dies horribly every(?) single time.  It also has [a wiki](https://nethackwiki.com).

This repository contains Docker images for the latest versions of the game, built with the basic out-of-the-box configurations (so tty graphics only, no autopickup exceptions in 3.4.3, and no status hilites in 3.6.0), with the following exceptions:

- Mutable game data (high scores, save files, etc.) is stored in the `/data` volume separately from the static data so that the former can be preserved across containers.

- `root` (the user the image runs as) can enter debug/wizard mode without having to switch to a different \*nix account.

- Support for the new sysconf mechanism in 3.6 is only enabled in the `3.6.*-sysconf` images.  This feature allows certain game parameters to be configured via the `/data/sysconf` file.  See `sys/unix/sysconf` in the NetHack 3.6.\* source distribution for more information.

Tags and Dockerfiles
--------------------
* [`3.6.5`, `3.6`, `latest`](https://github.com/jwodder/nethack-docker/blob/master/3.6.5/Dockerfile)
* [`3.6.5-sysconf`, `3.6-sysconf`, `sysconf`](https://github.com/jwodder/nethack-docker/blob/master/3.6.5-sysconf/Dockerfile)
* [`3.6.4`](https://github.com/jwodder/nethack-docker/blob/master/3.6.4/Dockerfile)
* [`3.6.4-sysconf`](https://github.com/jwodder/nethack-docker/blob/master/3.6.4-sysconf/Dockerfile)
* [`3.6.3`](https://github.com/jwodder/nethack-docker/blob/master/3.6.3/Dockerfile)
* [`3.6.3-sysconf`](https://github.com/jwodder/nethack-docker/blob/master/3.6.3-sysconf/Dockerfile)
* [`3.6.2`](https://github.com/jwodder/nethack-docker/blob/master/3.6.2/Dockerfile)
* [`3.6.2-sysconf`](https://github.com/jwodder/nethack-docker/blob/master/3.6.2-sysconf/Dockerfile)
* [`3.6.1`](https://github.com/jwodder/nethack-docker/blob/master/3.6.1/Dockerfile)
* [`3.6.1-sysconf`](https://github.com/jwodder/nethack-docker/blob/master/3.6.1-sysconf/Dockerfile)
* [`3.6.0`](https://github.com/jwodder/nethack-docker/blob/master/3.6.0/Dockerfile)
* [`3.6.0-sysconf`](https://github.com/jwodder/nethack-docker/blob/master/3.6.0-sysconf/Dockerfile)
* [`3.4.3`, `3.4`](https://github.com/jwodder/nethack-docker/blob/master/3.4.3/Dockerfile)

Setting Options
---------------
You can set NetHack options by specifying them directly in the environment variable `NETHACKOPTIONS`:

    docker run -it -e NETHACKOPTIONS="name:Rodney,disclose:+i +a +v +g +c +o" jwodder/nethack:3.6

or put the options in a `.nethackrc` file in your `/data` volume and set `NETHACKOPTIONS` to `"@<PATH TO FILE>"`:

    echo 'OPTIONS=name:Rodney,disclose:+i +a +v +g +c +o' > /path/to/my/nethack/data/.nethackrc

    docker run -it -v /path/to/my/nethack/data:/data -e NETHACKOPTIONS="@/data/.nethackrc" jwodder/nethack:3.6

or add the `.nethackrc` directly to root's home directory in a derived image and run that:

    # Dockerfile:
    FROM jwodder/nethack:3.6
    RUN echo 'OPTIONS=name:Rodney,disclose:+i +a +v +g +c +o' > /root/.nethackrc

    # Command line:
    docker build -t my_derived_nethack .
    docker run -it my_derived_nethack

If using a `3.6.*-sysconf` image, the default option values can be set by placing them in `/data/sysconf`:

    echo 'OPTIONS=name:Rodney,disclose:+i +a +v +g +c +o' >> /path/to/my/nethack/data/sysconf

    docker run -it -v /path/to/my/nethack/data:/data jwodder/nethack:3.6-sysconf
