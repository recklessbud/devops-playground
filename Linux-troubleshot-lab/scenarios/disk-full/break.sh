#!/usr/bin/env bash

# make a big dummy file

mkdir -p ~/junk
echo "Making a 1GB dummy file..." 
dd if=/dev/zero of=~/junk/biggest bs=1M count=1024