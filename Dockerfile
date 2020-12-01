# ----------------------------------
# Environment: python3
# Minimum Panel Version: 0.6.0
# ----------------------------------
FROM        python:3.5-slim

LABEL       author="Thomasjosif" maintainer="thomasjosif@outlook.com"

RUN         apt update \
            && apt -y install git gcc g++ ca-certificates dnsutils curl iproute2 ffmpeg \
            && useradd -m -d /home/container container

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
CMD         ["/bin/bash", "/entrypoint.sh"]
