FROM python:3.12-slim-bullseye

WORKDIR /app

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY . /app

RUN pip install --no-cache-dir "fastapi>=0.128.0" "uvicorn[standard]" "python-decouple>=3.8"

EXPOSE 60004

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "60004"]