#!/bin/bash
set -ex
for f in */
do docker build -t "nethack:${f%/}" "$f"
done
