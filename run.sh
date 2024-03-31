#! /bin/bash

chown root:root /usr/share/empty.sshd
time env -i LANG=C /usr/sbin/sshd -E /logs/sshd_$(date +%d%m%y_%H%M).log
tcpdump -i any -w /logs/tshark_$(date +%d%m%y_%H%M).pcap &
# bpftrace -e "tracepoint:syscalls:sys_enter_execve { if (curtask->parent->pid == $(ps aux | grep sshd | awk '{print $2}' | head -n1 | tr -d '\n')) { printf(\"%d \", tid); join(args->argv); } }" | tee /logs/bpftrace_$(date +%d%m%y_%H%M).log
bpftrace -e "tracepoint:syscalls:sys_enter_execve { if (curtask->parent->comm == \"sshd\") { printf(\"%d \", tid); join(args->argv); } }" | tee /logs/bpftrace_$(date +%d%m%y_%H%M).log
strace -e execve -p $(ps aux | grep sshd | awk '{print $2}' | head -n1 | tr -d '\n') | tee /logs/strace_$(date +%d%m%y_%H%M).log

tail -f /logs/*$(date +%d%m%y_%H%M).log
