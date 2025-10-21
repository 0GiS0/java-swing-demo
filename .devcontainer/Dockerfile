FROM mcr.microsoft.com/devcontainers/base:ubuntu

RUN apt-get update && apt-get install -y \
    xauth x11-apps \
    libxtst6 libxrender1 libxext6 libxi6 libxrandr2 libxfixes3 \
    libx11-6 libxau6 libxdmcp6 libfontconfig1 libfreetype6 libglib2.0-0 \
    mysql-client \
 && rm -rf /var/lib/apt/lists/*

# Create a directory for MySQL JDBC driver
RUN mkdir -p /opt/mysql-connector
