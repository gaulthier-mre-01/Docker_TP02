FROM nginx:latest
RUN apt-get update && apt-get install -y \
    nano \
    iproute2 \
    iputils-ping \
    && rm -rf /var/lib/apt/lists/*
