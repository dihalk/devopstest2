output "VPC-ID" {
  value = aws_vpc.vpc_devopstest.id
}

output "us-east-1a-SUBNET-ID" {
  value = aws_subnet.subnet_1_devopstest.id
}

output "us-east-1b-SUBNET-ID" {
  value = aws_subnet.subnet_2_devopstest.id
}

output "App1-EC2-Node-Public-IP" {
  value = aws_instance.ec2_app1.public_ip
}

output "App2-EC2-Node-Public-IP" {
  value = aws_instance.ec2_app2.public_ip
}

output "App1-EC2-Node-Private-IP" {
  value = aws_instance.ec2_app1.private_ip
}

output "App2-EC2-Node-Private-IP" {
  value = aws_instance.ec2_app2.private_ip
}

output "LB-DNS-NAME" {
  value = aws_lb.django_application_lb.dns_name
}

#output "ECR-REPOSITORY-URL" {
#  value = aws_ecr_repository.django_ecr.repository_url
#}