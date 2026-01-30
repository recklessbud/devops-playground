#!/usr/bin/env bash

# check the permissions of the file
echo "Checking permissions of ~/apps/logs/app.log"
ls -l ~/apps/logs/
stat ~/apps/logs/app.log


# make it executable
chmod 666 ~/apps/logs/app.log

ls -l ~/apps/logs/