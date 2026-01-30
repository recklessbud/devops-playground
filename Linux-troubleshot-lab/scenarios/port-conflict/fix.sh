#!/usr/bin/env bash

# Find the PID of the process using port 8080 and terminate it
# PID=$(lsof -ti :PORT)
PID=$(lsof -ti :8080)

if [ -z "$PID" ]; then
    echo "No process found using port 8080"
fi

echo "Terminating process $PID using port 8080"
kill -9 $PID

echo "Process $PID terminated successfully"

#make the file executable
#chmod +x fix.sh