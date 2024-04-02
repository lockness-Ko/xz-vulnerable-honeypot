FROM ghcr.io/lockness-ko/xz-backdoor:latest
LABEL org.opencontainers.image.source=https://github.com/lockness-Ko/xz-vulnerable-honeypot

RUN [ "pacman", "-Sy", "--noconfirm", "--needed", "tcpdump", "bpftrace", "strace" ]

COPY ./container/run.sh /run.sh

ENTRYPOINT [ "/run.sh" ]
