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

COPY requirements.txt ./

RUN uv pip install --no-cache-dir -r requirements.txt

COPY . .

FROM builder-base AS development

ENV FASTAPI_ENV=development

COPY requirements-dev.txt ./
RUN uv run pip install --no-cache-dir -r requirements-dev.txt

EXPOSE 9090

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "9090"]

FROM python-base AS production

ENV FASTAPI_ENV=production

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -g 1500 produser && \  
    useradd -m -u 1500 -g produser appuser

COPY --from=builder-base /usr/local /usr/local

COPY --chown=appuser:produser . .

USER appuser

EXPOSE 2000

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
    CMD curl --fail http://localhost:2000/health || exit 1

CMD ["gunicorn", "--worker-class", "uvicorn.workers.UvicornWorker", "--bind", "0.0.0.0:2000", "src.main:app"]