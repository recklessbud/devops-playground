#!/usr/bin/env bash

# checking for disk usage and disk storage

echo "Checking disk usage..."
df -h

echo "reporting and analysing disk usage"
du -sh ~/* | sort -h

echo "reporting the know folder eating up disk space"
du -sh ~/junk