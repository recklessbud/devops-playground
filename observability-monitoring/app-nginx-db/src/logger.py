from loguru import logger
import sys

logger.remove()

logger.add(
    sys.stdout,
    format="{time:YYYY-MM-DD HH:mm:ss} | {level} | {name}:{function}:{line} | {message}",
    level="INFO",
    serialize=True  
)

logger.add(
    "/var/log/myapp/app.log",
    rotation="10 MB",       # new file every 10MB
    retention="7 days",     # keep 7 days of logs
    level="INFO",
    serialize=True
)