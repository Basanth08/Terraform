# Initiate the provider
provider "aws"{
    region = var.region
}

# Create the vpc
resource "aws_vpc" "production_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "Production VPC"
  }
}
# create the internet gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.production_vpc.id
}

# creating an elastic IP associate with NAT gateway
resource "aws_eip" "nat_eip" {
    depends_on = [ aws_internet_gateway.igw ]
}

# create the NAT gateway
resource "aws_nat_gateway" "nat_gw" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id = aws_subnet.public_subnet1.id
    tags ={
        Name ="NAT Gateway"
    }
  
}

# create a public route table
resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.production_vpc.id
    route {
        cidr_block = var.all_cidr
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
        Name = "Public RT"
      
    }
}

# create a private route table
resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.production_vpc.id
    route {
        cidr_block = var.all_cidr
        nat_gateway_id = aws_nat_gateway.nat_gw.id
    }
    tags = {
        Name = "Private RT"
      
    }
}

# Create the public subnet1
resource "aws_subnet" "public_subnet1" {
    vpc_id = aws_vpc.production_vpc.id
    cidr_block = var.public_subnet1_cidr
    availability_zone = var.availability_zone
    map_public_ip_on_launch = true
    tags ={
        Name = "Public subnet 1"
    }
}

# Create the public subnet2
resource "aws_subnet" "public_subnet2" {
    vpc_id = aws_vpc.production_vpc.id
    cidr_block = var.public_subnet2_cidr
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true
    tags ={
        Name = "Public subnet 2"
    }
}

# Create the private subnet
resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.production_vpc.id
    cidr_block = var.private_subnet_cidr
    availability_zone = "us-east-1b"
    tags ={
        Name = "Private subnet"
    }
}

