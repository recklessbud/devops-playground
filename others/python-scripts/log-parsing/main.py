# nginx error file

import re
import csv
import sys


errors = []

pattern = r'(\d{4}/\d{2}/\d{2} \d{2}:\d{2}:\d{2}) \[(\w+)\] \d+#\d+: \*\d+ .+? while connecting to upstream, client: ([\d.]+), server: \S+, request: "(\w+ \S+ \S+)", upstream: "([^"]+)"'
with open('/var/log/nginx/error.log.1', "r") as f:
    lines = f.readlines()
    for line in lines:
        results = re.findall(pattern, line)
        if results != None:
            for m in results:
                if m !=[]:
                    errors.append(results)


with open("error_message.json", "w", newline='') as error_list:
    for some in errors:
        for m in some:
            raw_time, level, client, request, upstream = m
        error_list.write(f"Raw_time: {raw_time} Level: {level} Client: {client} Request: {request} Stream: {upstream}\n")
