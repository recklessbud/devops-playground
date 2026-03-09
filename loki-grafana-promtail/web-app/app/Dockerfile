FROM python:3.12-slim-bullseye

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

# Create log directory
RUN mkdir -p /var/log/myapp

COPY . .

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]