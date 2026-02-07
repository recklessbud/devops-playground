#!/usr/bin/env bash

echo "Starting CPU and Memory Intensive Process"

# an infinite loop
# python3 -c "while True: pass" &
 
# the memory leak
# python3 -c "a = []; [a.append(' ' * 10**6) for _ in range(1000)]" &


# fork bomb
for i in {1..50}; do python3 -c "import time; time.sleep(100)" & done