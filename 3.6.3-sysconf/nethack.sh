#!/bin/sh
# This wrapper script ensures that /data is never empty when NetHack starts.
# It omits the code in the official nethack.sh for setting X11 variables and
# finding HACKPAGER, as those are irrelevant here and set by the Dockerfile,
# respectively.

HACKDIR=/usr/games/lib/nethackdir
export HACKDIR
HACK=$HACKDIR/nethack
VARDIR=/data

# In case the user has mounted an empty directory into /data, ensure the
# necessary files & directory exist so NetHack won't die:
cd $VARDIR
mkdir -p save
touch perm record logfile xlogfile sysconf

cd $HACKDIR
exec $HACK "$@"
