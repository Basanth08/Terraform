output "eip_public_ip" {
    description = "Public IP of EIP"
    value = aws_eip.nat_eip.public_ip
}
output "jenkins_public_ip" {
    description = "Public IP of Jenkins Instance"
    value = aws_instance.Jenkins.public_ip
  
}
output "sonarqube_public_ip" {
    description = "Public IP of SonarQube Instance"
    value = aws_instance.SonarQube.public_ip
}
output "ansible_public_ip" {
    description = "Public IP of Ansible Instance"
    value = aws_instance.Ansible.public_ip
}
output "grafana_public_ip" {
    description = "Public IP of Grafana Instance"
    value = aws_instance.Grafana.public_ip
}