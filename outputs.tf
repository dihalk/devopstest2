output "vpc_ids" {
    value = module.djangoserver.vpc_id
}

output "subnet1_id" {
    value = module.djangoserver.subnet1_id
}

output "subnet2_id" {
    value = module.djangoserver.subnet2_id
}

output "ec2_1_id" {
    value = module.djangoserver.ec2_1_instance_id
}

output "ec2_2_id" {
    value = module.djangoserver.ec2_2_instance_id
}

output "lb_dns" {
  value = aws_lb.lb_main.dns_name
}