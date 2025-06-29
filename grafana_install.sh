#!/bin/bash

# Update system
sudo yum update -y

# Install Docker
sudo yum -y install docker

# Start and enable Docker
sudo systemctl start docker
sudo systemctl enable docker

# Add ec2-user to docker group
sudo usermod -a -G docker ec2-user

# Pull Grafana image
docker pull grafana/grafana

# Create Grafana data directory
sudo mkdir -p /var/lib/grafana
sudo chown 472:472 /var/lib/grafana

# Run Grafana container with persistent storage
docker run -d \
  --name=grafana \
  --restart=unless-stopped \
  -p 3000:3000 \
  -v /var/lib/grafana:/var/lib/grafana \
  -e "GF_SECURITY_ADMIN_PASSWORD=admin" \
  grafana/grafana

# Wait for Grafana to start
sleep 30

# Check if Grafana is running
docker ps | grep grafana

echo "Grafana installation completed!"
echo "Access Grafana at: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):3000"
echo "Default credentials: admin/admin"