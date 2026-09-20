# syntax=docker/dockerfile:1.7
ARG BASE_IMAGE=ghcr.io/caitex212/dev-base:latest
FROM ${BASE_IMAGE}

USER root

# --- JDK + build tools ---
RUN apt-get update && apt-get install -y wget apt-transport-https gpg \
    && wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor | tee /etc/apt/trusted.gpg.d/adoptium.gpg > /dev/null \
    && echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list \
    && apt-get update \
    && apt-get install -y temurin-21-jdk maven gradle \
    && rm -rf /var/lib/apt/lists/*

RUN java -version && javac -version && mvn -version && gradle -version

USER coder
WORKDIR /home/coder

CMD ["sleep", "infinity"]
