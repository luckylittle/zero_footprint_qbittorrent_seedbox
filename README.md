<!-- markdownlint-disable MD033 -->
<h1 align="center">
  <img alt="autobrr logo" src=".github/images/logo.png" width="160px"/><br/>
luckylittle.zero_footprint_qbittorrent_seedbox
</h1>

<p align="center">

Project overview
----------------

This Ansible role provisions a standard [Red Hat Enterprise Linux 10 (RHEL 10)](https://www.redhat.com/en/technologies/linux-platforms/enterprise-linux) system as a secure, efficient and lightweight peer-to-peer (P2P) seedbox, running [qBittorrent](https://www.qbittorrent.org/).

The configuration prioritizes security and simplicity, utilizing integrated tools such as SELinux and firewalld. To maintain a minimal system footprint, it is configured for zero-logging operation and no shell history. Among others (mkbrr, tqm, netronome, sizechecker, sfvbrr etc.), the role incorporates [Autobrr](https://github.com/autobrr/autobrr) for modern automated downloads and cross-seed via [Qui](https://github.com/autobrr/qui) for enhanced seeding.

Please be aware that the absence of persistent logs may complicate troubleshooting, though the ephemeral journal should be sufficient for most diagnostics. This project is an enhanced fork of my [zero_footprint_rutorrent_seedbox](https://github.com/luckylittle/zero_footprint_rutorrent_seedbox) repository, simplified and adapted for qBittorrent (lot of lessons learned!). [Contributions](CONTRIBUTING.md) via pull requests are welcome.

</p>

[![ansible-lint](https://github.com/luckylittle/zero_footprint_qbittorrent_seedbox/actions/workflows/ansible-lint.yml/badge.svg)](https://github.com/luckylittle/zero_footprint_qbittorrent_seedbox/actions/workflows/ansible-lint.yml) ![GitHub Release](https://img.shields.io/github/v/release/luckylittle/zero_footprint_qbittorrent_seedbox?style=for-the-badge) ![Ansible Role](https://img.shields.io/ansible/role/d/luckylittle/zero_footprint_qbittorrent_seedbox?style=for-the-badge) ![GitHub last commit](https://img.shields.io/github/last-commit/luckylittle/zero_footprint_qbittorrent_seedbox?style=for-the-badge)

Prerequisites
-------------

* A clean installation of RHEL 10 (CentOS Stream should also work, but is not always tested).
* Pre-configured, passwordless Ansible access with `sudo` privileges. The [luckylittle/ansible-role-create-user](https://github.com/luckylittle/ansible-role-create-user) role may be used to establish this access.
* Access via password should also be in place (mainly due to single-user vsftpd) - e.g. `sudo passwd <user>`.

:warning: Important configuration notes :warning:
-------------------------------------------------

* **SSH Key Authentication is mandatory**: This role will disable password-based SSH access by setting `PasswordAuthentication no`. You must configure SSH key-pair authentication BEFORE execution to avoid being completely locked out of the system.
* **Firewall IP whitelisting**: To ensure you can access the system after the firewall is enabled, you must add your client IP address(es) to the `ipv4_whitelist` variable. Failure to do so will result in a system lockout as well.

Architecture
------------

![img](.github/images/architecture.png)

Role Variables
--------------

[Default variables](defaults/main.yml) are:

[Common (section 1)](tasks/01-common.yml):

* `set_google_dns` - if `true`, it will add Google DNS servers to the primary interface. Defaults to true.
* `set_timezone` - change the time zone of the server, defaults to UTC.
* `sysctl_tunables` - on/off for various tuning options in [sysctl.yml](vars/sysctl.yml). Default is on.

_Note:_ Lot of the tasks rely on `remote_user` / `ansible_user` variable (user who logs in to the remote machine via Ansible). For example, it creates directory structure under that user.

[qBt (section 2)](tasks/02-qbt.yml):

* `qbt_port` - what port should qBittorrent listen on. Default is **55442**.

[vsFTPd (section 3)](tasks/03-vsftpd.yml):

* `ftp_port` - what port should vsftpd listen on. Default is **55443**.
* `pasv_port_range` - what port range should be used for FTP PASV, by default this is **64000-64321**.
* `single_user` - when `true` only one FTP user will be used and it is the same username who runs this playbook. :warning: When `false`, [this](files/vsftpd/users.txt) file is used (example [here](files/vsftpd/users.txt.example)), update accordingly :warning: This is now true by default.

[Security (section 5)](tasks/05-security.yml):

* `ipv4_whitelist` - what IP addresses should be used in the **firewalld** zone for access to services. Default whitelisted is arbitrary address `X.X.X.X`. :warning: You **need** to [change it](defaults/main.yml#L19) to your own :warning:

_Example:_ `192.168.0.0/16 10.0.0.0/8 172.16.0.0/12 123.222.11.111`

[Reboot (section 7)](tasks/07-reboot.yml):

* `require_reboot` - does the machine require reboot after the playbook is finished. It is recommended & default to be true.

[Role variables](vars/main.yml) are also tunable, but it is not recommended to change them unless you know what you are doing.

Dependencies
------------

* Ansible core v`2.16.14`
* `ansible-galaxy collection install -r requirements.yml` ([ansible-posix-2.1.0, community-crypto-3.1.0, community-general-12.3.0](requirements.yml))

Example Inventory & Playbook
----------------------------

```ini
[seedbox]
123.124.125.126
```

```yaml
---
- hosts: seedbox
  name: Playbook for zero_footprint_qbittorrent_seedbox role
  roles:
    - "luckylittle.zero_footprint_qbittorrent_seedbox"
```

Testing
-------

|Version RHEL OS|Version role 0.2.0|
|---------------|------------------|
|10.1 (Coughlan)|:white_check_mark:|

On a brand new Red Hat Enterprise Linux release 10.1 (Coughlan) on AWS (t3.medium - 2 vCPU, 4GiB RAM), it took 13m 59s.
The following versions were installed during the last RHEL10 test:

|Package name   |Package version   |
|---------------|------------------|
|autobrr        |1.72.1            |
|bash           |5.2.26-6.el10     |
|curl           |8.12.1-2.el10     |
|firewalld      |2.3.1-1.el10_0    |
|libdb-utils    |5.3.28-64.el10_0  |
|mkbrr          |1.20.0            |
|netronome      |0.9.0             |
|NetworkManager |1.54.0-2.el10_1   |
|openssh        |9.9p1-12.el10_1   |
|qBittorrent    |5.1.4             |
|qui            |1.13.1            |
|sfvbrr         |0.0.7             |
|sizechecker    |1.4.0             |
|tar            |1.35-9.el10_1     |
|tqm            |1.19.0            |
|traceroute     |2.1.6-3.el10      |
|tuned          |2.26.0-1.el10_1.1 |
|vnstat         |2.13-1.el10_1     |
|vsftpd         |3.0.5-10.el10_1.1 |
|wget           |1.24.5-5.el10     |

The following Terraform can be used to create necessary infrastructure (based on RHEL10.X on AWS):

<details>

```hcl
# Configure the AWS Provider
provider "aws" {
  region = "ap-southeast-2"
}

# Variable
variable "key_name" {
  type        = string
  default     = "ec2-pair"
  description = "AWS Key-pair"
}

# Find latest RHEL 10 AMI
data "aws_ami" "rhel10" {
  most_recent = true
  owners      = ["309956199498"] # Red Hat's AWS account ID

  filter {
    name   = "name"
    values = ["RHEL-10*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# Create a security group
resource "aws_security_group" "rhel10_sg" {
  name        = "rhel10_sg"
  description = "Security group for RHEL10 EC2 seedbox instance"

  tags = {
    Name = "RHEL10-SecurityGroup"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_all" {
  security_group_id = aws_security_group.rhel10_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Generally a bad practice, but we need to test firewalld functionality"
  tags = {
    Name = "allow_all"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.rhel10_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.rhel10_sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Create an EC2 instance
resource "aws_instance" "rhel_instance" {
  ami                    = data.aws_ami.rhel10.id
  instance_type          = "t3.medium"
  vpc_security_group_ids = [aws_security_group.rhel10_sg.id]
  key_name               = var.key_name # Replace with your key pair name

  root_block_device {
    volume_size = 15
    volume_type = "gp3"
    encrypted   = true
    tags = {
      Name = "RHEL10-Seedbox"
    }
  }

  ebs_block_device {
    device_name           = "/dev/sdb"
    volume_size           = 15
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
    tags = {
      Name = "RHEL10-Seedbox"
    }
  }

  user_data = <<EOF
#!/bin/bash
# Log all output for debugging
exec > >(tee /var/log/user-data.log) 2>&1
echo "Starting user data script at $(date)"
# Wait for the EBS volume to be available
echo "Waiting for EBS volume to be available..."
while [ ! -e /dev/nvme1n1 ]; do
  echo "Waiting for /dev/nvme1n1..."
  sleep 5
done
echo "EBS volume /dev/nvme1n1 is available"
# Create partition on the EBS volume
echo "Creating partition on /dev/nvme1n1..."
(
echo n # Add a new partition
echo p # Primary partition
echo 1 # Partition number
echo   # First sector (Accept default: 1)
echo   # Last sector (Accept default: varies)
echo w # Write changes
) | fdisk /dev/nvme1n1
# Wait a moment for the partition to be recognized
sleep 5
# Format the partition with XFS
echo "Formatting /dev/nvme1n1p1 with XFS..."
mkfs.xfs /dev/nvme1n1p1
# Get the UUID of the new partition
echo "Getting UUID of the partition..."
UUID=$(blkid -s UUID -o value /dev/nvme1n1p1)
echo "UUID: $UUID"
# Add entry to /etc/fstab
echo "Adding entry to /etc/fstab..."
echo "UUID=$UUID /home xfs defaults 0 0" >> /etc/fstab
# Create a temporary mount point to preserve existing home data
echo "Creating temporary mount point..."
mkdir -p /mnt/temp_home
# Mount the new volume temporarily
mount /dev/nvme1n1p1 /mnt/temp_home
# Copy existing /home contents to the new volume (if any)
if [ "$(ls -A /home 2>/dev/null)" ]; then
  echo "Copying existing /home contents to new volume..."
  cp -arv /home/* /mnt/temp_home/
fi
# Unmount the temporary mount
umount /mnt/temp_home
rmdir /mnt/temp_home
# Mount the new volume to /home
echo "Mounting new volume to /home..."
mount -av
# Reload systemd daemon
systemctl daemon-reload
# Verify the mount
echo "Verifying mount..."
df -h /home
mount | grep /home
# Restore default SELinux security contexts
restorecon -Rv /home/
echo "User data script completed successfully at $(date)"
# Optional: Create a marker file to indicate completion
touch /var/log/user-data-complete
EOF

  tags = {
    Name        = "RHEL10-Seedbox"
    Environment = "Dev"
  }
}

# Output the instance details
output "instance_id" {
  value = aws_instance.rhel_instance.id
}

output "instance_public_ip" {
  value = aws_instance.rhel_instance.public_ip
}

output "instance_dns" {
  value = aws_instance.rhel_instance.public_dns
}
```

</details>

To test:

```bash
# Create a testing EC2 machine
cd tests/
terraform init; terraform apply -var=key_name=<NAME_OF_THE_EXISTING_KEY_PAIR_IN_AWS> -auto-approve
# Insert the EC2 machine's public IP to the Ansible inventory
terraform output -raw instance_public_ip > inventory
# Make necessary symlink for testing playbook
mkdir roles/; ln -s ../../ roles/luckylittle.zero_footprint_qbittorrent_seedbox
# Run the test
time ansible-playbook -i inventory -u ec2-user test.yml
# To destroy the EC2 machine afterwards
# terraform destroy -auto-approve
```

Services Installed
------------------

After you successfully apply this role, you should be able to see a similar output and access the following services:

```bash
"----------------------------------------------------"
"Autobrr URL:"
"http://123.124.125.126:7474/onboard"
"----------------------------------------------------"
"Autobrr Healthz URL:"
"http://123.124.125.126:7474/api/healthz/liveness"
"----------------------------------------------------"
"qBt WebUI:"
"http://123.124.125.126:8080"
"----------------------------------------------------"
"Qui URL:",
"http://123.124.125.126:7476",
"----------------------------------------------------"
"Netronome URL:",
"http://123.124.125.126:7575",
"----------------------------------------------------"
"vsFTPd URL:"
"ftps://123.124.125.126:55443"
"----------------------------------------------------"
```

License
-------

MIT

Ansible Galaxy
--------------

[luckylittle.zero_footprint_qbittorrent_seedbox](https://galaxy.ansible.com/ui/standalone/roles/luckylittle/zero_footprint_qbittorrent_seedbox/)

Author Information
------------------

Lucian Maly <<lmaly@redhat.com>>

_Last update: Wed 04 Feb 2026 01:23:14 UTC_
