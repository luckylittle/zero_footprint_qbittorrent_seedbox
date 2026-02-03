#!/bin/bash
# Managed by Ansible
wget $(curl -s https://api.github.com/repos/autobrr/qui/releases/latest | grep browser_download_url | grep linux_x86_64 | cut -d\" -f4)
sudo systemctl stop qui
tar -xzf qui*.tar.gz
sudo mv -v qui /usr/local/bin
sudo restorecon -Rv /usr/local/bin/
sudo systemctl start qui
sudo systemctl status qui
rm -v LICENSE README.md .wget-hsts qui_*_linux_x86_64.tar.gz
