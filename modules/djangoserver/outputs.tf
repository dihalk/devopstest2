
output "vpc_id" {
  value = aws_vpc.vpc_main.id
}

output "subnet1_id" {
  value = aws_subnet.subnet-main[0].id
}

output "subnet2_id" {
  value = aws_subnet.subnet-main[1].id
}

output "ec2_1_public_ip" {
  value = aws_instance.ec2[0].public_ip
}

output "ec2_2_public_ip" {
  value = aws_instance.ec2[1].public_ip

}

output "ec2_1_instance_id" {
  value = aws_instance.ec2[0].id
}

output "ec2_2_instance_id" {
  value = aws_instance.ec2[1].id
}

output "ec2_1_instance_sg" {
  value = aws_security_group.sg-main[0].id
}

output "ec2_2_instance_sg" {
  value = aws_security_group.sg-main[1].id
}