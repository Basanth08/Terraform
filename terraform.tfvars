region = "us-east-1"
vpc_cidr = "192.168.0.0/16"
all_cidr = "0.0.0.0/0"
public_subnet1_cidr = "192.168.1.0/24"
public_subnet2_cidr = "192.168.2.0/24"
private_subnet_cidr = "192.168.3.0/24"
availability_zone = "us-east-1a"
jenkins_port = "8080"
ssh_port = "22"
sonarqube_port = "9000"
grafana_port = "3000"
http_port = "80"
key_name = "auth_key"
# Replace with your own SSH public key
key_value = "YOUR_SSH_PUBLIC_KEY_HERE"
linux2_ami = "ami-0c6ebb5b9bce4ba15"
ubuntu_ami = "ami-020cba7c55df1f615"
micro_instance = "t2.micro"
small_instance = "t3.small"