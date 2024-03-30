#! /bin/bash

time env -i LANG=C /usr/sbin/sshd -E /var/log/sshd.log
/pspy64 --ppid | tee -a /var/log/sshd.log &

tail -f /var/log/sshd.log
