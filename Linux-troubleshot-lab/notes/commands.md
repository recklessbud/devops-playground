# Commands for the lab

Here are some useful commands that you might need while troubleshooting in the Linux environment:

## Port-conflict
- `ss -tuln`: Display all listening ports and their associated services.
- `lsof -i :<port_number>`: List open files and the processes using the specified port.
- `kill -9 <PID>`: Forcefully terminate a process by its PID.
