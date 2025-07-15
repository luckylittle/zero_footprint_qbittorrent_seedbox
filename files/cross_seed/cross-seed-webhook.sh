#!/bin/sh
# Managed by Ansible
/usr/bin/curl -s http://127.0.0.1:2468/api/webhook?apikey=1234567890abcdefghijklmnopqrstuvwxyz1234567890ab -d "infoHash=$1" -d "includeSingleEpisodes=true" > /dev/null 2>&1 &
