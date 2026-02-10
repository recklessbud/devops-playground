# Scenario: CPU spike / high memory usage
In this sceanion, I will troubleshoot a Linux system that is experiencing issues due to a high usage of cpu and .

### Symptons
The system is running slowly, and users are unable to perform tasks.  May also see error messages indicating that the CPU or memory usage is high.

### Error
When you attempt to perform a task, you may see an error message similar to:
```CPU usage is high``` / or ```OOM (Out Of Memory)```


### Goal
Identify the process that is causing the high CPU or memory usage and take appropriate action to resolve the issue.

### Solution
1. Check the CPU and memory usage of all running processes using the `top or htop` command:
   ```bash
   top
   ```
   This will display a real-time view of the system's resource usage, including CPU and memory usage for each process.


2. Identify the process that is consuming the most CPU or memory resources. Look for processes that have a high percentage of CPU or memory usage.

3. Once you have identified the process, you can take appropriate action to resolve the issue. This may include:
   - Killing the process using the `kill` command:
     ```bash
     kill <PID>
     ```
     Replace `<PID>` with the process ID of the offending process.