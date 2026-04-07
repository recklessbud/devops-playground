import re
pattern = r'(\w+\s+\d+\s[\d:]+).*Failed password for (\w+) from ([\d.]+)'
with open('/var/log/auth.log', 'r') as f:
    for line in f:
        match =  re.search(pattern, line)
        if match:
            time = match.group(1)
            user = match.group(2)
            ip = match.group(3)
            print(f'time: {time}, user: {user}, ip: {ip}')
        else:
            print('no match')



# reading the lines
# failed = []
# for line in data:
#     if 'forbidden' in line.lower():
#         failed.append(line)



# for line in data:
#     print(line)