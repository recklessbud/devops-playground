#!/usr/bin/env bash

# creating a file with permission denied
mkdir -p ~/apps/logs
touch ~/apps/logs/app.log
chmod 000 ~/apps/logs/app.log

echo "Created /apps/logs/app.log with permission 000 (no access)"
echo "hell0" >> ~/apps/logs/app.log