# xz-vulnerable-honeypot
An ssh honeypot with the XZ backdoor. CVE-2024-3094

*TODO*: hook the backdoor

notes: https://gist.github.com/smx-smx/a6112d54777845d389bd7126d6e9f504
https://gist.github.com/q3k/af3d93b6a1f399de28fe194add452d01

## Installation

*PLEASE run this on a separate isolated system. Docker is not used for isolation, but for getting the libraries working.*

The bpf hook alsoo prints EVERY call to execve, including ones outside the container. 

Just run

```bash
docker compose up
```

## Configuration

Change the exposed port in docker-compose.yml to change which port sshd listens on.
