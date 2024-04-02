#! /bin/bash

chown root:root /usr/share/empty.sshd
time env -i LANG=C /usr/sbin/sshd -E /logs/sshd_$(date +%d%m%y_%H%M).log

tcpdump -i any -w /logs/tshark_$(date +%d%m%y_%H%M).pcap &
strace -e execve -p $(ps aux | grep sshd | awk '{print $2}' | head -n1 | tr -d '\n') | tee /logs/strace_$(date +%d%m%y_%H%M).log &

# Calls to `system` in libc
bpftrace -e 'uprobe:/lib/libc.so.6:system { printf("SYSTEM CALLED\n"); }' | tee /logs/bpftrace_libc_$(date +%d%m%y_%H%M).log &
# Calls to `execve` where the parent process name is `sshd`
bpftrace -e "tracepoint:syscalls:sys_enter_execve { if (curtask->parent->comm == \"sshd\") { printf(\"%d \", tid); join(args->argv); } }" | tee /logs/bpftrace_execve_$(date +%d%m%y_%H%M).log &

# only display bpftrace and strace logs.
tail -f /logs/*_$(date +%d%m%y_%H%M).log
