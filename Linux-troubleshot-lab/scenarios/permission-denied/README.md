# Scenario: Permision Denied

## Symptons
You are trying to access a file or directory on a Linux system, but you receive a "Permission Denied" error message.

## Error
When you attempt to access the file or directory, you see an error message similar to:
```Permission denied ```

## Goal
Gain the necessary permissions to access the file or directory without compromising system security.

## Solution
1. Check the current permissions of the file or directory using the `ls -l` command:
   ```bash
   ls -l /path/to/file_or_directory
   ```
2. change the file permission to desired permissions (Read(Read), Write(W), Execute(X)):
    ```bash
    chmod (u+rwx or 600 ) /path/to/file_or_directory  # Gives the owner read, write, and execute permissions
    ```