# cpu checker with pstuil

import psutil

cpu = psutil.cpu_percent(interval=1)
print(cpu)