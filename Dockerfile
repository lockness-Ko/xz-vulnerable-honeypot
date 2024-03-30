FROM ghcr.io/lockness-ko/xz-backdoor:latest
LABEL org.opencontainers.image.source=https://github.com/lockness-Ko/xz-vulnerable-honeypot

COPY ./run.sh /run.sh

ENTRYPOINT [ "/run.sh" ]
