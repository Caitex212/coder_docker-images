ARG BASE_IMAGE=yourname/dev-base:latest
FROM ${BASE_IMAGE}

USER root

RUN apt-get update && apt-get install python13

USER coder
WORKDIR /home/coder

CMD ["sleep", "infinity"]
