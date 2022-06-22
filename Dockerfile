FROM ghcr.io/home-assistant/amd64-base-python:3.8-alpine3.16
LABEL maintainer="Hy3n4" \
    io.hass.version="VERSION" \
    io.hass.type="addon" \
    io.hass.arch="armhf|aarch64|i386|amd64"

ENV DEBIAN_FRONTEND=noninteractive \
    NAMESPACE="Home" \
    INFLUX_DB_ADDRESS=a0d7b954-influxdb \
    INFLUX_DB_PORT=8086 \
    INFLUX_DB_USER="speedtest" \
    INFLUX_DB_PASSWORD="speedtest" \
    INFLUX_DB_DATABASE="speedtest" \
    INFLUX_DB_TAGS="*" \
    SPEEDTEST_INTERVAL=5 \
    SPEEDTEST_SERVER_ID="" \
    PING_INTERVAL=5 \
    PING_TARGETS="1.1.1.1, 8.8.8.8" \
    LOG_TYPE=info

# Install dependencies
RUN apk add --no-cache py3-pip
RUN pip3 install speedtest-cli

# Copy and final setup
ADD . /app
WORKDIR /app
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt 
COPY . .

# Excetution
CMD ["python", "main.py"]
