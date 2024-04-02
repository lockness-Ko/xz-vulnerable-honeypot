#! /bin/bash

if [ -z $1 ]; then
  echo Usage: ./$0 DISCORD_WEBHOOK_URL
  echo
  echo e.g. ./$0 https://discord.com/api/webhooks/12345678909876/aaaaaaaa
fi

tar czvf logs_$(date +%d%m%y_%H%M).tar.gz ./logs/* && rm -rf ./logs/*

mkdir -p ~/.config/notify/

cat << EOF > ~/.config/notify/provider-config.yml
discord:
  - id: "crawl"
    discord_channel: "crawl"
    discord_username: "xz-honeypot"
    discord_format: "{{data}}"
    discord_webhook_url: "$1"
EOF

docker compose build && docker compose up -d

sleep 3
tail -f logs/{strace,bpftrace}.log 2>&1 | grep --line-buffered -vE "(\/usr\/bin\/sshd \-D \-R|systemd-userwork)" | ~/go/bin/notify
