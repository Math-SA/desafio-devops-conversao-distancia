FROM python:3.13.1-slim-bookworm
WORKDIR /app
RUN apt-get update && \
    apt-get install -y \
    --no-install-recommends\
    curl=7.88.1-10+deb12u8 && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . /app/
EXPOSE 5000
ENTRYPOINT ["gunicorn", "--bind", "0.0.0.0:5000","app:app"]
HEALTHCHECK --interval=30s \
            --timeout=10s \
            --start-period=5s \
            --retries=3 \
            CMD curl -f http://localhost:5000 || exit 1