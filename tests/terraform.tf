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

resource "aws_vpc_security_group_ingress_rule" "allow_all" {
  security_group_id = aws_security_group.rhel9_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Generally a bad practice, but we need to test firewalld functionality"
  tags = {
    Name = "allow_all"
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
