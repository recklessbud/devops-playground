# Scenario: Disk full

In this scenario, you will troubleshoot a Linux system that is experiencing issues due to a full disk. You will learn how to identify the problem, locate large files or directories, and free up space on the disk.

## Symptons
The system is running slowly, and users are unable to save files or install new software. You may also see error messages indicating that the disk is full.

## Error
When you attempt to save a file or install software, you may see an error message similar to:
```No space left on device```

## Goal
Free up space on the disk to restore normal system operation.

## Solution
1. Check the disk usage of all mounted filesystems using the `df -h` command:
   ```bash
   df -h
   ```
   or 
   ```bash
    du -sh /*
    ```
   This will display the disk space usage in a human-readable format.