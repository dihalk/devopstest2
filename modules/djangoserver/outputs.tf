
output "VPC-ID" {
  value = aws_vpc.vpc_main.id
}

output "SUBNET-ID-1" {
  value = aws_subnet.subnet-main[0].id
}

output "SUBNET-ID-2" {
  value = aws_subnet.subnet-main[1].id
}

output "EC2-1-Public-IP" {
  value = aws_instance.ec2[0].public_ip
}

output "EC2-2-Public-IP" {
  value = aws_instance.ec2[1].public_ip
}