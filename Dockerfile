FROM python:3.8-slim-buster
LABEL maintainer="Breadlysm" \
    description="Original by Aiden Gilmartin. Maintained by Breadlysm" \
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
RUN apt-get update 
RUN apt-get -q -y install --no-install-recommends apt-utils gnupg1 apt-transport-https dirmngr curl

# Install Speedtest
COPY install.deb.sh /opt/install.deb.sh
#RUN curl -s https://install.speedtest.net/app/cli/install.deb.sh --output /opt/install.deb.sh
RUN bash /opt/install.deb.sh
RUN apt-get update && apt-get -q -y install speedtest
RUN rm /opt/install.deb.sh

# Clean up
RUN apt-get -q -y autoremove && apt-get -q -y clean 
RUN rm -rf /var/lib/apt/lists/*

# Copy and final setup
ADD . /app
WORKDIR /app
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt 
COPY . .

# Excetution
CMD ["python", "main.py"]
