<h1 align="center">
  <img alt="autobrr logo" src=".github/images/logo.png" width="160px"/><br/>
luckylittle.zero_footprint_qbittorrent_seedbox
</h1>

<p align="center">

# THIS IS CURENTLY UNDER DEVELOPMENT - IT IS A FORK OF MY [RTORRENT/RUTORRENT ANSIBLE ROLE WHICH THIS IS BASED ON](https://github.com/luckylittle/zero_footprint_rutorrent_seedbox).

Configures vanilla RHEL8/9 (or CentOS 9) system to be lightweight and bulletproof seedbox running [](). It aims to be secure (SELinux, firewalld, SSL/TLS, enabled) and creates absolutely no logs (a.k.a "zero footprint)". It also provides modern autodownloading capabilities with [Autobrr](https://github.com/autobrr/autobrr) and [cross-seed](https://github.com/cross-seed/cross-seed)ing. Missing logs will make troubleshooting difficult, but ephemeral journal should be sufficient. Security and simplicity was priroitised over anything else. PRs are most welcome!

</p>

![GitHub Release](https://img.shields.io/github/v/release/luckylittle/zero_footprint_qbittorrent_seedbox?style=for-the-badge) ![Ansible Role](https://img.shields.io/ansible/role/d/luckylittle/zero_footprint_qbittorrent_seedbox?style=for-the-badge) ![GitHub last commit](https://img.shields.io/github/last-commit/luckylittle/zero_footprint_qbittorrent_seedbox?style=for-the-badge)

Requirements
------------

* It is expected, that you have a brand new RHEL8/9 or CentOS 9 stream system and have passwordless Ansible access sorted out - including working `sudo` (you can use my other role [luckylittle/ansible-role-create-user](https://github.com/luckylittle/ansible-role-create-user) for passwordless SSH access and sudo).
* :warning: **THIS ROLE REQUIRES PASSWORDLESS ACCESS TO YOUR SYSTEM USING SSH KEYPAIR AND NOT THE PASSWORD** (e.g. `ssh-copy-id`) - otherwise you will **lock** yourself out, because sshd config will change to `PasswordAuthentication no`! :warning:
* :warning: Make sure to add your home IP address (or multiple addresses you connect from) to `ipv4_whitelist`, or you risk **locking** yourself out, as it is also enforced by firewalld! :warning:

Role Variables
--------------

[Default variables](defaults/main.yml) are:

Common (section 1):

* `set_timezone` - change the time zone of the server, defaults to Europe/Prague.
* `set_google_dns` - if `true`, it will add Google DNS servers to the primary interface. Defaults to true.
* `create_new_user` - whether you want to also create another user. Defaults to false. Relevant to the `new_user` variable.
* `autobrr_ver`, `mkbrr_ver` & `sizechecker_ver` - contains the latest [Autobrr](https://github.com/autobrr/autobrr/releases), [Mkbrr](https://github.com/autobrr/mkbrr) and [Sizechecker](https://github.com/s0up4200/sizechecker/releases) versions. This gets regularly updated after the tests.
* `sysctl_tunables` - on/off for various tuning options in [sysctl.yml](vars/sysctl.yml). Default is on.
* `cross_seed` - Optional installation and configuration of the latest [cross-seed](https://github.com/cross-seed/cross-seed/releases) automation tool. Default is false.

_Note:_ Lot of the tasks rely on `remote_user` / `ansible_user` variable (user who logs in to the remote machine via Ansible). For example, it creates directory structure under that user.

rTorrent (section 2):

* `libtorrent_ver` - Version of the [libtorrent](https://github.com/rakshasa/rtorrent/releases). It should be identical to `rtorrent_ver`.
* `rtorrent_ver` - Version of the [rtorrent](https://github.com/rakshasa/rtorrent/releases). It should be identical to `libtorrent_ver`.
* `rtorrent_port` - what port should rtorrent listen on. Default is **55442**.

_Note:_ The ratio defaults should be sufficient (between [400%](vars/main.yml#L70)-[500%](vars/main.yml#L71)).

vsFTPd (section 3):

* `ftp_port` - what port should vsftpd listen on. Default is **55443**.
* `pasv_port_range` - what port range should be used for FTP PASV, by default this is **64000-64321**.
* `single_user` - when `true` only one FTP user will be used and it is the same username who runs this playbook. :warning: When `false`, [this](files/vsftpd/users.txt) file is used, update accordingly :warning: This is now true by default.

ruTorrent (section 4):

* `rutorrent_ver` - Version of the [ruTorrent](https://github.com/Novik/ruTorrent/releases).
* `https_port` - what port should rutorrent listen on, by default HTTPS (**443**).
* `htpasswd` - HTTP basic password to log in to ruTorrent interface. Default is r3dh4t. :warning: It is recommended to change this to your own :warning:

Security (section 5):

* `ipv4_whitelist` - what IP addresses should be excluded from being banned by Fail2Ban, and the same value is also used in the **firewalld** limited zone for SSH (only these specified addresses are allowed to SSH to the seedbox). Whitelisted is arbitrary address `X.X.X.X` and the private IP ranges. :warning: You **need** to [change it](defaults/main.yml#L40) to your own :warning:

Reboot (section 7):

* `require_reboot` - does the machine require reboot after the playbook is finished. It is recommended & default to be true.

[Role variables](vars/main.yml) are also tunable, but it is not recommended to change them unless you know what you are doing.

Dependencies
------------

* Ansible core v`2.16.14`
* community.general v`11.2.1` (Install: `ansible-galaxy collection install community.general`)
* community.crypto v`3.0.3` (Install: `ansible-galaxy collection install community.crypto`)
* ansible.posix v`2.1.0` (Install: `ansible-galaxy collection install ansible.posix`)

Example Playbook
----------------

`echo 'password1' > password.txt`

`ansible-playbook -i inventory --vault-password-file=password.txt site.yml`

```ini
[seedbox]
123.124.125.126
```

```yaml
---
- hosts: seedbox
  name: Playbook for zero_footprint_qbittorrent_seedbox role
  roles:
    - "zero_footprint_qbittorrent_seedbox"
```

Testing
-------

|OS     |Version 0.0.1     |
|-------|------------------|
|RHEL9  |Not attempted     |
|CentOS9|Not attempted     |

On a brand new RHEL8.6, 1x vCPU, 4GB RAM playbook took 18m 32s to finish on VirtualBox.
On a brand new Red Hat Enterprise Linux release 9.5 (Plow) on AWS (t3.medium), it took 18m 29s.
The following versions were installed during the last RHEL9 test:

|Package name|Package version      |
|------------|---------------------|
|tmux        |3.2a-5.el9.x86_64    |
|vsftpd      |3.0.5-6.el9.x86_64   |

The following Terraform can be used to create necessary infrastructure (based on RHEL9.X on AWS):

`terraform apply -var=key_name=<NAME_OF_THE_EXISTING_KEY_PAIR_IN_AWS>`

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

# Find latest RHEL 9 AMI
data "aws_ami" "rhel9" {
  most_recent = true
  owners      = ["309956199498"] # Red Hat's AWS account ID

  filter {
    name   = "name"
    values = ["RHEL-9*"]
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
resource "aws_security_group" "rhel9_sg" {
  name        = "rhel9_sg"
  description = "Security group for RHEL 9 EC2 seedbox instance"

  tags = {
    Name = "RHEL9-SecurityGroup"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_rtorrent_port_tcp" {
  security_group_id = aws_security_group.rhel9_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 55442
  ip_protocol       = "tcp"
  to_port           = 55442
  description       = "Default rtorrent_port (TCP)"
  tags = {
    Name = "allow_rtorrent_port_tcp"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_rtorrent_port_udp" {
  security_group_id = aws_security_group.rhel9_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 55442
  ip_protocol       = "udp"
  to_port           = 55442
  description       = "Default rtorrent_port (UDP)"
  tags = {
    Name = "allow_rtorrent_port_udp"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_pasv_port_range" {
  security_group_id = aws_security_group.rhel9_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 64000
  ip_protocol       = "tcp"
  to_port           = 64321
  description       = "Default pasv_port_range (TCP)"
  tags = {
    Name = "allow_pasv_port_range"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ftp_port" {
  security_group_id = aws_security_group.rhel9_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 55443
  ip_protocol       = "tcp"
  to_port           = 55443
  description       = "Default ftp_port (TCP)"
  tags = {
    Name = "allow_ftp_port"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.rhel9_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  description       = "Default ruTorrent port (IPv4)"
  tags = {
    Name = "allow_tls_ipv4"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_autobrr_port" {
  security_group_id = aws_security_group.rhel9_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 7474
  ip_protocol       = "tcp"
  to_port           = 7474
  description       = "Default Autobrr port (TCP)"
  tags = {
    Name = "allow_autobrr_port"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_port" {
  security_group_id = aws_security_group.rhel9_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  description       = "Default SSH port (TCP)"
  tags = {
    Name = "allow_ssh_port"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6" {
  security_group_id = aws_security_group.rhel9_sg.id
  cidr_ipv6         = "::/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  description       = "Default ruTorrent port (IPv6)"
  tags = {
    Name = "allow_tls_ipv6"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.rhel9_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.rhel9_sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Create an EC2 instance
resource "aws_instance" "rhel_instance" {
  ami                    = data.aws_ami.rhel9.id
  instance_type          = "t3.medium"
  vpc_security_group_ids = [aws_security_group.rhel9_sg.id]
  key_name               = var.key_name # Replace with your key pair name

  root_block_device {
    volume_size = 15
    volume_type = "gp3"
    encrypted   = true
    tags = {
      Name = "RHEL-9-Seedbox"
    }
  }

  ebs_block_device {
    device_name           = "/dev/sdb"
    volume_size           = 15
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
    tags = {
      Name = "RHEL-9-Seedbox"
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
    Name        = "RHEL-9-Seedbox"
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

Then you can just add `instance_public_ip` to the [inventory](tests/inventory) and run this Ansible role against the EC2 machine like: `time ansible-playbook -i inventory -u ec2-user test.yml --ask-vault-pass` within the [tests](tests/) folder (`cd tests; ln -s ../../zero_footprint_qbittorrent_seedbox .`).

Services Installed
------------------

After you succesfully apply this role, you should be able to see a similar output and access the following services:

|Service               |URL                                                        |
|----------------------|-----------------------------------------------------------|
|autobrr               |https://<IP_ADDR>:<https_port>/autobrr/                    |
|autobrr healthz       |https://<IP_ADDR>:<https_port>/autobrr/api/healthz/liveness|
|ftp                   |ftps://<IP_ADDR>:<ftp_port>                                |
|ssh                   |ssh://<IP_ADDR>:22                                         |
|cross-seed            |http://<127.0.0.1>:2468                                    |

License
-------

MIT

Ansible Galaxy
--------------

[luckylittle.zero_footprint_qbittorrent_seedbox](https://galaxy.ansible.com/ui/standalone/roles/luckylittle/zero_footprint_qbittorrent_seedbox/)

Author Information
------------------

Lucian Maly <<lmaly@redhat.com>>

_Last update: Fri 18 Jul 2025 01:50:43 UTC_
