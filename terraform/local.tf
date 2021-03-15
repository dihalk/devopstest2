#Generate host.ini file to run post ansible playbooks
resource "local_file" "inventory" {
  filename = "./host.ini"
  content  = <<EOF
    [all]
    ${aws_instance.ec2_app1.public_ip}
    ${aws_instance.ec2_app2.public_ip}
    EOF
}