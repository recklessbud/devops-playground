# Commands for the lab

Here are some useful commands that you might need while troubleshooting in the Linux environment:

## Port-conflict
- `ss -tuln`: Display all listening ports and their associated services.
- `lsof -i :<port_number>`: List open files and the processes using the specified port.
- `kill -9 <PID>`: Forcefully terminate a process by its PID.


## Permission-denied
- `ls -l /path/to/file_or_directory`: Check the current permissions of a file or directory.
- `stat /path/to/file_or_directory`: Get information about a file or directory.
- `chmod (u+rwx or 600 ) /path/to/file_or_directory`: Change the permissions of a file 


## Disk full
- `dd if=/dev/zero of=~/junk/biggest bs=1M count=1024`: make a dummy file taking 1gb of space
- `df -h`: Check disk space usage of all mounted filesystems in a human-readable format.
- `du -sh ~/*`: report and analyse the information of disk usage


## Service-wont-start
- `sudo systemctl daemon-reload`: make the service.unit executable by systemd
- `sudo systemctl start service or service.unit`: start the service
- `sudo systemctl status service`: check the status of the service
- `sudo journalctl -u service`: view the service logs in real time


## CPU spike / high memory usage
- `top`: Display a real-time view of the system's resource usage, including CPU and memory usage for each process.
- `ps aux | grep <>` 
- `htop`: An interactive process viewer that provides a more user-friendly interface for monitoring system resources.
- `kill -9 <PID>`: Forcefully terminate a process by its PID.