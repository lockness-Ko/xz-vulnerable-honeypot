# xz-vulnerable-honeypot

An ssh honeypot with the XZ backdoor. CVE-2024-3094

**TODO**: hook the backdoor and/or sshd. log rsa keys for decryption.

notes:
- https://gist.github.com/smx-smx/a6112d54777845d389bd7126d6e9f504
- https://gist.github.com/q3k/af3d93b6a1f399de28fe194add452d01

## Warning

**PLEASE run this on a separate isolated system. Docker is configured in a way that allows a threat actor to easily escape it.
Docker is only used to get all the shared libraries working and configured.**

## Installation

Install [notify](https://github.com/projectdiscovery/notify) by projectdiscovery using the following command:

```bash
go install -v github.com/projectdiscovery/notify/cmd/notify@latest
  ```

Run the following command to start the honeypot:

```bash
./monitor.sh DISCORD_WEBHOOK_URL
```

e.g.

```bash
./monitor.sh https://discord.com/api/webhooks/12345678909876/aaaaaaaa
```

This will use [notify](https://github.com/projectdiscovery/notify) to send all logs to a discord webhook.

## How it works

The vulnerable version of xz (5.6.1) and the liblzma linked version of sshd from the fedora repositories are ran in the configuration that activates the backdoor. Monitoring is provided by `bpftrace`, `strace`, `tcpdump`, and the `sshd` process itself.

- `bpftrace`
  - Syscall monitoring and shared library hooking.
- `strace`
  - Syscall montioring for the parent `sshd` process.
- `tcpdump`
  - Capturing packets.
- `sshd`
  - Login events (**NOTE** This will most likely not capture the login event for a bad actor as the backdoor uses `set_log_mask` to change the logging behaviour when the attacker attempts to login)
