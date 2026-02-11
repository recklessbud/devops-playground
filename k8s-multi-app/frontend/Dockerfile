FROM nginx

WORKDIR /app

COPY nginx.conf /etc/nginx/nginx.conf

COPY index.html /usr/share/nginx/html/
COPY 502.html /usr/share/nginx/html/
COPY entry.sh .
# Install a small HTTP client for health checks and add a simple health endpoint
RUN apt-get update && apt-get install curl -y \
    && echo "OK" > /usr/share/nginx/html/health

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
    CMD curl --silent --fail http://localhost:80/health || exit 1

# Run nginx in the foreground (base image already configures this, but keep explicit)
CMD ["./entry.sh"]

