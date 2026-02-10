#!/usr/bin/env bash

# use htop and top to check the cpu and memory usage
htop -t
top 

#uptime and load average `three dots at the end are the load average`
uptime

# check the memory usage, swap usage and memory space
free -m # to load in mbs

#in doubt of top and htop use `ps -aux`
ps aux(r) | grep <PID> or grep <process_name>

# found the process eating up things
kill -9 <PID> or pkill -f <process_name>