#!/usr/bin/env bash


# starting a dummy service that will cause a port conflict on port 8080 

echo "starting dummy service on port 8080 and run it in the background"
python3 -m http.server 8080 > /dev/null 2>&1 &
echo "PID of dummy service: $!"

# make it executable
#chmod +x break.sh
