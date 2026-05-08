## working with files
# opening a file(read)
with open('sometext.txt', 'r') as f:
    data = f.read()
    # print(data)

with open('c:/Users/reggi/Documents/devops-playground/others/python-scripts/files/main.py', 'r') as f:
    data = f.read()
    # print(data)


# opening a file (write)
with open ("sometext.txt", 'w') as f:
    data = 'some'
    # f.write(data)

# listing a directory
import os
import pathlib
with os.scandir('c:/Users/reggi/Documents/devops-playground/others/python-scripts/files/') as e:
    for entry in e:
        entry = 1
        # print(entry.name)


entry = pathlib.Path('c:/Users/reggi/Documents/devops-playground/others/python-scripts/files/')
for entry in entry.iterdir():
    d = 1
    # print(entry.name)

## listing files
with os.scandir('c:/Users/reggi/Documents/devops-playground/others/python-scripts/files/') as ent:
    for entry in ent:
        if entry.is_file():
            p= 2
            # print(entry.name)


ents = pathlib.Path('c:/Users/reggi/Documents/devops-playground/others/python-scripts/files')
baseline = ents.iterdir()
for base in baseline:
    if base.is_file():
        base = 1
        # print(base.name)

# listing folders in a folder
with os.scandir('c:/Users/reggi/Documents/devops-playground/others/python-scripts/files') as mnt:
    for mount in mnt:
        if mount.is_dir():
            base = 1

mnt = pathlib.Path('c:/Users/reggi/Documents/devops-playground/others/python-scripts/files')
baseline = mnt.iterdir()
for base in baseline:
    if base.is_dir():
        base = 1
        # print(base.name)

# getting file attributes
dir1  = pathlib.Path('c:/Users/reggi/Documents/devops-playground/others/python-scripts/files')
for path in dir1.iterdir():
    base = 3
    # print(path.stat().st_size)


#getting folder attributes
dir1 = pathlib.Path('c:/Users/reggi/Documents/devops-playground/others/python-scripts/files')
for path in dir1.iterdir():
    if path.is_dir():
        base =4
        # print(path.stat().st_size)

## project1 - convert st_mtime to date
import datetime

def convertTime(time):
    d = datetime.datetime.fromtimestamp(time)
    format = d.strftime('%Y-%m-%d %H:%M:%S')
    return format

def _some ():
    file_att = pathlib.Path('c:/Users/reggi/Documents/devops-playground/others/python-scripts/files')
    for path in file_att.iterdir():
        if path.is_file():
            time = path.stat().st_mtime
            print(convertTime(time))



# making directories
# p = pathlib.Path('c:/Users/reggi/Documents/devops-playground/others/python-scripts/files/test/rt/yu')
# p.mkdir(exist_ok=True, parents=True)


# filename pattern matching
p = pathlib.Path('c:/Users/reggi/Documents/devops-playground/others/python-scripts/files')
for name in p.glob('*'):
    base = 3
    # print(name

# using glob
import glob
for name in glob.iglob("**/*", recursive=True):
    base = 4
    # print(name)

for name in glob.glob("*backup*"):
    base = 4
    # print(name)

# walking into a directory
for dirpath, dirnames, files in os.walk("c:/Users/reggi/Documents/devops-playground/others/python-scripts/files"):
    print(f"Found directory: {dirpath}")
    for file in files:
        print(f"Found file: {file}")




# delete file
del_file = ('c:/Users/reggi/Documents/devops-playground/others/python-scripts/files/some.txt')

if os.path.isfile(del_file):
    os.remove(del_file)
else:
    print("File does not exist")



del_folder = ('c:/Users/reggi/Documents/devops-playground/others/python-scripts/files/sub4')
try:
    pathlib.Path(del_folder).rmdir()
except OSError as e:
    print("Error: %s : %s" % (del_folder, e.strerror))


import shutil

try:
    shutil.rmtree(del_folder)
except OSError as e:
    print("Error: %s : %s" % (del_folder, e.strerror))