# associate public RT with public subnet1
resource "aws_route_table_association" "public_association1" {
    subnet_id = aws_subnet.public_subnet1.id
    route_table_id = aws_route_table.public_rt.id
}
# associate public RT with public subnet2
resource "aws_route_table_association" "public_association2" {
    subnet_id = aws_subnet.public_subnet2.id
    route_table_id = aws_route_table.public_rt.id
}
# associate public RT with private subnet
resource "aws_route_table_association" "private_association" {
    subnet_id = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.private_rt.id
}
# create Jenkins Security group
resource "aws_security_group" "jenkins_sg" {
    name="Jenkins SG"
    description = "Allow ports 8080 and 22"
    vpc_id = aws_vpc.production_vpc.id

    ingress{
        description = "Jenkins"
        from_port = var.jenkins_port
        to_port = var.jenkins_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
        ingress{
        description = "SSH"
        from_port = var.ssh_port
        to_port = var.ssh_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "Jenkins SG"
    }
}

# create Sonarqube Security group
resource "aws_security_group" "sonarqube_sg" {
    name= "Sonarqube SG"
    description = "Allow ports 9090 and 22"
    vpc_id = aws_vpc.production_vpc.id

    ingress{
        description = "Sonarqube"
        from_port = var.sonarqube_port
        to_port = var.sonarqube_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
        ingress{
        description = "SSH"
        from_port = var.ssh_port
        to_port = var.ssh_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "Sonarqube SG" 
    }
}

# Create Ansible Security group
resource "aws_security_group" "ansible_sg" {
    name= "Ansible SG"
    description = "Allow ports 22"
    vpc_id = aws_vpc.production_vpc.id
    ingress{
        description = "SSH"
        from_port = var.ssh_port
        to_port = var.ssh_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "Ansible SG"
    }
}
# Create Grafana Security group
resource "aws_security_group" "grafana_sg" {
    name= "Grafana SG"
    description = "Allow ports 3000 and 22"
    vpc_id = aws_vpc.production_vpc.id
    ingress{
        description = "Grafana"
        from_port = var.grafana_port
        to_port = var.grafana_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress{
        description = "SSH"
        from_port = var.ssh_port
        to_port = var.ssh_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "Grafana SG"
    }
}
# Create Application Security group
resource "aws_security_group" "app_sg" {
    name= "Application SG"
    description = "Allow ports 80 and 22"
    vpc_id = aws_vpc.production_vpc.id
    ingress{
        description = "Grafana"
        from_port = var.http_port
        to_port = var.http_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress{
        description = "SSH"
        from_port = var.ssh_port
        to_port = var.ssh_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "Application SG"
    }
}
# Create LoadBalancer Security group
resource "aws_security_group" "lb_sg" {
    name= "LoadBalancer SG"
    description = "Allow ports 80"
    vpc_id = aws_vpc.production_vpc.id
    ingress{
        description = "LoadBalancer"
        from_port = var.http_port
        to_port = var.http_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "LoadBalancer SG"
    }
}

# create the ACL
resource "aws_network_acl" "nacl" {
    vpc_id = aws_vpc.production_vpc.id
    subnet_ids = [aws_subnet.public_subnet1.id,aws_subnet.public_subnet2.id,aws_subnet.private_subnet.id]
    egress{
        protocol ="tcp"
        rule_no = "100"
        action = "allow"
        cidr_block = var.all_cidr
        from_port = 0
        to_port = 0
    }
    egress{
        protocol = "-1"
        rule_no = "200"
        action = "allow"
        cidr_block = var.all_cidr
        from_port = 0
        to_port = 0
    }
    ingress{
        protocol ="tcp"
        rule_no = "100"
        action = "allow"
        cidr_block = var.all_cidr
        from_port = var.http_port
        to_port = var.http_port
    }
        ingress{
        protocol ="tcp"
        rule_no = "101"
        action = "allow"
        cidr_block = var.all_cidr
        from_port = var.ssh_port
        to_port = var.ssh_port
    }
        ingress{
        protocol ="tcp"
        rule_no = "102"
        action = "allow"
        cidr_block = var.all_cidr
        from_port = var.jenkins_port
        to_port = var.jenkins_port
    }
        ingress{
        protocol ="tcp"
        rule_no = "103"
        action = "allow"
        cidr_block = var.all_cidr
        from_port = var.sonarqube_port
        to_port = var.sonarqube_port
    }
        ingress{
        protocol ="tcp"
        rule_no = "104"
        action = "allow"
        cidr_block = var.all_cidr
        from_port = var.grafana_port
        to_port = var.grafana_port
    }
    ingress{
    protocol = "tcp"
    rule_no = "300"
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 1024    # Ephemeral ports for return traffic
    to_port = 65535
}
    tags ={
        Name = "Main ACL"
    }
}
# create the ECR repository
resource "aws_ecr_repository" "ecr_repo" {
    name = "docker_repository"

    image_scanning_configuration {
      scan_on_push = true
    }
}

resource "aws_key_pair" "auth_key" {
  key_name = var.key_name
  public_key = var.key_value
}

/*
# create s3 bucket for storing terraform state
resource "aws_s3_bucket" "devops_project_terraform_state_b" {
    bucket = "devops-project-terraform-state-b"  # Fixed naming
    
    tags = {
        Name = "Terraform state bucket"
    }
}

# Separate versioning resource (new syntax)
resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.devops_project_terraform_state_b.id
  versioning_configuration {
    status = "Enabled"
  }
}
*/

/*
# Backend config 
terraform {
    backend "s3" {
        bucket = "devops-project-terraform-state-b"
        key    = "prod/terraform.tfstate"
        region = "us-east-1"
    }
}
*/
# creating the jenkins instance
resource "aws_instance" "Jenkins" {
    ami = var.linux2_ami
    instance_type = var.micro_instance
    availability_zone = var.availability_zone
    subnet_id = aws_subnet.public_subnet1.id
    key_name = var.key_name
    vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
    user_data = file("jenkins_install.sh")
    tags = {
      Name = "Jenkins"
    }
}

# create the SonarQube instance
resource "aws_instance" "SonarQube" {
    ami = var.ubuntu_ami
    instance_type = var.small_instance
    availability_zone = var.availability_zone
    subnet_id = aws_subnet.public_subnet1.id
    key_name = var.key_name
    vpc_security_group_ids = [aws_security_group.sonarqube_sg.id]
    tags = {
      Name = "Sonarqube"
    }
}

# creating the ansible instance
resource "aws_instance" "Ansible" {
    ami = var.linux2_ami
    instance_type = var.micro_instance
    availability_zone = var.availability_zone
    subnet_id = aws_subnet.public_subnet1.id
    key_name = var.key_name
    vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
    user_data = file("ansible_install.sh")
    tags = {
      Name = "Ansible"
    }
}

# Use Launch Template
resource "aws_launch_template" "app-launch-template" {
    name_prefix   = "app-launch-template"
    image_id      = var.linux2_ami
    instance_type = var.micro_instance
    key_name      = var.key_name

    vpc_security_group_ids = [aws_security_group.app_sg.id]

    # Enhanced security
    metadata_options {
        http_endpoint = "enabled"
        http_tokens   = "required"  # Require IMDSv2
    }

    tag_specifications {
        resource_type = "instance"
        tags = {
            Name = "App-Instance"
            Environment = "production"
        }
    }
}

# Auto Scaling Group using Launch Template
resource "aws_autoscaling_group" "app-asg" {
    name                = "app-asg"
    vpc_zone_identifier = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]  # Fixed: Added .id to first subnet
    min_size            = 1
    max_size            = 3
    desired_capacity    = 2
    health_check_type   = "ELB"
    target_group_arns   = [aws_lb_target_group.app-target-group.arn]
    
    launch_template {
        id      = aws_launch_template.app-launch-template.id
        version = "$Latest"
    }

    tag {
        key                 = "Name"
        value               = "App-ASG-Instance"
        propagate_at_launch = true
    }
}

# Load Balancer Target Group
resource "aws_lb_target_group" "app-target-group" {
    name        = "app-target-group"
    port        = 80
    protocol    = "HTTP"
    vpc_id      = aws_vpc.production_vpc.id
    target_type = "instance"
    
    # Health check configuration
    health_check {
        enabled             = true
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 5
        interval            = 30
        path                = "/"
        matcher             = "200"
        protocol            = "HTTP"
        port                = "traffic-port"
    }

    tags = {
        Name = "app-target-group"
    }
}

# Auto Scaling Attachment (Optional - target_group_arns in ASG already handles this)
resource "aws_autoscaling_attachment" "autoscaling-attachment" {
    autoscaling_group_name = aws_autoscaling_group.app-asg.id
    lb_target_group_arn    = aws_lb_target_group.app-target-group.arn  # Fixed: Changed from alb_target_group_arn
}
# Application Load Balancer
resource "aws_lb" "app-lb" {
    name               = "app-lb"
    internal           = false                    # Internet-facing
    load_balancer_type = "application"
    security_groups    = [aws_security_group.lb_sg.id]
    subnets           = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
}

# Load Balancer Listener
resource "aws_lb_listener" "app-listener" {
    load_balancer_arn = aws_lb.app-lb.arn
    port              = "80"
    protocol          = "HTTP"
    
    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.app-target-group.arn
    }
}
