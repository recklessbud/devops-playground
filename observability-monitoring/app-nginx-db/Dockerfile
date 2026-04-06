FROM python:3.12-slim-bullseye AS python-base

ENV PYTHONUNBUFFERED=1 \  
    PYTHONDONTWRITEBYTECODE=1 \  
    UV_SYSTEM_PYTHON=1 \ 
    PATH="/usr/local/bin:$PATH"

WORKDIR /app


FROM python-base AS builder-base

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:$PATH"

COPY ./src/requirements.txt ./

RUN uv pip install --no-cache-dir -r requirements.txt

COPY . .


FROM builder-base AS development

ENV FASTAPI_ENV=development

RUN mkdir -p /var/log/myapp

EXPOSE 8070

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8060"]