FROM ghcr.io/lockness-ko/xz-backdoor:latest

COPY ./run.sh /run.sh

ENTRYPOINT [ "/run.sh" ]
