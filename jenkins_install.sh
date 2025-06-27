#!/bin/bash
sudo yum update -y

# Install Java 11 (use amazon-corretto which is more reliable)
sudo yum install -y java-11-amazon-corretto

# Install wget (not "get")
sudo yum install -y wget

# Download Jenkins repository
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

# Install EPEL repository
sudo amazon-linux-extras install epel -y

# Update system again
sudo yum update -y

# Install Jenkins
sudo yum install -y jenkins

# Start Jenkins service using systemctl (modern way)
sudo systemctl start jenkins

# Enable Jenkins to start at boot
sudo systemctl enable jenkins

# Optional: Check Jenkins status
sudo systemctl status jenkins

# Print the initial admin password location
echo "Jenkins installation completed!"
echo "Initial admin password will be at: /var/lib/jenkins/secrets/initialAdminPassword"
echo "Access Jenkins at: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ip):8080"