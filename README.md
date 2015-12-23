[NetHack](http://www.nethack.org) is a
[roguelike](https://en.wikipedia.org/wiki/Roguelike) computer game in which a
brave young `@` goes forth to acquire the Amulet of Yendor and dies horribly
every(?) single time.  It also has [a wiki](https://nethackwiki.com).

This repository contains Docker images for the latest versions of the game,
built with the basic out-of-the-box configurations (so tty graphics only, no
autopickup exceptions in 3.4.3, and no status hilites in 3.6.0), with the
following exceptions:

- `root` (the user the image runs as) can enter debug/wizard mode without
  having to switch to a different \*nix account.

- Mutable game data (high scores, save files, etc.) is stored in the `/data`
  directory separately from the static data so that the former can be saved in
  a Docker volume and preserved across containers.

Tags and Dockerfiles
--------------------
* [`3.6.0`, `latest`](https://github.com/jwodder/nethack-docker/blob/master/Dockerfile)
* [`3.4.3`](https://github.com/jwodder/nethack-docker/blob/3.4.3/Dockerfile)

Setting Options
---------------
You can set NetHack options by specifying them directly in the environment
variable `NETHACKOPTIONS`:

    docker run -it -e NETHACKOPTIONS="name:Rodney,disclose:+i +a +v +g +c +o" jwodder/nethack:3.6.0

or put the options in a `.nethackrc` file in your `/data` volume and set
`NETHACKOPTIONS` to `"@<PATH TO FILE>"`:

    echo 'OPTIONS=name:Rodney,disclose:+i +a +v +g +c +o' > /path/to/my/nethack/data/.nethackrc

    docker run -it -v /path/to/my/nethack/data:/data -e NETHACKOPTIONS="@/data/.nethackrc" jwodder/nethack:3.6.0

or add the `.nethackrc` directly to root's home directory in a derived image
and run that:

    # Dockerfile:
    FROM jwodder/nethack:3.6.0
    RUN echo 'OPTIONS=name:Rodney,disclose:+i +a +v +g +c +o' > /root/.nethackrc

    # Command line:
    docker build -t my_derived_nethack .
    docker run -it my_derived_nethack

<!-- NetHack options will also be settable in the sysconf file, once support
for that is added. -->
