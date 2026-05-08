#!/usr/bin/python3

import psutil

def check_threshold():
    dig = int(input("Enter the threshold: "))

    current_Cpu = psutil.cpu_percent(interval=1)
    print("cpu percent", current_Cpu,"%")

    if current_Cpu > dig:
        print("cpu usage is high")
    else:
        print("cpu usage is low")


check_threshold()