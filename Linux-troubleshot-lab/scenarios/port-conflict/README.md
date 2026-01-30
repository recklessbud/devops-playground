# Scenario: Port-conflicts

## Sympton
You have multiple services running on a Linux server, and one of them is failing to start. You suspect that there might be a port conflict causing the issue.

## Error
When you try to start the service, you receive an error message indicating that the port is already in use. For example:
``` OSError: [Errno 98] Address already in use ``

## Goal
Identify the service in use of the port causing the problem and resolve the issue without killing the other services.

## Solution
1. Identify the port number that the failing service is trying to use. This information can usually be found in the service's configuration file or documentation.

2. Use the `ss` command to check which services are currently using ports on the system. For example, you can run:
   ```bash
   sudo ss -tuln | grep :<port_number>
   ```
3. if port is in use, you can run to kill the process:
    ``` bash
    PID=$(lsof -ti :<port_number>)
    sudo kill -9 $PID
   ```


## Signals

### Before Fix
- ss -tulnp shows LISTEN on :8080
- Application fails to bind
- curl localhost:8080 works but wrong service responds

### After Fix
- ss shows port free
- Application starts successfully
- curl returns expected response