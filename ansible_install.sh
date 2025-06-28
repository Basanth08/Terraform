#!/bin/bash

# Update system packages
sudo yum update -y

# Install Python 3 and pip
sudo yum install python3 -y

# Install EPEL repository and Ansible
sudo amazon-linux-extras install epel -y
sudo yum install ansible -y

# Install Docker
sudo yum install docker -y

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Add ec2-user to docker group
sudo usermod -a -G docker ec2-user

# Install Git (useful for Ansible playbooks)
sudo yum install git -y

# Verify installations
echo "=== Installation Complete ==="
echo "Ansible version:"
ansible --version

echo "Docker version:"
docker --version

echo "Python version:"
python3 --version

echo "Please log out and back in for Docker group changes to take effect"