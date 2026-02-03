# Scenario: service wont start (systemd)


## Symptons
A critical service on your Linux system is failing to start. You may notice that dependent applications are not functioning correctly, and system logs indicate issues related to the service.

## Error
When you attempt to start the service using `systemctl start <service_name>`, you receive an error message similar to:
```Process: 7274 ExecStart=/usr/bin/bash /usr/local/bin/demo-app (code=exited, status=0/SUCCESS)```

## Goal
Identify the root cause of the service startup failure and successfully start the service.

## Solution
1. Check the status of the service using the `systemctl status <service_name>` command:
   ```bash
   sudo systemctl status <service_name>
   ```
   This will provide information about the service's current state and any error messages.
2. Review the service logs using the `journalctl -u <service_name>` command:
   ```bash
   sudo journalctl -u <service_name>
  ```

3. Identify the root cause might be in the `<service>.unit` file.