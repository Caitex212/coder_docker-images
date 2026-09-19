# Change this to your registry/namespace once you've pushed the base image, e.g.:
#   docker.io/yourname/dev-base:latest
#   ghcr.io/yourname/dev-base:latest
ARG BASE_IMAGE=yourname/dev-base:latest
FROM ${BASE_IMAGE}

USER root

# Base image already has Node LTS installed (mason needs it too), but pin/upgrade here
# if you want a specific major version for this variant instead of whatever LTS base has:
# RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && apt-get install -y nodejs

# Common global tooling for JS/TS work
RUN npm install -g \
    typescript \
    typescript-language-server \
    eslint \
    prettier \
    pnpm \
    yarn

USER coder
WORKDIR /home/coder

CMD ["sleep", "infinity"]
